# Testing extension hooks

This directory contains a mock project to verify that LLM agents correctly identify and execute hook commands defined in `.specify/extensions.yml`.

## Test 1: Testing `before_plan` and `after_plan`

1. Open a chat with an LLM (like GitHub Copilot) in this project.
2. Ask it to generate a plan for the current directory:
   > "Please follow `/speckit.plan` for the `./tests/hooks` directory."
3. **Expected behavior**:
   - Before doing any generation, the LLM should notice the `AUTOMATIC Pre-Hook` in `.specify/extensions.yml` under `before_plan`.
   - It should state it is executing `EXECUTE_COMMAND: pre_plan_test`.
   - It should then proceed to read the docs and produce a `plan.md`.
   - After generation, it should output the optional `after_plan` hook (`post_plan_test`) block, asking if you want to run it.

## Test 2: Testing `before_execute` and `after_execute`

*(Requires `plan.md` from Test 1 to exist with a task breakdown)*

1. In the same (or new) chat, ask the LLM to execute the plan:
   > "Please follow `/speckit.execute` for the `./tests/hooks` directory."
2. **Expected behavior**:
   - The LLM should first check for `before_execute` hooks.
   - It should state it is executing `EXECUTE_COMMAND: pre_execute_test` BEFORE doing any actual task execution.
   - It should evaluate the checklists and execute the code writing tasks.
   - Upon completion, it should output the optional `after_execute` hook (`post_execute_test`) block.

## How it works

The templates for these commands in `templates/commands/plan.md` and `templates/commands/execute.md` contain strict ordered lists. The `before_*` hooks are explicitly formulated in a **Pre-Execution Checks** section prior to the outline to ensure they're evaluated first without breaking template step numbers.
