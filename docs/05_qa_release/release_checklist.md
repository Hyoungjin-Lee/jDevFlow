---
title: Release Checklist — jOneFlow v0.3 (single joint tag)
stage: 12
bundle: 1+4
version: 1
language: en
paired_with: release_checklist.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Release Checklist — jOneFlow v0.3 (single joint tag)

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

- [ ] `bash tests/bundle1/run_bundle1.sh` → 10/10 PASS on tag candidate commit.
- [ ] `sh tests/run_bundle4.sh` → 4/4 PASS on tag candidate commit.
- [ ] Both harnesses green on **mac** (CI matrix forward from Stage 11 Bundle 4 non-blocking #2).
- [ ] Both harnesses green on **Linux** (CI matrix forward, same source).
- [ ] `shellcheck -S style scripts/update_handoff.sh` exits 0 on mac.
- [ ] `shellcheck -S style scripts/update_handoff.sh` exits 0 on Linux.

If `shellcheck` is unavailable on either CI runner, document the proxy used (e.g., `sh -n` + `dash -n` syntax checks per Stage 11 final_validation.md Sec. 3 Bundle 4 #1) AND open a v0.4 issue for the real shellcheck run.

---

## 2. QA scenarios sign-off

Per `docs/05_qa_release/qa_scenarios.md`:

- [ ] H1 (Bundle 1 — tool-picker discovery and decision) PASS.
- [ ] H2 (Bundle 4 — `update_handoff.sh` succeeds on valid HANDOFF.md) PASS.
- [ ] H3 (Joint — SKILL.md verbatim-parses `decisions.md`) PASS.
- [ ] H4 (Joint — KO pair freshness R4 at stage close) PASS.
- [ ] F1–F6 procedures verified as current (no need to actually break the tree on the tag commit).

---

## 3. Documentation gates

- [ ] `CHANGELOG.md` `[0.3.0]` date filled in with the actual tag date (replace `TBD`).
- [ ] `CHANGELOG.md` `[Unreleased]` section reset to empty stubs.
- [ ] `HANDOFF.md` reflects Stage 13 release in Recent Changes + status line.
- [ ] `docs/notes/dev_history.md` (+ `.ko.md`) carries the Stage 13 close entry (Entry 3.14 or next).
- [ ] All Stage-5+ docs carry D4.x2 frontmatter (auto-checked by `tests/bundle4/test_04_frontmatter_and_stage1_4.sh`).
- [ ] All EN/KO pairs satisfy R4 (Δ ≤ 1 day at tag time).

---

## 4. Repo hygiene

- [ ] Working tree clean on tag commit (`git status` empty).
- [ ] No `.bak.<ts>.<pid>` files committed (Bundle 4 `.gitignore` rule from `1e4cda9` should handle this — verify).
- [ ] No untracked files except those explicitly opted out via `.gitignore`.
- [ ] No secrets, credentials, or local settings (e.g., `.claude/` overrides) committed.

---

## 5. Tag creation (Stage 13 mechanics)

When all boxes above are ticked:

1. Fast-forward `main` to the tag candidate commit (no merge commit needed since work has been on `main` throughout).
2. Create the tag:
   ```
   git tag -a v0.3 -m "jOneFlow v0.3 — Bundle 1 (tool-picker) + Bundle 4 (doc-discipline, option β); joint release per M.6"
   ```
3. Push the tag:
   ```
   git push origin main
   git push origin v0.3
   ```
4. Open a GitHub release from the tag with the `[0.3.0]` CHANGELOG section as the body.

---

## 6. Post-release

- [ ] `HANDOFF.md` status line updated to "v0.3 released; v0.4 planning open".
- [ ] `docs/notes/dev_history.md` carries the post-release entry with the actual tag SHA and tag date.
- [ ] v0.4 backlog seeded with the deferred items from `CHANGELOG.md` `[0.3.0]` "Deferred to v0.4" subsection:
  - Live tool-picker triple refresh in `.skills/tool-picker/SKILL.md` Sec. 6.
  - `docs/03_design/bundle1_tool_picker/technical_design.md` Sec. 0 verbatim refresh.

---

## 7. Sign-off

- [ ] Release author (Hyoungjin) signs off on this file at Stage 13.
- [ ] Date of sign-off recorded in the front matter (`updated:` field) and in the dev_history entry.

---

## 8. Revision log

- v1 (2026-04-22, session 6 continuation): authored at Stage 12 alongside `qa_scenarios.md`.
