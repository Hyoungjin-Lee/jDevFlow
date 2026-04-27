#!/bin/sh
# settings.sh — POSIX reader/writer for .claude/settings.json (schema v0.4 + v0.5).
#
# Public API (sourced by scripts/*.sh):
#   settings_path
#   settings_require_v04            # v0.5 grace period — accepts "0.4" OR "0.5"
#   settings_require_v05            # v0.6.6 신규 — strict "0.5" 검증
#   settings_read_key KEY
#   settings_read_stage_assign STAGE_KEY
#   settings_read_stage_assign_compat NEO_KEY LEGACY_KEY  # v0.6.6 — neo 우선 + legacy fallback
#   settings_write_key KEY VALUE
#   settings_write_stage_assign_block TEAM_MODE  # legacy 4 + neo 4 동시 쓰기
#
# Constraints (tech_design.md Sec 2.3, Sec 8.1, Sec 12.3):
#   - No jq (F-D2).
#   - No sed -i (macOS BSD vs GNU incompatibility). Always: temp file -> mv.
#   - POSIX-only: no `local`, no `[[ ]]`, no process substitution.
#   - 2-space top-level indent, 1 key per line, unique key name per file.
#
# Exit codes (Sec 9.1):
#   3 = schema mismatch / upgrade required
#   5 = settings.json format corruption / key missing
#
# Callers should provide JONEFLOW_ROOT env var (project root). If unset,
# settings_path falls back to deriving from this file's location.

# ---- path ----

settings_path() {
    _sp_root="${JONEFLOW_ROOT:-}"
    if [ -z "$_sp_root" ]; then
        # shellcheck disable=SC1007  # CDPATH= is the standard unset-and-cd idiom.
        _sp_here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
        # When sourced by scripts/*.sh at repo root, $0 may be in scripts/ or tests/.
        # Walk upward until we find .claude/settings.json OR CLAUDE.md anchor.
        _sp_try="$_sp_here"
        while [ "$_sp_try" != "/" ] && [ -n "$_sp_try" ]; do
            if [ -f "$_sp_try/.claude/settings.json" ] || [ -f "$_sp_try/CLAUDE.md" ]; then
                _sp_root="$_sp_try"
                break
            fi
            _sp_try=$(dirname -- "$_sp_try")
        done
    fi
    if [ -z "$_sp_root" ]; then
        echo ".claude/settings.json"
    else
        echo "$_sp_root/.claude/settings.json"
    fi
}

# ---- helpers (private) ----

# die CODE MESSAGE
_settings_die() {
    _sd_code="$1"
    shift
    printf 'settings.sh: %s\n' "$*" >&2
    exit "$_sd_code"
}

# Validate key name: [A-Za-z_][A-Za-z0-9_]*
_settings_valid_key() {
    _svk_k="$1"
    case "$_svk_k" in
        '' ) return 1 ;;
        [!A-Za-z_]* ) return 1 ;;
    esac
    # reject any char outside safelist
    _svk_rest=$(printf '%s' "$_svk_k" | tr -d 'A-Za-z0-9_')
    [ -z "$_svk_rest" ]
}

# Validate value: printable, no double-quote, no backslash, no newline.
_settings_valid_value() {
    _svv_v="$1"
    case "$_svv_v" in
        *'"'* ) return 1 ;;
        *'\'* ) return 1 ;;
    esac
    # reject newline by comparing byte count before/after tr
    _svv_stripped=$(printf '%s' "$_svv_v" | tr -d '\n\r')
    [ "$(printf '%s' "$_svv_v" | wc -c)" = "$(printf '%s' "$_svv_stripped" | wc -c)" ]
}

# ---- public API ----

# settings_require_v04  (v0.6.6 R-1 reviewer — 사용 가이드 명확화)
#   v0.6.6 grace period — accepts schema "0.4" OR "0.5".
#   exits 3 if schema_version is not in {0.4, 0.5} or file missing.
#
#   사용 가이드 (R-1 정정):
#   - 13-stage flow + 16-stage flow 양쪽 호환이 필요한 진입점에서 호출.
#     (예: switch_team.sh, --status 류 read-only 명령)
#   - 16-stage 의무 동작(neo 키만 사용)이 필요하면 settings_require_v05 호출.
#   - 함수명 `_v04`은 historical (v0.4 시절 명명). v0.7에서 settings_require_supported로
#     rename 예정 (현재는 호환성 위해 명칭 유지).
#   다음 메이저 버전(v0.7+)에서 "0.4" 허용 폐기 + 함수명 정리 예정.
settings_require_v04() {
    _sr_file=$(settings_path)
    if [ ! -f "$_sr_file" ]; then
        _settings_die 3 "settings.json 없음: $_sr_file (init_project.sh 실행 필요)"
    fi
    _sr_ver=$(sed -n 's/^  "schema_version": *"\([^"]*\)".*/\1/p' "$_sr_file")
    case "$_sr_ver" in
        0.4|0.5) : ;;
        *) _settings_die 3 "schema_version=\"$_sr_ver\" (요구: \"0.4\" 또는 \"0.5\"). init_project.sh --force-reinit 실행." ;;
    esac
}

# settings_require_v05  (v0.6.6 신규)
#   strict "0.5" 검증. 16-stage flow 진입 의무 영역에서 호출.
settings_require_v05() {
    _sr5_file=$(settings_path)
    if [ ! -f "$_sr5_file" ]; then
        _settings_die 3 "settings.json 없음: $_sr5_file (init_project.sh 실행 필요)"
    fi
    _sr5_ver=$(sed -n 's/^  "schema_version": *"\([^"]*\)".*/\1/p' "$_sr5_file")
    if [ "$_sr5_ver" != "0.5" ]; then
        _settings_die 3 "schema_version=\"$_sr5_ver\" (16-stage flow 요구: \"0.5\"). init_project.sh --force-reinit 실행."
    fi
}

# settings_read_key KEY
#   Echo top-level string value (2-space indent). Empty string if absent.
settings_read_key() {
    _srk_key="$1"
    if ! _settings_valid_key "$_srk_key"; then
        _settings_die 5 "유효하지 않은 키 이름: '$_srk_key'"
    fi
    _srk_file=$(settings_path)
    if [ ! -f "$_srk_file" ]; then
        printf ''
        return 0
    fi
    # Match exactly 2-space indent + "KEY": "VALUE" (trailing comma optional).
    sed -n 's/^  "'"$_srk_key"'": *"\([^"]*\)".*/\1/p' "$_srk_file" | sed -n '1p'
}

# settings_read_stage_assign STAGE_KEY
#   Echo stage_assignments.<STAGE_KEY> value (4-space indent). Empty if absent.
settings_read_stage_assign() {
    _sra_key="$1"
    if ! _settings_valid_key "$_sra_key"; then
        _settings_die 5 "유효하지 않은 stage 키: '$_sra_key'"
    fi
    _sra_file=$(settings_path)
    if [ ! -f "$_sra_file" ]; then
        printf ''
        return 0
    fi
    sed -n 's/^    "'"$_sra_key"'": *"\([^"]*\)".*/\1/p' "$_sra_file" | sed -n '1p'
}

# settings_read_stage_assign_compat NEO_KEY LEGACY_KEY  (v0.6.6 신규)
#   16-stage neo 키 우선 read. 비어있으면 13-stage legacy 키 fallback.
#   neo + legacy 모두 비면 빈 문자열 반환.
#   호출 예: settings_read_stage_assign_compat stage11_impl stage8_impl
settings_read_stage_assign_compat() {
    _srac_neo="$1"
    _srac_legacy="$2"
    if [ -z "$_srac_neo" ] || [ -z "$_srac_legacy" ]; then
        _settings_die 5 "settings_read_stage_assign_compat: NEO_KEY/LEGACY_KEY 인자 누락."
    fi
    _srac_v=$(settings_read_stage_assign "$_srac_neo")
    if [ -n "$_srac_v" ]; then
        printf '%s' "$_srac_v"
        return 0
    fi
    settings_read_stage_assign "$_srac_legacy"
}

# settings_write_key KEY VALUE
#   Atomic replace of top-level "KEY": "VALUE". die 5 if key absent.
#   Uses temp file -> mv. Preserves trailing comma if present.
settings_write_key() {
    _swk_key="$1"
    _swk_val="$2"
    if ! _settings_valid_key "$_swk_key"; then
        _settings_die 5 "유효하지 않은 키 이름: '$_swk_key'"
    fi
    if ! _settings_valid_value "$_swk_val"; then
        _settings_die 5 "값에 허용되지 않은 문자 포함 (따옴표/백슬래시/개행 금지): '$_swk_val'"
    fi
    _swk_file=$(settings_path)
    if [ ! -f "$_swk_file" ]; then
        _settings_die 4 "settings.json 없음: $_swk_file"
    fi

    # Verify key exists exactly once (AC-5-1 uniqueness).
    _swk_hits=$(grep -c '^  "'"$_swk_key"'":' "$_swk_file" || true)
    if [ "$_swk_hits" = "0" ]; then
        _settings_die 5 "키 '$_swk_key' 부재. 스키마 손상 또는 업그레이드 필요."
    fi
    if [ "$_swk_hits" != "1" ]; then
        _settings_die 5 "키 '$_swk_key' 중복 ($_swk_hits hits). 스키마 손상."
    fi

    _swk_tmp=$(mktemp "${TMPDIR:-/tmp}/settings.XXXXXX") || _settings_die 5 "mktemp 실패"
    # Preserve whether line had trailing comma. We use sed with two patterns.
    # Pattern A: line ends with `",` (comma).
    # Pattern B: line ends with `"` (no comma, last entry).
    if sed '
s|^  "'"$_swk_key"'": *"[^"]*",$|  "'"$_swk_key"'": "'"$_swk_val"'",|
s|^  "'"$_swk_key"'": *"[^"]*"$|  "'"$_swk_key"'": "'"$_swk_val"'"|
' "$_swk_file" > "$_swk_tmp"; then
        # Verify the replacement actually took effect.
        _swk_new=$(sed -n 's/^  "'"$_swk_key"'": *"\([^"]*\)".*/\1/p' "$_swk_tmp" | sed -n '1p')
        if [ "$_swk_new" != "$_swk_val" ]; then
            rm -f "$_swk_tmp"
            _settings_die 5 "쓰기 실패: 교체 후 값 불일치 (got='$_swk_new', want='$_swk_val'). 원본 보존."
        fi
        if ! mv "$_swk_tmp" "$_swk_file"; then
            rm -f "$_swk_tmp"
            _settings_die 5 "원자적 mv 실패. 원본 보존."
        fi
    else
        rm -f "$_swk_tmp"
        _settings_die 5 "sed 쓰기 실패. 원본 보존."
    fi
}

# settings_write_stage_assign_block TEAM_MODE
#   Update stage_assignments 4 lines atomically based on Sec 2.5 mapping.
#   Also updates team_mode key to the given value.
settings_write_stage_assign_block() {
    _swsa_mode="$1"
    case "$_swsa_mode" in
        claude-only)
            _swsa_s8=claude; _swsa_s9=claude; _swsa_s10=claude ;;
        claude-impl-codex-review)
            _swsa_s8=claude; _swsa_s9=codex;  _swsa_s10=claude ;;
        codex-impl-claude-review)
            _swsa_s8=codex;  _swsa_s9=claude; _swsa_s10=codex  ;;
        *)
            _settings_die 2 "알 수 없는 team_mode: '$_swsa_mode' (허용: claude-only|claude-impl-codex-review|codex-impl-claude-review)"
            ;;
    esac
    # stage11_verify is always claude (Sec 2.4).
    _swsa_s11=claude

    _swsa_file=$(settings_path)
    if [ ! -f "$_swsa_file" ]; then
        _settings_die 4 "settings.json 없음: $_swsa_file"
    fi

    # Verify team_mode + legacy 4 keys exist exactly once each.
    # neo 4 키(stage11_impl/stage12_review/stage13_fix/stage14_verify)는 v0.5 schema에서만 존재.
    # v0.4 schema 호환을 위해 neo 키는 best-effort (있으면 함께 갱신, 없으면 스킵).
    _swsa_h=$(grep -c '^  "team_mode":' "$_swsa_file" || true)
    if [ "$_swsa_h" != "1" ]; then
        _settings_die 5 "키 'team_mode' hits=$_swsa_h (기대 1). 스키마 손상."
    fi
    for _swsa_k in stage8_impl stage9_review stage10_fix stage11_verify; do
        _swsa_h=$(grep -c '^    "'"$_swsa_k"'":' "$_swsa_file" || true)
        if [ "$_swsa_h" != "1" ]; then
            _settings_die 5 "키 'stage_assignments.$_swsa_k' hits=$_swsa_h (기대 1). 스키마 손상."
        fi
    done
    # neo 키 감지 (v0.5 schema 여부 판정).
    _swsa_has_neo=1
    for _swsa_nk in stage11_impl stage12_review stage13_fix stage14_verify; do
        _swsa_nh=$(grep -c '^    "'"$_swsa_nk"'":' "$_swsa_file" || true)
        if [ "$_swsa_nh" != "1" ]; then
            _swsa_has_neo=0
        fi
    done

    _swsa_tmp=$(mktemp "${TMPDIR:-/tmp}/settings.XXXXXX") || _settings_die 5 "mktemp 실패"
    sed '
s|^  "team_mode": *"[^"]*",$|  "team_mode": "'"$_swsa_mode"'",|
s|^  "team_mode": *"[^"]*"$|  "team_mode": "'"$_swsa_mode"'"|
s|^    "stage8_impl": *"[^"]*",$|    "stage8_impl": "'"$_swsa_s8"'",|
s|^    "stage8_impl": *"[^"]*"$|    "stage8_impl": "'"$_swsa_s8"'"|
s|^    "stage9_review": *"[^"]*",$|    "stage9_review": "'"$_swsa_s9"'",|
s|^    "stage9_review": *"[^"]*"$|    "stage9_review": "'"$_swsa_s9"'"|
s|^    "stage10_fix": *"[^"]*",$|    "stage10_fix": "'"$_swsa_s10"'",|
s|^    "stage10_fix": *"[^"]*"$|    "stage10_fix": "'"$_swsa_s10"'"|
s|^    "stage11_verify": *"[^"]*",$|    "stage11_verify": "'"$_swsa_s11"'",|
s|^    "stage11_verify": *"[^"]*"$|    "stage11_verify": "'"$_swsa_s11"'"|
s|^    "stage11_impl": *"[^"]*",$|    "stage11_impl": "'"$_swsa_s8"'",|
s|^    "stage11_impl": *"[^"]*"$|    "stage11_impl": "'"$_swsa_s8"'"|
s|^    "stage12_review": *"[^"]*",$|    "stage12_review": "'"$_swsa_s9"'",|
s|^    "stage12_review": *"[^"]*"$|    "stage12_review": "'"$_swsa_s9"'"|
s|^    "stage13_fix": *"[^"]*",$|    "stage13_fix": "'"$_swsa_s10"'",|
s|^    "stage13_fix": *"[^"]*"$|    "stage13_fix": "'"$_swsa_s10"'"|
s|^    "stage14_verify": *"[^"]*",$|    "stage14_verify": "'"$_swsa_s11"'",|
s|^    "stage14_verify": *"[^"]*"$|    "stage14_verify": "'"$_swsa_s11"'"|
' "$_swsa_file" > "$_swsa_tmp" || {
        rm -f "$_swsa_tmp"
        _settings_die 5 "sed 쓰기 실패. 원본 보존."
    }

    # Post-write verification.
    _swsa_got_mode=$(sed -n 's/^  "team_mode": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
    _swsa_got_s8=$(sed -n 's/^    "stage8_impl": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
    _swsa_got_s9=$(sed -n 's/^    "stage9_review": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
    _swsa_got_s10=$(sed -n 's/^    "stage10_fix": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
    _swsa_got_s11=$(sed -n 's/^    "stage11_verify": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')

    if [ "$_swsa_got_mode" != "$_swsa_mode" ] \
        || [ "$_swsa_got_s8"  != "$_swsa_s8"  ] \
        || [ "$_swsa_got_s9"  != "$_swsa_s9"  ] \
        || [ "$_swsa_got_s10" != "$_swsa_s10" ] \
        || [ "$_swsa_got_s11" != "$_swsa_s11" ]; then
        rm -f "$_swsa_tmp"
        _settings_die 5 "team_mode/stage_assignments 블록 교체 후 값 불일치. 원본 보존."
    fi

    # neo 키 검증 (v0.5 schema에서만).
    if [ "$_swsa_has_neo" = "1" ]; then
        _swsa_got_n8=$(sed -n 's/^    "stage11_impl": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
        _swsa_got_n9=$(sed -n 's/^    "stage12_review": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
        _swsa_got_n10=$(sed -n 's/^    "stage13_fix": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
        _swsa_got_n11=$(sed -n 's/^    "stage14_verify": *"\([^"]*\)".*/\1/p' "$_swsa_tmp" | sed -n '1p')
        if [ "$_swsa_got_n8"  != "$_swsa_s8"  ] \
            || [ "$_swsa_got_n9"  != "$_swsa_s9"  ] \
            || [ "$_swsa_got_n10" != "$_swsa_s10" ] \
            || [ "$_swsa_got_n11" != "$_swsa_s11" ]; then
            rm -f "$_swsa_tmp"
            _settings_die 5 "stage_assignments neo(v0.5) 블록 교체 후 값 불일치. 원본 보존."
        fi
    fi

    if ! mv "$_swsa_tmp" "$_swsa_file"; then
        rm -f "$_swsa_tmp"
        _settings_die 5 "원자적 mv 실패. 원본 보존."
    fi
}

# v0.6.2 (planning_04 F-04-3, technical_design Sec.5.10): frontmatter 필드 갱신.
# Usage: _frontmatter_set_field <file> <key> <value>
# Effect: <file>의 YAML frontmatter (--- ... ---) 안의 <key>: <value> 갱신.
#         키 부재 시 frontmatter 끝부분에 추가.
#         BSD sed와 GNU sed 모두 호환 (awk 기반, sed -i 분기 회피).
# Returns: 0 (성공), 1 (frontmatter 부재), 2 (인자 부족 또는 파일 부재).
_frontmatter_set_field() {
    _fmsf_file="$1"
    _fmsf_key="$2"
    _fmsf_value="$3"
    if [ "$#" -ne 3 ]; then
        return 2
    fi
    if [ ! -f "$_fmsf_file" ]; then
        return 2
    fi
    if ! head -1 "$_fmsf_file" 2>/dev/null | grep -q '^---$'; then
        return 1
    fi

    _fmsf_tmp="${_fmsf_file}.tmp.$$"
    awk -v key="$_fmsf_key" -v val="$_fmsf_value" '
        BEGIN { in_fm=0; done=0; closed=0 }
        NR==1 && /^---$/ { in_fm=1; print; next }
        in_fm == 1 && closed == 0 && /^---$/ {
            if (done == 0) {
                print key ": " val
                done=1
            }
            closed=1
            print
            next
        }
        in_fm == 1 && closed == 0 && /^[A-Za-z_][A-Za-z0-9_-]*:/ {
            split($0, parts, ":")
            if (parts[1] == key) {
                if (done == 0) {
                    print key ": " val
                    done=1
                }
                next
            }
            print
            next
        }
        { print }
    ' "$_fmsf_file" > "$_fmsf_tmp" && mv "$_fmsf_tmp" "$_fmsf_file"
}
