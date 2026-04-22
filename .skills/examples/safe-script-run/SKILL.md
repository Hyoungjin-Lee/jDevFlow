# Skill: Safe Script Run

> Run a project script safely: dry-run first, secrets via keychain, verify before committing.

---

## 1. Purpose

Execute a project Python script (typically in `src/`) without leaking secrets or producing irreversible side effects on the first pass.

## 2. When to Use

Read this skill when **any** of the following is true:

- User asks for: "run `src/...`", "execute the main script", "try the new command"
- Current stage is: Stage 8 (Implementation) or Stage 10 (Revision) verification
- The target script reads from an external service (API, DB, webhook)

Do NOT read this skill when:

- The user explicitly asks for a production run (then consult the release checklist instead)
- The script is a pure unit test runner (`pytest`, `unittest`)

## 3. Do

- Read the target script first; identify any network calls, file writes, or external effects
- Run once with `--dry-run` before any real execution
- Load secrets via `from security.secret_loader import load_secret`
- Capture stdout and stderr; review them before moving on
- Run `python3 -m py_compile <file>` on the script if it was modified in this session

## 4. Don't

- Do NOT run the script without `--dry-run` on the first invocation
- Do NOT paste secrets into the command line or echo them
- Do NOT read `.env` or `.env.example` for real credential values — they only hold key names
- Do NOT commit output files that contain secrets, tokens, or personal data

## 5. Red Flags — stop and ask

- Any API token, account number, or password appears in stdout/stderr
- Script attempts to write to a path outside the project root
- Dry-run output already shows non-zero exit or traceback
- Row count, row size, or request rate is orders of magnitude larger than expected
- Script tries to delete files it did not create

## 6. Good / Bad

**Good**

```bash
python3 src/generate_report.py --dry-run
# stderr is empty, stdout shows the expected preview
python3 -m py_compile src/generate_report.py
python3 src/generate_report.py
```

Why: dry-run + compile check happen before the real run.

**Bad**

```bash
MY_API_KEY="sk-live-xxx" python3 src/generate_report.py
```

Why: the secret is now in shell history, environment, and potentially logs.

## 7. Checklist

- [ ] Target script identified and skimmed
- [ ] `--dry-run` completed without error
- [ ] `py_compile` passed (if the file was changed this session)
- [ ] Secrets loaded via `secret_loader.py` only (no `.env` values hardcoded)
- [ ] No secret appeared in logs or stdout
- [ ] Real run output reviewed and matches dry-run expectations

## 8. Verification

```bash
# Compile check
python3 -m py_compile src/generate_report.py

# Quick grep — should return nothing
grep -E '(sk-|pk_live|AKIA|ghp_)' logs/*.log || echo "no obvious secret patterns"
```

Or point to: `docs/04_implementation/implementation_progress.md` with the dry-run output linked.

---

## Prerequisites

- `security/secret_loader.py` wired up
- Required secret key names listed in `.env.example`

## Rollback

- If the script wrote to `data/`, restore from the most recent `git checkout -- data/...` (only if data files are tracked)
- If the script contacted an external service, log the operation in `docs/notes/decisions.md` even if it succeeded, so the handoff is auditable

## Notes

- This skill intentionally prefers `--dry-run` over confident one-shot runs. If the script has no dry-run mode, add one before relying on it.
