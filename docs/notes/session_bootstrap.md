# Session Bootstrap

> **Status:** v0.2
> **Purpose:** Define exactly how a new Claude session enters a jOneFlow project — so sessions start consistently, across users, across Claude clients (Claude Code, Cowork, API), and across days.

---

## 1. Why bootstrap matters

jOneFlow is session-persistent through documents, not through chat memory. A new session must reconstruct context before acting, or it will contradict prior work.

Three things get Claude wrong most often at session start:

1. Skipping `HANDOFF.md` and diving into the most recent chat turn
2. Assuming the workflow is always "13 stages"
3. Starting Stage 5 before confirming Stage 4 approval

A consistent bootstrap sequence prevents all three.

## 2. Canonical session entry sequence

Every new Claude session — whether started by the user or triggered by a hook — should follow this order:

1. **Read `CLAUDE.md`**
   - Get project rules, role boundaries, security rules.
2. **Read `HANDOFF.md`**
   - Learn current workflow mode (Lite / Standard / Strict), current stage, recent changes, next tasks, blockers.
3. **Read `WORKFLOW.md`** (skim)
   - Confirm understanding of the tiered model and stage types.
4. **Read only the relevant `docs/` file for the current stage**
   - Do not read every stage document. Load only what the next action needs.
5. **Confirm mode and next action with the user** (one short message)
   - Example: "HANDOFF.md says Standard mode, Stage 5 pending. Shall I start Technical Design?"

If the user interrupts with a new ad-hoc request before the bootstrap is complete, finish reading `CLAUDE.md` and `HANDOFF.md` anyway. Context is cheap; recovering from a wrong action is expensive.

## 3. User-facing start phrases

Users can start a session with any of these phrases. Claude should recognize them and run the bootstrap sequence above.

- "Continue jOneFlow"
- "Continue the project" (when CWD matches a jOneFlow project)
- "Let's resume"
- "Read HANDOFF and CLAUDE, then tell me where we are"

If no start phrase is used but the CWD looks like a jOneFlow project (has `CLAUDE.md`, `HANDOFF.md`, `WORKFLOW.md`), Claude should **offer** to run the bootstrap sequence before starting any real work.

## 4. Hook-ready design (optional, not required)

Some Claude clients support session-start hooks that can automatically inject content into the first message of a session. jOneFlow is designed to be compatible with that pattern without depending on it.

If a hook is configured, it should:

- Inject a short pointer — not the full contents of the files — e.g., `"Read CLAUDE.md, HANDOFF.md, WORKFLOW.md, then confirm mode with the user."`
- Not attempt to load or auto-run Codex
- Be safe to remove — removing the hook must not break anything

jOneFlow explicitly does not ship a default hook. Hooks are environment-specific and brittle. The documented bootstrap sequence above is the contract; hooks are one way to enforce it.

## 5. Mode choice at session start

Bootstrap does not force a mode. It surfaces the current mode from `HANDOFF.md` and lets the user confirm.

Rules:

- If `HANDOFF.md` has a mode recorded and the user did not override it in the start message, use that mode.
- If the user's start message implies a different mode (e.g., "just fix a typo" → Lite), confirm the switch explicitly before acting.
- If no mode is recorded and the task is unclear, run Stage 1 (Brainstorm) to resolve mode, `has_ui`, and `risk_level`.

## 6. End-of-session mirror

Bootstrap only works if the previous session wrote a proper handoff. That is a separate contract, covered in `WORKFLOW.md` section 13 ("Session handoff and persistence"). In short:

At the end of every session, Claude updates `HANDOFF.md`:

- current mode
- current stage
- what was done
- next action (with file names and stage numbers)
- blockers
- a copy-pasteable **Next Session Prompt** at the bottom

A good end-of-session update is what makes the next bootstrap fast.

## 7. Failure modes this sequence prevents

- Claude proceeding from stale chat context instead of `HANDOFF.md`
- Claude treating every task as Strict / full 13 stages
- Claude starting Stage 5 before Stage 4 approval
- Claude forgetting security rules because it skipped `CLAUDE.md`
- Claude mixing modes mid-task because no mode was ever chosen

## 8. For non-developer users

If you are not a developer, the short version is:

> Start every session by asking Claude: "Please read CLAUDE.md and HANDOFF.md, then tell me where we are and what to do next."

Claude will do the rest.
