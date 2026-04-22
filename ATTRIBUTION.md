# Attribution

jOneFlow is part of Jonelab_Platform and was developed as an independent workflow template and platform direction for AI-assisted software development.

## Reference Project

This project was informed in part by ideas explored in [obra/superpowers](https://github.com/obra/superpowers), created by Jesse Vincent and contributors.

- Repository: https://github.com/obra/superpowers
- License: MIT

## Nature of Influence

The superpowers project influenced parts of jOneFlow primarily at the level of workflow thinking, skill design direction, and agent-operating discipline.

Areas that may reflect that influence include:

- Workflow and stage-structure refinement (e.g., explicit completion criteria, re-entry rules, adversarial review posture)
- Skill-template and instruction-shaping patterns (the `.skills/` behavior-contract structure with When-to-Use / Do / Don't / Red Flags / Good-Bad / Checklist / Verification sections)
- Session bootstrap and operating-guide ideas (the documented session-start reading sequence and hook-ready design)
- Evaluation-oriented workflow improvement practices (`docs/notes/workflow_eval_plan.md`)

In jOneFlow, these ideas were adapted and reinterpreted to support a different goal: a **document-centric, bilingual, handoff-friendly workflow platform** with stronger project-state continuity via `HANDOFF.md`, built-in secure-secret guidance (OS keychain–first), a tiered workflow model (Lite / Standard / Strict) rather than a single rigid pipeline, and deliberate non-developer friendliness.

Some structural patterns and template conventions in this repository were adapted after reviewing superpowers materials. Where such adaptations are close enough to merit explicit acknowledgment, this file serves as that notice.

## What Is NOT From superpowers

For clarity, the following are original to jOneFlow (or predate superpowers influence in this project):

- The Jonelab_Platform framing and the jOneFlow / jDocsFlow / jCutFlow family concept
- The `HANDOFF.md` session-continuity model and its "next session prompt" pattern
- The tiered workflow model (Lite / Standard / Strict) and the stage-type taxonomy in `WORKFLOW.md`
- The cross-platform secret-management stack (`security/secret_loader.py` + macOS Keychain / Windows Credential Manager backends)
- Bilingual EN/KO authoring across every user-facing document
- The Claude-and-Codex role-separation contract (Claude for thinking, Codex for implementation) and the 4-agent composition (Planner / Designer / Reviewer / QA Engineer)
- The `ai_step.sh` / `git_checkpoint.sh` shell workflow and the related alias set

## Attribution Intent

This file exists to acknowledge that jOneFlow did not emerge in isolation. Where this project adopts or adapts concepts inspired by superpowers, we want to credit that influence clearly and respectfully.

This attribution is provided as a good-faith, conservative open-source practice for public sharing. It should not be read as:

- claiming that jOneFlow is a fork of superpowers, or
- implying that all design elements here originate there.

If you spot a specific adaptation that deserves a more explicit reference than this document provides, please open an issue — we will update the attribution.

## License

jOneFlow is distributed under the MIT License (see `LICENSE`). The superpowers project is also MIT-licensed; this attribution is intended to satisfy conservative open-source practice regardless of whether any specific adaptation would trigger the MIT "copies or substantial portions" clause on its own.
