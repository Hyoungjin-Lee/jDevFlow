# Skill: Tool Picker

> Decide which executor and UI tool to use at Stage 5 / 6 / 8 (and re-decide at Stage 10 when needed), so the same inputs always yield the same recommendation.

---

## 1. Purpose

Return a consistent `(executor, ui_tool, reason)` triple whenever a jOneFlow project enters a stage that needs to pick an implementation subject or a UI tool. This externalises the logic described in `prompts/claude/v03_kickoff.md` → "Resolved decisions D-A ~ D-D" so that no prompt has to hard-code if-then rules.

## 2. When to Use

Read this skill when **any** of the following is true:

- Current stage is Stage 5 (Technical Design), Stage 6 (UI Requirements), Stage 7 (UI Flow), or Stage 8 (Implementation)
- Entering Stage 10 (Revision) AND the Stage 9 review verdict was **design-level** (architecture / schema / UI flow rework). See D-D.
- The user asks "who should implement this?", "which UI tool fits?", or "re-evaluate the executor."

Do NOT read this skill when:

- Stage is 1–4 (planning phase — no executor or UI tool needed yet)
- Lite-mode single-line doc fix (too small to pick; default to Claude inline)
- The user has already **explicitly overridden** the executor or UI tool earlier in the same session
- Stage 10 entry but the Stage 9 verdict was "minor" or "bug fix" (D-D: keep Stage 8 executor, skip this skill)

## 3. Do

- Read the 4 inputs from `HANDOFF.md` and the current stage doc:
  - `mode` — Lite / Standard / Strict (HANDOFF.md)
  - `has_ui` — true / false (HANDOFF.md)
  - `change_size` — `small | medium | large` (enum; see mapping below) from `docs/02_planning/plan_final.md` → Success Criteria
  - `design_complexity` — low / medium / high (from `docs/03_design/technical_design.md` or `ui_requirements.md`)

  `change_size` enum mapping (reference — guideline, not strict threshold):
  - `small` — ≤ 20 lines changed, single function
  - `medium` — 20–100 lines, 1–2 files
  - `large` — > 100 lines, multi-file, or a new file

- Apply the **Recommendation Matrix** below to derive `executor`, `ui_tool`, `reason`
- **Present** the recommendation to the user as a choice (Codex / Claude / Custom for executor; Antigravity / Claude Design / Figma / Custom for UI tool). The user may accept or override.
- Record the **final** choice in two places (D-C hybrid storage):
  - `HANDOFF.md` → "current tools" field — current-cycle selection
  - `docs/notes/dev_history.md` → append an entry `Stage <N> executor: <X> | ui_tool: <Y> | reason: <...>`
- If the user picks "Custom" **and** asks to remember it, append to `.claude/tools.json` as a new catalog entry (project-scope persistent store).

## 4. Don't

- Do NOT hardcode the recommendation logic inside a prompt (e.g., `technical_design.md`, `planning_final.md`). Always route through this skill. (D-B)
- Do NOT skip the user-confirmation step. This skill **recommends**; the user **decides**.
- Do NOT write the user's pick straight to `.claude/tools.json` unless they chose "Custom" **and** asked for it to be saved.
- Do NOT pick a UI tool if `has_ui = false`. Return `ui_tool = none` with reason `"has_ui=false"`.
- Do NOT drive the UI tool directly via MCP in v0.3 (Model B). Model A is the contract: Claude writes spec → user/tool builds → Claude reviews. MCP direct driving is reserved for the `ui_auto` flag in v1.0. (D-A)

## 5. Red Flags — stop and ask

- `mode` and `change_size` disagree (e.g., `mode = Lite` but `change_size > 100 lines`) → run `.skills/mode-picker` first, then return here
- User picks "Custom" but supplies no tool name or spec
- `has_ui = false` in HANDOFF.md but current stage is 6 or 7 → data inconsistency, stop and reconcile
- Stage 10 entry and the Stage 9 verdict field is missing or unparseable → the D-D trigger cannot be evaluated
- The Recommendation Matrix returns contradictory outputs (e.g., Codex recommended on executor axis, Claude forced by `.claude/tools.json` default) → surface both to the user, do not silently resolve

## 6. Good / Bad

**Good**

```
Inputs (read from HANDOFF.md + plan_final.md + ui_requirements.md):
  mode = Standard
  has_ui = true
  change_size = large
  design_complexity = medium

Matrix output:
  executor = Codex
  ui_tool  = Antigravity
  reason   = "large multi-file change with wireframe-stage UI → Codex + Antigravity"

Presented to user as a choice. User: "Codex OK. UI tool: Figma instead."
Recorded:
  HANDOFF.md "current tools": executor=Codex, ui_tool=Figma
  dev_history.md: "Stage 8 executor: Codex | ui_tool: Figma | reason: user override (design handoff needed)"
```

Why: all 4 inputs read; recommendation derived from the matrix; user override respected; both storage locations updated per D-C.

**Bad**

```
Inputs: mode=Lite, has_ui=false
Skill picks: Codex + Figma (user not asked, has_ui ignored)
```

Why: UI tool picked despite `has_ui = false`; Codex is overkill for Lite single-function changes; user confirmation skipped.

**Minimal Example**

```
Input:
  mode = Standard
  has_ui = true
  change_size = medium
  design_complexity = medium

Output:
  executor = Codex
  ui_tool  = Antigravity
  reason   = "medium change with wireframe-stage UI"
```

## 7. Checklist — all must be true before declaring done

- [ ] All 4 inputs (`mode`, `has_ui`, `change_size`, `design_complexity`) read from HANDOFF.md / stage docs — no guesses
- [ ] `change_size` is one of `{small, medium, large}` — not a raw line count
- [ ] Recommendation derived from §Recommendation Matrix, not ad-hoc reasoning
- [ ] User presented with the recommendation **and** alternatives (Codex / Claude / Custom; Antigravity / Claude Design / Figma / Custom)
- [ ] User confirmed or overrode the recommendation
- [ ] Final pick written to `HANDOFF.md` "current tools" field
- [ ] Final pick appended to `docs/notes/dev_history.md` with stage tag + reason
- [ ] If user picked "Custom" AND asked to save, entry appended to `.claude/tools.json`
- [ ] If `has_ui = false`, `ui_tool` is `none` (not Antigravity/Figma/etc.)

## 8. Verification

```bash
# Current session choice visible in HANDOFF:
grep -A3 "current tools" HANDOFF.md

# Latest decision logged:
tail -n 10 docs/notes/dev_history.md | grep -E "executor|ui_tool"

# Catalog (only if user saved a Custom entry):
cat .claude/tools.json 2>/dev/null || echo "no catalog yet — normal for first run"
```

Or point to: the `docs/notes/dev_history.md` entry added in this stage.

---

## Recommendation Matrix

### Executor axis — used at Stage 5 / 8 / 10

Evaluate top-down; first match wins.

| # | Signal | → Recommendation |
|---|--------|------------------|
| 1 | `.claude/tools.json` has a user-set default for this `mode` + `change_size` class | Use that default; surface `reason = "user default"` |
| 2 | `change_size` ∈ {`medium`, `large`} OR new file | **Codex** |
| 3 | Strict mode AND `design_complexity = high` | **Codex** |
| 4 | `change_size = small` AND Lite mode | **Claude (Sonnet)** |
| 5 | Ambiguous / cannot determine | **Codex** (safe default) |

### UI tool axis — used at Stage 6 / 7 (only if `has_ui = true`)

| # | Signal | → Recommendation |
|---|--------|------------------|
| 1 | `has_ui = false` | `none` — exit, do not pick a UI tool |
| 2 | `.claude/tools.json` has a project UI-tool default | That tool; `reason = "project default"` |
| 3 | `design_complexity = low` AND goal is "wireframe quickly" | **Google Antigravity** |
| 4 | Design output is inline markdown / small JSX in the repo | **Claude Design** |
| 5 | Production handoff to designers OR regulated/branded UI | **Figma** |
| 6 | Ambiguous | **Google Antigravity** (fast, reversible) |

### Stage 10 re-eval (D-D rule)

| Stage 9 verdict | Action |
|-----------------|--------|
| `minor`, `bug fix`, `typo` | Keep Stage 8 executor. Do NOT re-run this skill. |
| `design-level` (architecture / schema / UI flow rework) | Re-run this skill with the **updated** `design_complexity` and `change_size`. |
| Missing or unparseable verdict | Red Flag — stop and ask. |

---

## Optional addendum

**Prerequisites**
- `HANDOFF.md` v0.2+ fields: `mode`, `has_ui`, `risk_level`, `current tools` (the last is new in v0.3 — create on first run if missing)
- `docs/02_planning/plan_final.md` "Success Criteria" section with approximate change size
- `.claude/tools.json` for persistent project-scope custom entries (optional)

**Inputs / Outputs**
- Input: `mode`, `has_ui`, `change_size` (enum), `design_complexity`
- Output: `{ executor ∈ {Codex, Claude, Custom:<name>}, ui_tool ∈ {Antigravity, ClaudeDesign, Figma, Custom:<name>, none}, reason (≤ 120 chars) }`

**Rollback**
- Wrong choice recorded → edit `HANDOFF.md` "current tools" and append a correction row to `dev_history.md` (no silent overwrite)
- Bad Custom entry in `.claude/tools.json` → remove, note in `docs/notes/decisions.md`

**Notes**
- v0.3 starter skill. Tune enum mapping after ~10 real runs via `docs/notes/workflow_eval_plan.md`
- Global user profile (`~/.claude/tools.json`) is v1.0 scope
- Design rationale: `prompts/claude/v03_kickoff.md` → "Resolved decisions D-A ~ D-D"
- Does NOT decide `mode`. If mode feels wrong, call `.skills/mode-picker` first
