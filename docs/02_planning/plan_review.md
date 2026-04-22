# 🔍 Stage 3 — Plan Review (jOneFlow v0.3)

> **Date:** 2026-04-22 (session 3)
> **Language:** EN primary (Korean translation: `plan_review.ko.md` — paired file)
> **Mode:** Strict-hybrid
> **Upstream:** `docs/02_planning/plan_draft.md` (v1, session 2)
> **Downstream:** `plan_final.md` (Stage 4) → Stage 4.5 user-approval gate
> **Reviewer:** Claude (same-session self-review; Stage 11 will be the independent fresh-session pass)

---

## 0. Method

This is a Stage 3 **self-review** of `plan_draft.md` against the four focus questions recorded in that file's Sec. "Next Stage" block:

1. **(a) Coverage** — Does Sec. 3 Deliverables cover kickoff goals 5 / 7 / 9 / 10 / 11 / 12 without double-counting?
2. **(b) Top-3 risks** — Are Sec. 5 top-3 risks truly the top-3 (not picked for writing convenience)?
3. **(c) Open-question containment** — Can Sec. 7 OQs all be answered inside Stage 5, or do any leak back into Stage 4?
4. **(d) KO sync** — Is `plan_draft.ko.md` in sync with `plan_draft.md` at Stage 3 entry?

Out of scope for Stage 3 (deferred to Stage 5 / Stage 11):

- Concrete module boundaries, SKILL.md schema, shell-script flag surface — these belong in `technical_design.md`.
- Code-level review — belongs in Stage 9.
- Independent validation of the whole scope — belongs in Stage 11 fresh session.

---

## 1. Focus (a) — Deliverables × kickoff goals coverage

### 1-1. Mapping audit

| Kickoff goal | Bundle | Primary deliverable | Secondary / supporting | Status |
|--------------|--------|---------------------|------------------------|--------|
| **5** — HANDOFF auto-writer | 4 | D4.a `scripts/update_handoff.sh` | (uses D4.x1 template as target form) | ✅ covered 1:1 |
| **7** — tool-picker skill file | 1 | D1.a `.skills/tool-picker/SKILL.md` | — | ✅ covered 1:1 |
| **9** — CHANGELOG | 4 | D4.b `CHANGELOG.md` + maintenance rule | rule lives inside `CONTRIBUTING.md` | ✅ covered 1:1 |
| **10** — community docs split | 4 | D4.c `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md` | — | ✅ covered 1:1 |
| **11** — recommendation logic | 1 | D1.b recommendation section inside SKILL.md | consumes D4.x2–x4 structure | ✅ covered 1:1 |
| **12** — worked example | 1 | D1.c example block inside SKILL.md | — | ✅ covered 1:1 |

**Result:** all six kickoff goals are mapped to exactly one primary deliverable. No goal is covered twice. No goal is orphaned.

### 1-2. Finding F-a1 — `CONTRIBUTING.md` file-level ownership ambiguity (minor clarity)

`CONTRIBUTING.md` appears in **two** deliverables:

- **D4.b** (goal 9) references it as the location of the CHANGELOG maintenance rule.
- **D4.c** (goal 10) defines it as a standalone deliverable (the community-docs split).

This is **not a goal double-count** (goal 9 ≠ goal 10), but it is a **file ownership ambiguity**: which deliverable "owns" the file? If Stage 5 Bundle 4 design is not explicit, two parallel design drafts could collide on headings and style.

**Proposed resolution** (for plan_final to absorb):

> *D4.c owns `CONTRIBUTING.md` as a file. D4.b contributes a single section (e.g., `## Changelog maintenance`) to that file. Stage 5 Bundle 4 design lists both as "CONTRIBUTING.md sections table" with the owning deliverable per row.*

Severity: **Minor**. Does not block Stage 4 approval; worth stating once in plan_final Sec. 3 so Stage 5 doesn't rediscover it.

### 1-3. Scope-extras coverage (brainstorm Sec. 9-2, option β)

Separate from kickoff goals, Bundle 4 option β adds four scope extras (D4.x1–x4). Each maps to exactly one OQ or one brainstorm-Sec. 9-2 sub-item:

| Scope extra | Source | Deliverable | Status |
|-------------|--------|-------------|--------|
| `template_vs_dogfooding_separation` | long-deferred Option 1 | D4.x1 `templates/HANDOFF.template.md` | ✅ |
| `internal_doc_header_schema` | brainstorm Sec. 9-2 | D4.x2 (decisions.md entry) | ✅ |
| `bundle_folder_naming` | brainstorm Sec. 9-2 | D4.x3 (decisions.md entry) | ✅ |
| `doc_link_conventions` | brainstorm Sec. 9-2 | D4.x4 (decisions.md entry) | ✅ |

All four scope extras are covered, none duplicated. Good.

### Focus (a) verdict

**PASS with one minor clarification for plan_final.**

---

## 2. Focus (b) — Top-3 risks audit

### 2-1. Are R1, R2, R3 truly the top three?

Weight by (likelihood × impact × "how hard to catch late"):

| Ranking check | R1 (option-β scope creep) | R2 (tool-picker → discovery UX drift) | R3 (Stage 11 context exhaustion) |
|---------------|---------------------------|----------------------------------------|----------------------------------|
| Likelihood | medium | medium | medium-high |
| Impact | high (balloons v0.3) | high (violates N5) | medium (could force replay) |
| Catch-late cost | high — found only at Stage 9 review | high — gradual design creep, not caught until Stage 9 | medium — caught at Stage 11 entry |
| Joint-approval cascade (M.1) | **yes — blocks Bundle 1 too** | no (local to Bundle 1) | no (post-impl) |
| Mitigation leverage | Stage 3 cap + Stage 5 design constraint | Stage 5 design declaration + Stage 9 re-check | pre-compact at Stage 11 entry |

All three are plausibly top-3 in the "medium-high" band. I verified R1 over R4 (KO drift) because R1 couples to **both** bundles via M.1 (joint approval), while R4 is mitigable at stage close and already has a named rule. R3 over R8 (DC.5 timing) because R8 has a hard pre-condition mitigation ("do not enter Stage 5 without the drafts"), which reduces it to a procedural check — low residual risk once enforced.

### 2-2. Finding F-b1 — ordering nit inside top-3 (accept as-is)

R2 vs. R3 could plausibly swap ranks. R2 is **insidious** (creeps across Stage 5–9); R3 is **acute at one gate** (Stage 11). Both stay in top-3; relative order inside the top-3 does not materially change mitigation obligations. **No change proposed.**

### 2-3. Finding F-b2 — missing risk candidate: joint-approval coupling (R9 candidate)

A risk that is **not called out** in plan_draft as a standalone line: under M.1 (joint Stage 4.5 approval, no partial approval), **any major issue in either bundle blocks the other from shipping**. Today this surfaces only implicitly inside R1's impact column ("balloons v0.3") and GJ.2.

It is **not** a classical top-3 risk by itself — it is a **coupling amplifier** on other risks. Adding it as a named secondary risk improves auditability at Stage 9 and Stage 11 without changing mitigations.

**Proposed resolution** (for plan_final to absorb):

> *Add **R9 — Joint-approval coupling (M.1 amplifier)** to Sec. 5-2 secondary risks. Mitigation: if Stage 9 verdict for one bundle is `design_level` AND the other is `minor`, the joint rule still triggers Stage 4.5 re-approval for both. Record the coupled verdict explicitly in HANDOFF.md bundles[].verdict fields.*

Severity: **Moderate** (audit-hygiene improvement; does not change plan direction).

### Focus (b) verdict

**PASS with one secondary-risk addition for plan_final.**

---

## 3. Focus (c) — Open-question containment check

Goal: confirm that every OQ in Sec. 7 is answerable inside Stage 5 (technical design), and no OQ belongs back in Stage 4 (planning).

### 3-1. OQ-by-OQ audit

| OQ | Topic | Answerable at Stage 5? | Verdict |
|----|-------|------------------------|---------|
| OQ1.1 | SKILL.md split vs. single | Yes — Bundle 1 tech design | ✅ Stage 5 |
| OQ1.2 | recommendation trigger mode | Yes — Bundle 1 tech design | ✅ Stage 5 |
| OQ1.3 | native `Skill` tool binding | Yes — Bundle 1 tech design (already leaned: none, per N14) | ✅ Stage 5 |
| OQ4.1 | header metadata schema | Yes — Bundle 4 tech design | ✅ Stage 5 |
| OQ4.2 | bundle folder naming | Yes — Bundle 4 tech design | ✅ Stage 5 |
| OQ4.3 | link-check automation | Already resolved as N12 (deferred) | ✅ resolved |
| OQ.H1 | bundles[] placement | Already resolved (keep `## Bundles`) | ✅ resolved |
| OQ.H2 | backward compat | Yes — Bundle 4 tech design (CONTRIBUTING migration note) | ✅ Stage 5 |
| **OQ.S11.1** | Stage 11 kickoff context delivery | Yes — but it's a **prompt-authoring task, not a design task**; belongs in the pre-Stage-11 housekeeping counterpart to DC.5 | ⚠️ see F-c1 |
| **OQ.S11.2** | divergent verdict policy (joint validation) | **No** — this is a **policy** decision about what state lands in HANDOFF when bundles diverge; belongs in **Stage 4 Plan Final Sec. policy**, not in `technical_design.md` | 🚨 F-c2 |
| OQ.C1 | Codex scope for Bundle 1 | Yes — Bundle 1 tech design Codex appendix | ✅ Stage 5 |
| OQ.C2 | Stage 5 → Codex prompt mapping | Yes — Stage 5 design appendices | ✅ Stage 5 |
| OQ.L1 | translation timing | Already resolved via R4 (at stage close) | ✅ resolved |
| **OQ.L2** | "KO missing" check location | Stage 3 half (plan_review template) = **this document's responsibility**; Stage 9 half = Bundle 4 tech design | 🟡 F-c3 |
| OQ.N1 | CHANGELOG spec | Yes — Bundle 4 tech design | ✅ Stage 5 |
| OQ.N2 | update_handoff.sh dry-run default | Yes — Bundle 4 tech design | ✅ Stage 5 |
| OQ.N3 | .github/ scope | Already resolved (deferred to v0.4) | ✅ resolved |

### 3-2. Finding F-c1 — OQ.S11.1 is a prompt-authoring task, not a Stage 5 design task

OQ.S11.1 ("how does the Stage 11 joint fresh session receive context") is answered by **writing a Stage 11 kickoff prompt template** — a sibling of DC.5's Stage 5 prompt drafts, just later in the pipeline.

plan_draft Sec. 9 already lists this implicitly ("Stage 11 kickoff prompt text → **pre-Stage-11 housekeeping** (new counterpart to DC.5)"). Good — so OQ.S11.1 does **not** leak into Stage 4 or Stage 5; it lands in a new housekeeping slot before Stage 11.

**Proposed resolution** (for plan_final): promote this from a parenthetical in Sec. 9 to an explicit deliverable line (e.g., `DC.6 — prompts/claude/v03/stage11_joint_validation_prompt.md`).

Severity: **Minor** (traceability / deliverable-list completeness).

### 3-3. Finding F-c2 — OQ.S11.2 leaks back into Stage 4 🚨

OQ.S11.2 asks: **"if the two bundles' Stage 11 validations diverge, what state goes into HANDOFF?"** plan_draft already has a lean (`group verdict = worst-case (CHANGES REQUESTED wins); design_level triggers Stage 4.5 re-approval`), but it is stored as an *open-question lean* rather than a *committed policy*.

This is not a technical-design decision — there is no module or data flow to design. It is a **governance policy** about how the joint validation group behaves under disagreement, and it gates Stage 4.5 re-approval semantics (an M.4 clarification).

**Severity: Moderate — would propagate as ambiguity all the way to Stage 11.**

**Proposed resolution** (for plan_final to absorb as committed policy, not as OQ):

> *Add to plan_final Sec. Milestones notable rules (or a new Sec. Policy section):*
> **M.5 — Divergent-verdict policy.** If bundles in a single validation group produce divergent Stage 11 verdicts, the group verdict is the worst of the two (`CHANGES REQUESTED` beats `APPROVED`). Stage 4.5 re-approval is triggered only when **at least one bundle's verdict is `design_level`**. Re-approval, when triggered, is joint (M.1 continues to apply).

Action: **commit to plan_final Sec. 4 or new Sec. policy; remove OQ.S11.2 from the Open Questions list and reference the new rule instead.**

### 3-4. Finding F-c3 — OQ.L2 is half-answerable in Stage 3 itself 🟡

OQ.L2 asks where the "KO missing" check lives. Two halves:

- **Stage 3 half** — the plan_review template should have an explicit KO-sync check. That's **this document's responsibility** — handled below in Sec. 4.
- **Stage 9 half** — code-review checklist should include "KO freshness for stage-closing docs." That's Bundle 4 tech design scope.

**Proposed resolution** for plan_final: split OQ.L2 into "resolved (Stage 3 half)" and "Stage 5 Bundle 4 scope (Stage 9 half)."

Severity: **Minor** (housekeeping).

### 3-5. Focus (c) rollup

| Leak | Direction | Action |
|------|-----------|--------|
| F-c2 (OQ.S11.2) | → Stage 4 (policy, not design) | Promote to plan_final as committed rule M.5 |
| F-c1 (OQ.S11.1) | → pre-Stage-11 housekeeping slot (already acknowledged in Sec. 9 but as prose) | Promote to explicit deliverable DC.6 |
| F-c3 (OQ.L2) | → partly Stage 3 (this doc), partly Stage 5 Bundle 4 | Resolve Stage 3 half inline; keep Stage 5 half |

### Focus (c) verdict

**PASS with three resolutions for plan_final** — one true leak (F-c2) + two traceability upgrades (F-c1, F-c3). No rollback to Stage 2 required.

---

## 4. Focus (d) — KO sync at Stage 3 entry

### 4-1. Structural check

Section headers in `plan_draft.ko.md` (30 `##` / `###` entries) map 1:1 to `plan_draft.md` headers. Same numbering, same scope divisions, same milestone matrix axes, same R1–R8 + P-re-check structure, same approval checklist AC.1–AC.7.

### 4-2. Content-level spot-checks

| Spot | EN | KO | Match? |
|------|----|----|--------|
| North-star sentence | "start a new backend project with jOneFlow v0.3 on their own within 30 minutes" | "Jonelab 동료가 jOneFlow v0.3으로 30분 안에 새 백엔드 프로젝트를 혼자 시작할 수 있다" | ✅ |
| D1.a (goal 7) | `.skills/tool-picker/SKILL.md` | `.skills/tool-picker/SKILL.md` | ✅ same ID path |
| R1 mitigation | "Cap internal decisions to three yes/no-ish choices" | "내부 결정을 세 개의 yes/no 선택으로 제한" | ✅ |
| Approval checklist count | 7 items (4 baseline + 3 Strict-hybrid extras) | 동일 (8-1 = 4, 8-2 = 3) | ✅ |

### 4-3. Reusable KO-sync check (resolving OQ.L2 Stage 3 half)

Going forward, every `plan_review.md` / `plan_final.md` should open Stage 3 with this four-line check (the KO half of OQ.L2):

```
KO sync check (required at Stage 3 start and Stage 4 start):
- [ ] Section-header count parity between EN and KO
- [ ] North-star sentence present and equivalent in KO
- [ ] Deliverable IDs (D1.a/D4.a/…) identical in both files
- [ ] Approval checklist item count identical in both files
```

This is now part of the Stage 3 template and will be copied to plan_final.md. (Stage 9 code-review checklist addition remains deferred to Bundle 4 tech design.)

### Focus (d) verdict

**PASS — KO sync is current at Stage 3 entry. OQ.L2 Stage 3 half resolved in this document.**

---

## 5. Other findings surfaced during review (non-focal)

Reviewing plan_draft Sec. 1–Sec. 10 in order:

### 5-1. F-o1 — Sec. 6 DEP.1 sequencing ambiguity (minor)

DEP.1 says *"Bundle 4 Stage 5 starts before or simultaneously with Bundle 1 Stage 5, but Bundle 4's structural decisions must finalize first."* The "simultaneously" language is loose — the HANDOFF "Next Session Prompt" correctly tightens it to **"Bundle 4 구조 결정 먼저, DEP.1"** (Bundle 4 structural decisions first).

**Proposed resolution** (plan_final): tighten DEP.1 to *"Bundle 4 Stage 5 structural decisions (D4.x2–x4) must finalize before Bundle 1 Stage 5 writes its recommendation-logic section (D1.b). Bundle 4 and Bundle 1 tech design may otherwise proceed concurrently."* Severity: **Minor**.

### 5-2. F-o2 — Sec. 4 milestone matrix row-13 (Deploy & Archive) labeled "joint tag v0.3" — acceptable but worth a note

The joint git tag at Stage 13 is good hygiene. No change needed. Noted to plan_final explicitly so Stage 13 doesn't ship Bundle 1 and Bundle 4 under separate tags.

### 5-3. F-o3 — Sec. 7-7 OQ.N3 (.github/ directory) — already resolved, list position inconsistent

OQ.N3 is marked as "Lean: deferred to v0.4." Since it is a committed resolution, not a true open question, it should migrate to Sec. 2 non-goals as N15 (or be folded into existing N7 "CI/CD templates"). **Proposed resolution**: fold into N7 in plan_final Sec. 2 as a sub-bullet ("includes `.github/` PR/issue templates"). Severity: **Minor** (cleanliness).

### 5-4. F-o4 — no finding against Sec. 8 Approval checklist structure

The 7-item structure (4 WORKFLOW baseline + 3 Strict-hybrid extras) is correct and matches WORKFLOW.md Sec. 6 Stage 4 criteria. AC.1–AC.7 are each measurable. plan_final will fill them with ✅/❌ + one-line notes.

---

## 6. Proposed revisions rollup (inputs to Stage 4 Plan Final)

The findings above resolve as follows. All are **absorbed in `plan_final.md`**; `plan_draft.md` stays as a Stage 2 snapshot (per session-3 instruction: plan_draft edits were permitted but no Stage-3 finding required a Stage-2 rewrite — all land cleanly at Stage 4). A revision-log line in plan_draft is sufficient.

| ID | Type | Source | Action in plan_final |
|----|------|--------|----------------------|
| F-a1 | Clarify file ownership | Sec. 3 | Add note to D4.c and D4.b: CONTRIBUTING.md owned by D4.c; D4.b adds a single section to it. |
| F-b2 | Add secondary risk | Sec. 5-2 | Add **R9 — Joint-approval coupling (M.1 amplifier)**. |
| F-c1 | Promote to deliverable | Sec. 3-3 | Add **DC.6 — `prompts/claude/v03/stage11_joint_validation_prompt.md`**. |
| F-c2 | Commit policy; remove from OQs | Sec. 4 + Sec. 7 | Add **M.5 — Divergent-verdict policy** to milestone rules; delete OQ.S11.2 and reference M.5. |
| F-c3 | Resolve Stage 3 half; keep Stage 5 half | Sec. 7-6 | Mark OQ.L2 Stage 3 half resolved (KO sync check section, Sec. 4-3 of this doc); keep Stage 9 half for Bundle 4 tech design. |
| F-o1 | Tighten sequencing | Sec. 6 DEP.1 | Replace "simultaneously" with "may proceed concurrently; Bundle 4 D4.x2–x4 must lock first." |
| F-o2 | Explicit joint tag | Sec. 4 M-rules | Add note: Stage 13 ships both bundles under a single `v0.3` git tag. |
| F-o3 | Fold OQ.N3 into N7 | Sec. 2 + Sec. 7-7 | Add ".github/ PR/issue templates" sub-bullet under N7; remove OQ.N3 from Open Questions. |

---

## 7. Verdict

**Plan Draft is structurally sound.** No rollback to Stage 2. Stage 4 Plan Final proceeds with the eight revisions in Sec. 6 absorbed. All Stage 3 focus points pass.

| Focus | Verdict |
|-------|---------|
| (a) Deliverables × goals coverage | PASS with 1 clarification (F-a1) |
| (b) Top-3 risks | PASS with 1 secondary-risk addition (F-b2) |
| (c) OQ containment | PASS with 3 resolutions (F-c1, F-c2, F-c3) |
| (d) KO sync | PASS; OQ.L2 Stage 3 half resolved in Sec. 4-3 |

---

## 8. What this review does NOT cover (handoff to later stages)

- Technical design decisions (SKILL.md schema, shell flag surface, header YAML syntax) → **Stage 5 per bundle**.
- Independent validation of the plan as a whole → **Stage 11 fresh session** (validation group 1).
- Codex prompt verbatim → **Stage 5 design appendices**.
- QA scenarios → **Stage 12**.

---

## 9. Revision log for this document

| Date | Revision | Note |
|------|----------|------|
| 2026-04-22 | v1 — Stage 3 review written | Session 3. Same-session self-review; 4 focus points + 4 secondary findings. 8 revisions forwarded to plan_final. |

---

## 📌 Next Stage

**Stage 4 — Plan Final** (`docs/02_planning/plan_final.md`).

Plan Final must:
1. Absorb the eight revisions listed in Sec. 6 of this review.
2. Fill the 7-item Approval checklist (AC.1–AC.7 from plan_draft Sec. 8) with ✅/❌ + one-line notes.
3. Include the KO sync check block (Sec. 4-3) at the top.
4. Be paired with `plan_final.ko.md` before Stage 4.5 presentation.

---
