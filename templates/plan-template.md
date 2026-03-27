# Feature Plan: [FEATURE NAME]

**Branch**: `[###-feature-name]` | **Created**: [DATE] | **Status**: Draft
**Description**: "$ARGUMENTS"

---

## 1. Overview & requirements

### User stories

<!--
  User stories should be PRIORITIZED as user journeys ordered by importance.
  Each story must be INDEPENDENTLY TESTABLE - implementing just ONE should
  deliver a viable MVP.

  Assign priorities (P1, P2, P3...) where P1 is most critical.
-->

#### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent test**: [Describe how this can be tested independently]

**Acceptance scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

#### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent test**: [Describe how this can be tested independently]

**Acceptance scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge cases

- What happens when [boundary condition]?
- How does system handle [error scenario]?

### Functional requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: System MUST [specific capability]
- **FR-003**: Users MUST be able to [key interaction]

### Success criteria

- **SC-001**: [Measurable metric, e.g., "Users can complete X in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users"]
- **SC-003**: [User satisfaction metric]

### Assumptions

- [Assumption about target users]
- [Assumption about scope boundaries]
- [Dependency on existing system/service]

---

## 2. Technical context

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]
**Primary dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]
**Target platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project type**: [e.g., library/cli/web-service/mobile-app/desktop-app or NEEDS CLARIFICATION]
**Performance goals**: [domain-specific, e.g., 1000 req/s, 60 fps or NEEDS CLARIFICATION]
**Constraints**: [e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]
**Scale/Scope**: [e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

---

## 3. Constitution check

*GATE: Must pass before research. Re-check after design.*

[Gates determined based on constitution file]

---

## 4. Research & decisions

<!--
  For each unknown or NEEDS CLARIFICATION from section 2, research and decide.
  This section replaces the separate research.md artifact.
-->

### [Decision topic 1]

- **Decision**: [what was chosen]
- **Rationale**: [why chosen]
- **Alternatives considered**: [what else evaluated]

### [Decision topic 2]

- **Decision**: [what was chosen]
- **Rationale**: [why chosen]
- **Alternatives considered**: [what else evaluated]

---

## 5. Data model

<!--
  Extract entities from requirements. Define fields, relationships, validations.
  This section replaces the separate data-model.md artifact.
  Skip if the feature does not involve data.
-->

### [Entity 1]

- **Fields**: [field list with types]
- **Relationships**: [to other entities]
- **Validation rules**: [constraints]

### [Entity 2]

- **Fields**: [field list with types]
- **Relationships**: [to other entities]
- **Validation rules**: [constraints]

---

## 6. Interface contracts

<!--
  Document external interfaces the project exposes (APIs, CLI schemas, etc.).
  This section replaces the separate contracts/ directory.
  Skip if project is purely internal.
-->

[Interface contract details, if applicable]

---

## 7. Project structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (unified plan)
└── checklists/          # Optional quality checklists
```

### Source code

<!--
  Replace the placeholder tree below with the concrete layout for this feature.
-->

```text
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/
```

**Structure decision**: [Document the selected structure and rationale]

---

## 8. Task breakdown

<!--
  Tasks organized by user story to enable independent implementation and testing.
  Tests are OPTIONAL - only include if explicitly requested.
-->

### Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

### Phase 1: Setup (shared infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

### Phase 2: Foundational (blocking prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story

- [ ] T004 Setup database schema and migrations framework
- [ ] T005 [P] Implement authentication/authorization framework
- [ ] T006 [P] Setup API routing and middleware structure

**Checkpoint**: Foundation ready - user story implementation can begin

---

### Phase 3: User Story 1 - [Title] (Priority: P1)

**Goal**: [Brief description of what this story delivers]

**Independent test**: [How to verify this story works on its own]

- [ ] T010 [P] [US1] Create [Entity1] model in src/models/[entity1].py
- [ ] T011 [P] [US1] Create [Entity2] model in src/models/[entity2].py
- [ ] T012 [US1] Implement [Service] in src/services/[service].py
- [ ] T013 [US1] Implement [endpoint/feature] in src/[location]/[file].py

**Checkpoint**: User Story 1 should be fully functional and testable independently

---

### Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent test**: [How to verify this story works on its own]

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py

**Checkpoint**: User Stories 1 AND 2 should both work independently

---

[Add more user story phases as needed]

---

### Phase N: Polish & cross-cutting concerns

- [ ] TXXX [P] Documentation updates
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization
- [ ] TXXX Security hardening

---

### Dependencies & execution order

- **Setup (Phase 1)**: No dependencies - start immediately
- **Foundational (Phase 2)**: Depends on Setup - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase
  - Can proceed in parallel or sequentially in priority order (P1 -> P2 -> P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### Within each user story

- Models before services
- Services before endpoints
- Core implementation before integration

### Implementation strategy

**MVP first (User Story 1 only)**:
1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. STOP and VALIDATE independently
5. Deploy/demo if ready

**Incremental delivery**:
1. Setup + Foundational -> Foundation ready
2. Add User Story 1 -> Test -> Deploy (MVP)
3. Add User Story 2 -> Test -> Deploy
4. Each story adds value without breaking previous stories

---

## Complexity tracking

> Fill ONLY if constitution check has violations that must be justified

| Violation | Why needed | Simpler alternative rejected because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why insufficient] |
