# Quick start guide

This guide will help you get started with Spec-Driven Development using Spec Kit.

> [!NOTE]
> All automation scripts now provide both Bash (`.sh`) and PowerShell (`.ps1`) variants. The `specify` CLI auto-selects based on OS unless you pass `--script sh|ps`.

## The 3-step process

> [!TIP]
> **Context awareness**: Spec Kit commands automatically detect the active feature based on your current Git branch (e.g., `001-feature-name`). To switch between different plans, simply switch Git branches.

### Step 1: Install Specify

**In your terminal**, run the `specify` CLI command to initialize your project:

```bash
# Create a new project directory
uvx --from git+https://github.com/evtmiranda/small-spec-kit.git specify init <PROJECT_NAME>

# OR initialize in the current directory
uvx --from git+https://github.com/evtmiranda/small-spec-kit.git specify init .
```

Pick script type explicitly (optional):

```bash
uvx --from git+https://github.com/evtmiranda/small-spec-kit.git specify init <PROJECT_NAME> --script ps  # Force PowerShell
uvx --from git+https://github.com/evtmiranda/small-spec-kit.git specify init <PROJECT_NAME> --script sh  # Force POSIX shell
```

### Step 2: Plan your feature

**In your AI Agent's chat interface**, optionally set up a constitution first, then use `/speckit.plan` to describe what you want to build, including your tech stack:

```markdown
/speckit.constitution This project follows a "Library-First" approach. All features must be implemented as standalone libraries first. We use TDD strictly.
```

```markdown
/speckit.plan Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Use Vite with vanilla HTML, CSS, and JavaScript. Metadata is stored in a local SQLite database.
```

This creates a unified `plan.md` with requirements, user stories, technical decisions, data model, project structure, and a phased task breakdown.

### Step 3: Execute the plan

```markdown
/speckit.execute
```

> [!TIP]
> **Refine before executing**: If anything needs adjustment, use `/speckit.refine` to modify the plan before executing. For example: `/speckit.refine Change the database to PostgreSQL`.

> [!TIP]
> **Phased implementation**: For complex projects, implement in phases to avoid overwhelming the agent's context. Start with core functionality, validate it works, then add features incrementally.

## Detailed example: building Taskify

Here's a complete example of building a team productivity platform:

### Step 1: Define constitution

Initialize the project's constitution to set ground rules:

```markdown
/speckit.constitution Taskify is a "Security-First" application. All user inputs must be validated. We use a microservices architecture. Code must be fully documented.
```

### Step 2: Plan the feature with `/speckit.plan`

Describe what you want to build AND your tech stack in one command:

```text
/speckit.plan Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. Five predefined users (one PM, four engineers),
no login needed. Standard Kanban columns: To Do, In Progress, In Review, Done. Drag and drop between columns.
Users see their assigned cards in a different color. Comments are editable/deletable only by the author.
Use .NET Aspire with Blazor server, PostgreSQL, and REST APIs for projects, tasks, and notifications.
```

### Step 3: Refine (optional)

If anything needs adjustment:

```bash
/speckit.refine Add real-time updates via SignalR and for each sample project, create 5-15 tasks randomly distributed across completion states
```

### Step 4: Execute

```bash
/speckit.execute
```

> [!TIP]
> **Phased implementation**: For large projects like Taskify, consider implementing in phases (e.g., Phase 1: Basic project/task structure, Phase 2: Kanban functionality, Phase 3: Comments and assignments). This prevents context saturation and allows for validation at each stage.

## Key principles

- **Be explicit** about what you're building, why, and what tech stack to use
- **Iterate with `/speckit.refine`** before executing
- **Let the AI agent handle** the implementation details

## Next steps

- Read the [complete methodology](https://github.com/evtmiranda/small-spec-kit/blob/main/spec-driven.md) for in-depth guidance
- Check out [more examples](https://github.com/evtmiranda/small-spec-kit/tree/main/templates) in the repository
- Explore the [source code on GitHub](https://github.com/evtmiranda/small-spec-kit)
