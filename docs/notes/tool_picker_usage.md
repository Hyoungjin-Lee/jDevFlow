---
title: Tool-picker usage
stage: 5-support
bundle: 1
version: 1
language: en
paired_with: tool_picker_usage.ko.md
created: 2026-04-22
updated: 2026-04-22
status: draft
validation_group: 1
---

# Tool-picker usage

## 1. What it is

`/Users/geenya/projects/Jonelab_Platform/jDevFlow/.skills/tool-picker/SKILL.md`
is the jDevFlow advisory skill for choosing the next prompt, document, or
checklist from the current `(stage, mode, risk_level)` state in `HANDOFF.md`.

## 2. When it appears

The skill is meant to match on stage-entry reads and on user asks such as
"what next", "which tool", or "next step" in a jDevFlow conversation.

## 3. How to read the advisory

The output is a short chat block with:

- one primary next step
- an optional checklist reminder
- an optional watch-out

It is advisory only. The user can ignore it, say "skip", or ask for detail.

## 4. What it reads

The skill reads only `HANDOFF.md`, specifically the `## Status` lines for
`Current stage`, `Workflow mode`, and `risk_level`.

## 5. What it does not do

The skill does not block progress, does not modify files, does not register
through a native API, and does not replace bundle-specific review or
implementation prompts.
