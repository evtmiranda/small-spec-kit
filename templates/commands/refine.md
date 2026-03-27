---
description: Modify an existing feature plan based on user feedback before execution.
handoffs:
  - label: Execute Plan
    agent: speckit.execute
    prompt: Execute the plan
    send: true
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

Goal: Allow the user to modify the plan before executing it. The user describes what they want changed, and the plan is updated accordingly.

1. Run `{SCRIPT}` from repo root and parse FEATURE_DIR and PLAN_FILE. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Validate**: Ensure plan.md exists. If not, instruct user to run `/speckit.plan` first.

3. **Load existing plan.md** in full.

4. **Parse user input** describing what to change. Examples:
   - "Change the database from SQLite to PostgreSQL"
   - "Add a user story for admin dashboard"
   - "Remove the caching layer, keep it simple"
   - "Split task T012 into smaller tasks"
   - "Use React instead of vanilla JS"
   - "Add authentication with JWT"

5. **Identify affected sections** of plan.md:
   - Requirements change -> update section 1 (Overview & requirements) + section 8 (Task breakdown)
   - Tech stack change -> update section 2 (Technical context) + section 4 (Research & decisions) + section 7 (Project structure) + section 8 (Task breakdown)
   - Data model change -> update section 5 (Data model) + section 8 (Task breakdown)
   - Task change -> update section 8 (Task breakdown)
   - New user story -> update section 1 + section 8
   - Removal of scope -> update section 1 + section 8 (remove related tasks)

6. **Apply changes** while maintaining consistency:
   - If requirements change, propagate to tasks and data model
   - If tech stack changes, update technical context, research decisions, project structure, and affected tasks
   - If tasks are modified, ensure task IDs remain sequential and dependencies are valid
   - Ensure the constitution check (section 3) still passes with the updated plan
   - Preserve any existing completed task markers `[X]`

7. **Write updated plan.md** back to disk.

8. **Generate a change summary** showing:
   - Sections modified
   - Items added, removed, or changed
   - Impact on task count (before/after)
   - Any new decisions or assumptions made

9. **Report completion** with:
   - Path to updated plan
   - Change summary
   - Suggest `/speckit.execute` to proceed with implementation

## Rules

- **Never create a new plan from scratch** - always modify the existing one
- **Preserve completed work** - do not remove or modify tasks already marked as `[X]`
- **Maintain consistency** - changes in one section must propagate to affected sections
- **Keep it focused** - only change what the user asked for, do not reorganize the entire plan
- **Validate task IDs** - after changes, ensure task IDs are sequential and dependencies are correct
