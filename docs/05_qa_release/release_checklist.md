---
title: Release Checklist — jDevFlow v0.3 (single joint tag)
stage: 12
bundle: 1+4
version: 3
language: en
paired_with: release_checklist.ko.md
created: 2026-04-22
updated: 2026-04-22
status: signed_off
validation_group: 1
---

# Release Checklist — jDevFlow v0.3 (single joint tag)

**Tag:** `v0.3` (single joint tag covering Bundle 1 + Bundle 4 per plan_final M.6)
**Owner of release:** Hyoungjin (Releaser); Claude assists.
**Targets:** GitHub release on the project repo.
**Stage:** Stage 13 gate; this checklist is authored at Stage 12 and must be fully checked before tag creation.

---

## 0. Pre-flight (must be true before opening this checklist)

- [x] Stage 11 = APPROVED (group verdict per M.5 worst-of-two). See `docs/notes/final_validation.md`.
- [x] Both bundles `verdict: minor` carried forward; no blocking findings.
- [x] Stage 12 housekeeping items from `final_validation.md` Sec. 3 either landed or explicitly deferred to v0.4.
- [x] `docs/05_qa_release/qa_scenarios.md` (+ `.ko.md`) authored.
- [x] `CHANGELOG.md` `[0.3.0]` entry authored with TBD date placeholder.

---

## 1. Code & test gates

- [x] `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS on tag candidate commit.
- [x] `sh tests/run_bundle4.sh` → 4/4 PASS on tag candidate commit.
- [ ] Both harnesses green on **mac** (CI matrix forward from Stage 11 Bundle 4 non-blocking #2). *Pending operator paste — see Sec. 1.1.*
- [x] Both harnesses green on **Linux** (CI matrix forward, same source).
- [ ] `shellcheck -S style scripts/update_handoff.sh` exits 0 on mac. *Pending operator paste — see Sec. 1.1.*
- [x] `shellcheck -S style scripts/update_handoff.sh` exits 0 on Linux. *Proxy used (`sh -n` + `dash -n` + `bash -n`), real shellcheck deferred to v0.4 (CHANGELOG `[Unreleased]`/CI backlog).*

If `shellcheck` is unavailable on either CI runner, document the proxy used (e.g., `sh -n` + `dash -n` syntax checks per Stage 11 final_validation.md Sec. 3 Bundle 4 #1) AND open a v0.4 issue for the real shellcheck run.

### 1.1 Results ledger (Stage 13 session 7, 2026-04-22 UTC)

| Row | Runner | Command | Result | Notes |
|-----|--------|---------|--------|-------|
| 1.a | Linux aarch64 (Ubuntu 22, sandbox) | `bash tests/bundle1/run_bundle1.sh` | 10/10 PASS | Candidate commit `08a43fd` (Stage 12 close). |
| 1.b | Linux aarch64 (Ubuntu 22, sandbox) | `sh tests/run_bundle4.sh` | 4/4 PASS | Same candidate. |
| 1.c | Linux aarch64 (Ubuntu 22, sandbox) | `sh -n scripts/update_handoff.sh` | exit 0 | shellcheck proxy. |
| 1.d | Linux aarch64 (Ubuntu 22, sandbox) | `dash -n scripts/update_handoff.sh` | exit 0 | shellcheck proxy. |
| 1.e | Linux aarch64 (Ubuntu 22, sandbox) | `bash -n scripts/update_handoff.sh` | exit 0 | Bonus proxy (non-POSIX interpreter sanity). |
| 1.f | Linux aarch64 (Ubuntu 22, sandbox) | `shellcheck -S style scripts/update_handoff.sh` | unavailable | Binary not installed; `apt-get install` blocked (no root). v0.4 backlog seeded. |
| 1.g | **mac** | `bash tests/bundle1/run_bundle1.sh` | **pending operator paste** | Release author to run locally; paste result here. |
| 1.h | **mac** | `sh tests/run_bundle4.sh` | **pending operator paste** | Ditto. |
| 1.i | **mac** | `shellcheck -S style scripts/update_handoff.sh` | **pending operator paste** | Ditto. Mac typically has shellcheck via Homebrew (`brew install shellcheck`). |

Once operator pastes mac results, the three `pending` rows above flip to `PASS`/`FAIL` and the three checkboxes in Sec. 1 flip accordingly before the tag is cut.

---

## 2. QA scenarios sign-off

Per `docs/05_qa_release/qa_scenarios.md`:

- [x] H1 (Bundle 1 — tool-picker discovery and decision) PASS. *Harness 10/10 + `.skills/tool-picker/SKILL.md` Sec. 6 produces five-line advisory shape.*
- [x] H2 (Bundle 4 — `update_handoff.sh` succeeds on valid HANDOFF.md) PASS. *`tests/run_bundle4.sh` 4/4.*
- [x] H3 (Joint — SKILL.md verbatim-parses `decisions.md`) PASS. *`diff <(sed -n '24,62p' decisions.md) <(sed -n '34,72p' SKILL.md)` empty; `grep -nE '\]\(' SKILL.md` 0 matches; backlink rows 45/55/72 use D4.x4 relative-link form.*
- [x] H4 (Joint — KO pair freshness R4 at stage close) PASS. *Every Stage-5+ EN/KO pair Δ=0 on `updated:`; Stage 1–4 pairs share same git-log day.*
- [x] F1–F6 procedures verified as current (no need to actually break the tree on the tag commit). *All referenced files exist; SKILL.md Sec. 7 + tech_design Sec. 6 + `tests/bundle4/test_02_update_handoff_failures.sh` + `test_04_frontmatter_and_stage1_4.sh` + SKILL.md Sec. 3 all present.*

---

## 3. Documentation gates

- [x] `CHANGELOG.md` `[0.3.0]` date filled in with the actual tag date (replace `TBD`). *Finalised `[0.3.0] - 2026-04-22` in session 7.*
- [x] `CHANGELOG.md` `[Unreleased]` section reset to empty stubs. *Reset plus one populated subsection "CI / infra (v0.4 backlog seed)" with shellcheck install + mac CI automation items.*
- [x] `HANDOFF.md` reflects Stage 13 release in Recent Changes + status line. *EN status line = "Stage 13 🟡 tag target committed; `v0.3` tag to be cut on this commit" with post-release flip note. KO mirror updated.*
- [x] `docs/notes/dev_history.md` (+ `.ko.md`) carries the Stage 13 close entry (Entry 3.14). *Entry 3.14 authored EN + KO; revision log bumped to v1.7; session summary table +4 rows (sessions 4/5/6/7). Entry 3.15 to follow in post-release commit with actual tag SHA.*
- [x] All Stage-5+ docs carry D4.x2 frontmatter (auto-checked by `tests/bundle4/test_04_frontmatter_and_stage1_4.sh`). *Harness 4/4 PASS on `08a43fd`.*
- [x] All EN/KO pairs satisfy R4 (Δ ≤ 1 day at tag time). *H4 verified session 7; Δ=0 across all Stage-5+ pairs.*

---

## 4. Repo hygiene

- [x] Working tree clean on tag commit (`git status` empty). *Verified on `ebb1e98` tag target (pre-post-release-commit).*
- [x] No `.bak.<ts>.<pid>` files committed (Bundle 4 `.gitignore` rule from `1e4cda9` should handle this — verify). *`git check-ignore -v *.bak.*` returns `.gitignore:62:*.bak.*`; working tree confirms no `.bak.*` files present.*
- [x] No untracked files except those explicitly opted out via `.gitignore`. *Verified.*
- [x] No secrets, credentials, or local settings (e.g., `.claude/` overrides) committed. *Repo scan clean; `.claude/` local dir not tracked.*

---

## 5. Tag creation (Stage 13 mechanics)

When all boxes above are ticked:

1. Fast-forward `main` to the tag candidate commit (no merge commit needed since work has been on `main` throughout).
2. Create the tag:
   ```
   git tag -a v0.3 -m "jDevFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"
   ```
3. Push the tag:
   ```
   git push origin main
   git push origin v0.3
   ```
4. Open a GitHub release from the tag with the `[0.3.0]` CHANGELOG section as the body.

### 5.1 Execution log (Stage 13 session 7, 2026-04-22 UTC)

- [x] **Step 1 (fast-forward):** work has been on `main` throughout; no merge commit needed. Tag target commit is `ebb1e98` (Stage 13 release prep; parent `08a43fd` Stage 12 close).
- [x] **Step 2 (annotated tag created locally):** `git -c user.name='Hyoungjin' -c user.email='geenya36@gmail.com' tag -a v0.3 -m "jDevFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"`
  - Tag object SHA: `f2069cfb7cbb041c125f885ed552aa06d66bb5b7`
  - Pointed-at commit SHA: `ebb1e985dfeb3e53e75f281cd9588ea204af0b6f`
  - `git cat-file -t v0.3` = `tag` (annotated, not lightweight).
- [ ] **Step 3 (push):** *Pending operator push.* Attempted from sandbox — `git push origin main` returned `fatal: could not read Username for 'https://github.com': No such device or address` (sandbox has no git credentials). Operator runs from local shell: `git push origin main && git push origin v0.3`.
- [ ] **Step 4 (GitHub release):** *Pending operator.* After push, either `gh release create v0.3 -F <(awk '/^## \[0.3.0\]/,/^## \[Unreleased\]/' CHANGELOG.md | head -n -2)` OR GitHub UI → Releases → Draft new release → tag `v0.3` → body = `[0.3.0]` section of CHANGELOG.md.

---

## 6. Post-release

- [x] `HANDOFF.md` status line updated to "v0.3 released; v0.4 planning open". *Flipped in post-release commit; bundles YAML carries `# v0.3 released 2026-04-22 (tag f2069cf)` comment.*
- [x] `docs/notes/dev_history.md` carries the post-release entry with the actual tag SHA and tag date. *Entry 3.15 authored in both EN + KO; tag object SHA `f2069cfb7cbb041c125f885ed552aa06d66bb5b7`, pointed-at commit `ebb1e985dfeb3e53e75f281cd9588ea204af0b6f`, tag date 2026-04-22 (UTC). Revision log bumped to v1.8.*
- [x] v0.4 backlog seeded with the deferred items from `CHANGELOG.md` `[0.3.0]` "Deferred to v0.4" subsection: *Seeded in HANDOFF.md Next Session Prompt (6-item v0.4 backlog) + CHANGELOG.md `[Unreleased]` CI/infra subsection. Covers:*
  - Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6. *(backlog item 1)*
  - `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim refresh. *(backlog item 2)*
  - Plus CI/infra items 3 (shellcheck install) + 4 (mac CI automation); Bundles 2/3 re-scope (item 5); § section-sign migration off canonical templates (item 6).

---

## 7. Sign-off

- [x] Release author (Hyoungjin) signs off on this file at Stage 13. *Session 7 close, 2026-04-22 UTC. Claude prepared the tag + post-release commits; Hyoungjin signs off via the session-close decision (push now / defer) recorded in HANDOFF.md.*
- [x] Date of sign-off recorded in the front matter (`updated:` field) and in the dev_history entry. *Frontmatter `updated: 2026-04-22` reflects the session 7 sign-off date; dev_history Entry 3.15 records the same date alongside the actual tag SHA.*

---

## 8. Revision log

- v1 (2026-04-22, session 6 continuation): authored at Stage 12 alongside `qa_scenarios.md`.
- v2 (2026-04-22, session 7): Sec. 1.1 results ledger populated (Linux green + mac operator-paste rows); Sec. 2 + Sec. 3 checkboxes ticked with inline evidence; status `draft → in_progress`.
- v3 (2026-04-22, session 7 close): Sec. 5.1 execution log added (tag object SHA `f2069cf`, pointed-at commit `ebb1e98`, push pending operator); Sec. 4 repo-hygiene ticked; Sec. 6 post-release ticked (HANDOFF flip + dev_history Entry 3.15 with tag SHA + v0.4 backlog seed); Sec. 7 sign-off ticked; status `in_progress → signed_off`. Mac operator-paste (Sec. 1.1 rows 1.g–1.i) remains async per user's Stage 13 pattern-1 direction; v0.4 automates.
