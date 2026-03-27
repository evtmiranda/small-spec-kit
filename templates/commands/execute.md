---
description: Execute the feature plan by processing and completing all tasks defined in plan.md
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Pre-execution checks

**Check for extension hooks (before execution)**:
- Check if `.specify/extensions.yml` exists in the project root.
- If it exists, read it and look for entries under the `hooks.before_execute` key
- If the YAML cannot be parsed or is invalid, skip hook checking silently and continue normally
- Filter out hooks where `enabled` is explicitly `false`. Treat hooks without an `enabled` field as enabled by default.
- For each remaining hook, do **not** attempt to interpret or evaluate hook `condition` expressions:
  - If the hook has no `condition` field, or it is null/empty, treat the hook as executable
  - If the hook defines a non-empty `condition`, skip the hook and leave condition evaluation to the HookExecutor implementation
- For each executable hook, output the following based on its `optional` flag:
  - **Optional hook** (`optional: true`):
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **Mandatory hook** (`optional: false`):
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Outline.
    ```
- If no hooks are registered or `.specify/extensions.yml` does not exist, skip silently

## Outline

1. Run `{SCRIPT}` from repo root and parse FEATURE_DIR and PLAN_FILE. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Check checklists status** (if FEATURE_DIR/checklists/ exists):
   - Scan all checklist files in the checklists/ directory
   - For each checklist, count total, completed, and incomplete items
   - Create a status table:

     ```text
     | Checklist | Total | Completed | Incomplete | Status |
     |-----------|-------|-----------|------------|--------|
     | ux.md     | 12    | 12        | 0          | PASS   |
     | test.md   | 8     | 5         | 3          | FAIL   |
     ```

   - **If any checklist is incomplete**: STOP and ask if user wants to proceed anyway
   - **If all checklists are complete**: Automatically proceed

3. **Load plan.md** and extract all context:
   - **Section 1**: Overview & requirements (user stories, functional requirements, success criteria)
   - **Section 2**: Technical context (tech stack, dependencies, constraints)
   - **Section 5**: Data model (entities, relationships)
   - **Section 6**: Interface contracts (if applicable)
   - **Section 7**: Project structure (file layout)
   - **Section 8**: Task breakdown (phased task list with dependencies)

4. **Project setup verification**:
   - **REQUIRED**: Create/verify ignore files based on actual project setup:
   - Check if git repo -> create/verify .gitignore
   - Check if Dockerfile exists or Docker in plan -> create/verify .dockerignore
   - Check if .eslintrc exists -> create/verify .eslintignore
   - Check if .prettierrc exists -> create/verify .prettierignore
   - **If ignore file already exists**: Verify it contains essential patterns, append missing critical patterns only
   - **If ignore file missing**: Create with full pattern set for detected technology

   **Common patterns by technology** (from section 2 tech stack):
   - **Node.js**: `node_modules/`, `dist/`, `build/`, `*.log`, `.env*`
   - **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `dist/`, `*.egg-info/`
   - **Java**: `target/`, `*.class`, `*.jar`, `.gradle/`, `build/`
   - **C#/.NET**: `bin/`, `obj/`, `*.user`, `*.suo`, `packages/`
   - **Go**: `*.exe`, `*.test`, `vendor/`, `*.out`
   - **Rust**: `target/`, `debug/`, `release/`, `*.rs.bk`
   - **Universal**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.swp`, `.vscode/`, `.idea/`

5. **Parse task breakdown** from section 8 of plan.md:
   - Extract task phases, IDs, descriptions, file paths, parallel markers [P]
   - Determine execution flow and dependency requirements

6. **Execute implementation** following the task plan:
   - **Phase-by-phase execution**: Complete each phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together
   - **File-based coordination**: Tasks affecting the same files must run sequentially
   - **Validation checkpoints**: Verify each phase completion before proceeding

7. **Implementation execution rules**:
   - **Setup first**: Initialize project structure, dependencies, configuration
   - **Tests before code**: If test tasks exist, write tests before implementation
   - **Core development**: Implement models, services, CLI commands, endpoints
   - **Integration work**: Database connections, middleware, logging, external services
   - **Polish and validation**: Unit tests, performance optimization, documentation

8. **Progress tracking and error handling**:
   - Report progress after each completed task
   - Halt execution if any non-parallel task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - **IMPORTANT**: For completed tasks, mark as `[X]` in the plan.md task breakdown section

9. **Completion validation**:
   - Verify all required tasks are completed
   - Check that implemented features match the requirements in section 1
   - Validate that tests pass and coverage meets requirements
   - Confirm the implementation follows the technical plan
   - Report final status with summary of completed work

Note: This command assumes a complete plan exists in plan.md. If plan.md is missing or has no task breakdown, suggest running `/speckit.plan` first.

10. **Check for extension hooks (after execution)**:
    - Check `.specify/extensions.yml` for `hooks.after_execute`
    - Same hook processing logic as pre-execution checks above
    - If no hooks are registered, skip silently
