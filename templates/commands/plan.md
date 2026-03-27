---
description: Create a unified feature plan including requirements, technical design, research, and task breakdown.
handoffs:
  - label: Execute Plan
    agent: speckit.execute
    prompt: Execute the plan
    send: true
  - label: Refine Plan
    agent: speckit.refine
    prompt: Refine the plan
scripts:
  sh: scripts/bash/create-new-feature.sh "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 "{ARGS}"
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## User input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Pre-execution checks

**Check for extension hooks (before plan)**:
- Check if `.specify/extensions.yml` exists in the project root.
- If it exists, read it and look for entries under the `hooks.before_plan` key
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

The text the user typed after `/speckit.plan` in the triggering message **is** the feature description plus optional tech stack preferences. It should include both WHAT to build and HOW (tech stack). Example: "Build a photo album app using Vite with vanilla JS and SQLite".

Given that input, do this:

1. **Generate a concise short name** (2-4 words) for the branch:
   - Analyze the feature description and extract the most meaningful keywords
   - Use action-noun format when possible (e.g., "add-user-auth", "photo-albums")
   - Preserve technical terms and acronyms

2. **Create the feature branch** by running the script with `--short-name` (and `--json`). In sequential mode, do NOT pass `--number`. In timestamp mode, the script generates a `YYYYMMDD-HHMMSS` prefix automatically:

   **Branch numbering mode**: Before running the script, check if `.specify/init-options.json` exists and read the `branch_numbering` value.
   - If `"timestamp"`, add `--timestamp` (Bash) or `-Timestamp` (PowerShell) to the script invocation
   - If `"sequential"` or absent, do not add any extra flag (default behavior)

   - Bash example: `{SCRIPT} --json --short-name "photo-albums" "Build a photo album app using Vite"`
   - PowerShell example: `{SCRIPT} -Json -ShortName "photo-albums" "Build a photo album app using Vite"`

   **IMPORTANT**:
   - Do NOT pass `--number`
   - Always include the JSON flag
   - You must only ever run this script once per feature
   - Parse the JSON output for BRANCH_NAME and PLAN_FILE paths

3. **Load context**: Read the PLAN_FILE template (already copied by the script) and `/memory/constitution.md`.

4. **Fill all sections of the unified plan** following this execution flow:

   ### Section 1: Overview & requirements
   - Parse the user description to extract key concepts: actors, actions, data, constraints
   - Generate prioritized user stories (P1, P2, P3...) with acceptance scenarios
   - Each story must be independently testable
   - Generate functional requirements (FR-001 style, testable)
   - Generate success criteria (SC-001 style, measurable, technology-agnostic)
   - Document assumptions
   - For unclear aspects, make informed guesses based on context
   - Only mark with [NEEDS CLARIFICATION] if the choice significantly impacts scope (max 3 markers)

   ### Section 2: Technical context
   - Parse tech stack preferences from user input
   - Fill in language, dependencies, storage, testing, platform, etc.
   - Mark unknowns as NEEDS CLARIFICATION

   ### Section 3: Constitution check
   - Load constitution and evaluate gates
   - ERROR if violations are unjustified

   ### Section 4: Research & decisions
   - For each NEEDS CLARIFICATION or unknown, research and decide
   - For each technology choice, find best practices
   - Record decisions with rationale and alternatives considered
   - All NEEDS CLARIFICATION must be resolved in this section

   ### Section 5: Data model
   - Extract entities from requirements
   - Define fields, relationships, validation rules
   - Skip if the feature does not involve data

   ### Section 6: Interface contracts
   - Document external interfaces if applicable (APIs, CLI schemas, etc.)
   - Skip if project is purely internal

   ### Section 7: Project structure
   - Decide project layout based on project type
   - Document the selected structure

   ### Section 8: Task breakdown
   - Generate phased tasks using the checklist format:
     ```
     - [ ] [TaskID] [P?] [Story?] Description with file path
     ```
   - Phase 1: Setup (project initialization)
   - Phase 2: Foundational (blocking prerequisites)
   - Phase 3+: One phase per user story in priority order
   - Final Phase: Polish & cross-cutting concerns
   - Include dependencies and execution order
   - Include implementation strategy (MVP first, incremental delivery)
   - Tests are OPTIONAL: only include test tasks if explicitly requested

5. **Update agent context**: Run `{AGENT_SCRIPT}` to update agent-specific context files.

6. **Re-check constitution** post-design. Verify design decisions align with principles.

7. **Report completion** with:
   - Branch name and plan file path
   - Total task count and tasks per user story
   - Suggested next step: `/speckit.execute` to implement, or `/speckit.refine` to adjust the plan

8. **Check for extension hooks (after plan)**:
   - Check `.specify/extensions.yml` for `hooks.after_plan`
   - Same hook processing logic as pre-execution checks above
   - If no hooks are registered, skip silently

## Quick guidelines

### Requirements (section 1)
- Focus on **WHAT** users need and **WHY**
- Written for business stakeholders, not developers
- Each requirement must be testable
- Max 3 [NEEDS CLARIFICATION] markers

### Technical plan (sections 2-7)
- Be specific about tech choices with rationale
- Resolve all NEEDS CLARIFICATION in the research section
- Project structure must use concrete paths, not template options

### Task breakdown (section 8)
- Every task MUST use the checklist format: `- [ ] [TaskID] [P?] [Story?] Description with file path`
- Tasks organized by user story for independent implementation
- Include exact file paths in descriptions
- Mark parallelizable tasks with [P]
- Label user story tasks with [US1], [US2], etc.

### For AI generation

When creating this plan from a user prompt:

1. **Make informed guesses**: Use context, industry standards, and common patterns to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions subsection
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers
4. **Think like a tester**: Every requirement should be testable and unambiguous

**Examples of reasonable defaults** (don't ask about these):
- Data retention: Industry-standard practices for the domain
- Performance targets: Standard web/mobile app expectations unless specified
- Error handling: User-friendly messages with appropriate fallbacks
- Authentication method: Standard session-based or OAuth2 for web apps

### Success criteria guidelines

Success criteria must be:
1. **Measurable**: Include specific metrics (time, percentage, count, rate)
2. **Technology-agnostic**: No mention of frameworks, languages, databases, or tools
3. **User-focused**: Describe outcomes from user/business perspective
4. **Verifiable**: Can be tested without knowing implementation details

### Task generation rules

**Checklist format (REQUIRED)**:
```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format components**:
1. **Checkbox**: ALWAYS start with `- [ ]`
2. **Task ID**: Sequential number (T001, T002, T003...)
3. **[P] marker**: Include ONLY if task is parallelizable
4. **[Story] label**: REQUIRED for user story phase tasks ([US1], [US2], etc.)
5. **Description**: Clear action with exact file path

**Examples**:
- `- [ ] T001 Create project structure per implementation plan`
- `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- `- [ ] T012 [P] [US1] Create User model in src/models/user.py`

**NOTE:** The script creates and checks out the new branch and initializes the plan file before writing.
