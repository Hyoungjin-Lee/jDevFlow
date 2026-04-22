---
title: Codex automation exploration (parked for v0.4)
stage: null
bundle: null
version: 1
language: en
paired_with: null
created: 2026-04-22
updated: 2026-04-22
status: parked
validation_group: null
---

# Codex automation exploration — parked for v0.4

> **Status:** Exploration log only. Not part of the v0.3 deliverable set.
> Parked here so the findings are preserved for a deliberate v0.4 evaluation
> cycle instead of being re-derived from scratch next time.

## 1. Why this came up

During Stage 8 of v0.3, the paste-mediated handoff between the Cowork
session (orchestration) and a separate Codex session (implementation) was
friction-heavy: the operator had to copy a fenced prompt block out of a
kickoff file, paste it into Codex, wait, and then paste the completion
report back. A paste-target mix-up on 2026-04-22 caused a full recovery
cycle (see the Sec. 7 note in `prompts/codex/v03/stage8_coordination_notes.md`
for the B-option kickoff redesign). That forced the question: can the
Cowork side drive Codex directly, without human paste-shuttling in between?

## 2. What was evaluated

Three leads were examined on 2026-04-22:

1. The `superpowers/` submodule inside this repo, which contains a set of
   pre-baked Claude capability patterns. A "codex communication" hook was
   rumored to exist in that tree but was not confirmed during this session.
2. A Korean-language blog write-up at `https://goddaehee.tistory.com/571`
   sketching an automation chain of the shape
   `Cowork → Claude Code CLI → Codex CLI → Claude Code CLI → Cowork`,
   i.e. the Claude Code standalone REPL as a broker between Cowork and
   Codex.
3. The `openai/codex-plugin-cc` repo, installable into a standalone Claude
   Code REPL via `/plugin marketplace add openai/codex-plugin-cc`
   followed by `/plugin install codex-plugin-cc`. The marketplace is
   named `openai-codex`; the plugin itself is `codex` v1.0.4.

## 3. What the plugin exposes (from a User-scope install in the
       standalone Claude Code REPL)

After install + `/reload-plugins`, the standalone REPL reported
"1 plugin · 7 skills · 6 agents · 3 hooks · 0 plugin MCP servers
· 0 plugin LSP servers". The 6 namespaced slash commands visible via
`/codex` autocomplete were:

- `/codex:setup` — check local Codex CLI readiness; toggle settings.
- `/codex:review` — run a Codex code review against local git state.
- `/codex:result` — show stored final output for a finished Codex job.
- `/codex:status` — show active and recent Codex jobs for the repo.
- `/codex:cancel` — cancel an active background Codex job.
- `/codex:rescue` — delegate investigation / explicit fix request /
  follow-up rescue to Codex.

The command surface implies a **background-job orchestration model**:
fire-and-forget jobs with separate status/result primitives, rather than
a synchronous chat-like bridge. That is operationally different from the
v0.3 paste-mediated handoff (which is effectively a synchronous turn
with a human in the loop).

## 4. Why v0.3 does not adopt it

Two blockers:

1. **Cowork sandbox mount isolation.** The Cowork session filesystem
   maps only the workspace folder (`~/projects/Jonelab_Platform`) and a
   synthetic `.claude/` tree for Cowork itself. The user's host
   `~/.claude/plugins/` is not mounted, and a permission grant inside the
   workspace `.claude/settings.local.json` affects only the standalone
   Claude Code REPL — it cannot open a filesystem path that the Cowork
   sandbox has no mount for. So the Cowork side cannot invoke `/codex`
   directly. At most, this would become a three-station flow:
   Cowork (orchestration) → standalone Claude Code REPL with `/codex`
   installed (Codex broker) → Codex CLI (implementation). That is fewer
   manual pastes than today, but it is still not in-session automation.
2. **Timing.** v0.3 is mid-Stage-8 with Bundle 4 already quote-back-
   approved and in STEP 1. Swapping orchestration model mid-bundle would
   invalidate the Stage 5 decisions that chose the paste-mediated flow.
   The B-option kickoff redesign (single fenced block per kickoff,
   STEP 0 quote-back gate) has already addressed the immediate paste-
   target failure mode, which was the original pain point.

## 5. Open questions to answer before a v0.4 decision

- What exactly do the 3 hooks do? (Pre/post-prompt wrappers? Result
  pollers?) This determines how reliably the background-job model
  preserves the STEP 0 quote-back gate and the Sec. 12-3 must-not-decide
  escalation boundary.
- How does `/codex:rescue` frame its prompt to Codex? If it injects its
  own system prompt or "fix this" framing, that conflicts with v0.3's
  explicit-spec-quote-back discipline.
- Can a file-mediated handoff protocol (Cowork writes a prompt file
  → standalone Claude Code REPL reads it → invokes `/codex:rescue` with
  the file path → Codex writes result to a known output path → Cowork
  reads the result) preserve both the strict-hybrid Stage-8 shape and
  the DEP.1 Bundle-4-before-Bundle-1 ordering?
- Does the plugin's background-job queue give useful isolation
  guarantees between parallel bundle runs, or does it serialize at the
  repo level?
- Licensing / stability: the `openai-codex` marketplace is first-party
  OpenAI. Is it expected to remain stable across Codex CLI upgrades?

## 6. What `Read(//Users/geenya/.claude/plugins/**)` in `.claude/settings.local.json` does

Noted for the record: the permissions line
`"Read(//Users/geenya/.claude/plugins/**)"` in
`jDevFlow/.claude/settings.local.json` was added during plugin install
on 2026-04-22. It authorizes the standalone Claude Code REPL to read
that path when running in this project. It does **not** give the Cowork
sandbox access to that path — Cowork's filesystem isolation is not
controlled by that allow-list. If a v0.4 integration wants the Cowork
side to inspect plugin internals, the plugin directory would need to be
either (a) copied into the workspace folder or (b) mounted explicitly
at Cowork session start.

## 7. v0.4 evaluation checklist (deferred)

- [ ] Inspect plugin internals: `commands/`, `hooks/`, and any agent
      definitions. Either via a workspace-local copy or by reading the
      upstream GitHub source.
- [ ] Decide integration shape: (i) adopt the plugin as-is and run the
      three-station flow, (ii) fork the plugin and strip it down to a
      thin file-mediated handoff, or (iii) keep the paste-mediated flow
      and just tighten the kickoff template.
- [ ] Define how the plugin's background-job model maps to the v0.3
      Stage-8 contract (STEP 0 quote-back → STEP 1 implement → STEP n
      verify → report).
- [ ] Scope the migration touch: which v0.3 kickoff conventions survive
      unchanged, which need a plugin-aware rewrite.

## 8. References

- `prompts/codex/v03/stage8_coordination_notes.md` §7 (paste-target
  failure-mode write-up).
- `prompts/codex/v03/stage8_bundle{1,4}_codex_kickoff.md` v2
  (single-block B-option kickoffs).
- Upstream plugin repo: `https://github.com/openai/codex-plugin-cc`.
- Marketplace display name: `openai-codex`; plugin name: `codex`
  (v1.0.4, author OpenAI).
- Blog reference: `https://goddaehee.tistory.com/571` (three-station
  Cowork → Claude Code CLI → Codex flow sketch).
