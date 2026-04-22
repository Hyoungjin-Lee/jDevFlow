# Skill: [Skill Name]

> One-line tagline — what this skill makes Claude do.

---

## 1. Purpose

[One sentence. Example: "Generate the weekly sales report and save it to `reports/` as a Markdown file."]

## 2. When to Use

Read this skill when **any** of the following is true:

- User asks for: [trigger phrase 1], [trigger phrase 2]
- Current stage is: [stage or file]
- Input file matches: [filename or glob]

Do NOT read this skill when:

- [counter-trigger, e.g., the user only wants a preview, not a saved report]

## 3. Do

- [Concrete allowed action, with a verb]
- [Concrete allowed action, with a verb]
- [Concrete allowed action, with a verb]

## 4. Don't

- [Concrete forbidden action]
- [Concrete forbidden action]
- [Concrete forbidden action]

## 5. Red Flags — stop and ask

If any of these happen, stop the task and ask the user:

- [Signal, e.g., "secret value appears in logs or CLI output"]
- [Signal, e.g., "output file already exists and overwrite is not set"]
- [Signal, e.g., "row count is zero or > N"]

## 6. Good / Bad

**Good**

```
[Short, realistic good example]
```

Why: [one line — what makes this correct]

**Bad**

```
[Short, realistic bad example]
```

Why: [one line — what makes this wrong]

## 7. Checklist — all must be true before declaring done

- [ ] [Observable check, e.g., "file exists at `reports/YYYY-MM-DD.md`"]
- [ ] [Observable check]
- [ ] [Observable check]
- [ ] [Observable check]
- [ ] [Observable check]

## 8. Verification

Show you are done by running or showing one of:

```bash
# [example verification command]
```

Or by pointing to: [file / log / test result].

---

## Optional sections

### Prerequisites

- [Env vars, secrets, pip packages, CLI tools]

### Inputs / Outputs

- **Input:** [file / arg]
- **Output:** [file / return value]

### Rollback

- [How to undo the side effect if this skill fails mid-way]

### Notes

- [Edge cases, rate limits, known failure modes]
