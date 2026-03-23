# Agent Execution Playbook

## Overview

This document guides the automated agent setup (local LLM + Claude Opus 4.6 API) through executing the AssetMantle RWA revival. The agent operates from this repo as its command center, executing work across forked AssetMantle repos.

## Startup Sequence

1. Read `CLAUDE.md` — understand repo purpose, structure, glossary
2. Read `execution/checklist.md` — understand current progress
3. Identify next unchecked item in checklist
4. Read corresponding phase document (e.g., `execution/phase1_triage.md`)
5. Execute the item
6. Update checklist status
7. Write findings to appropriate doc (strategy/ or technical/)
8. Repeat

## LLM Role Split

### Local LLM (code-heavy tasks)
- Running test suites and parsing results
- Dependency analysis (go.mod parsing, import tracing)
- Code migration (SDK v0.47 to v0.50 patterns)
- Protobuf regeneration
- Boilerplate generation (new transaction types, queries)
- Rust/CosmWasm contract scaffolding
- Git operations (fork, branch, commit, PR)

### Opus 4.6 API (reasoning-heavy tasks)
- Strategy document writing and refinement
- Architecture decisions (which approach for compliance, oracle, etc.)
- Regulatory analysis and jurisdiction mapping
- Cross-repo reasoning (how module A interacts with module B)
- Code review for security and correctness
- P2P Protocol synergy design
- Token strategy decisions

## Working Rules

### Git Discipline
- All work on forked repos happens on feature branches, never main
- Branch naming: `rwa/{phase}-{description}` (e.g., `rwa/phase2-sdk-upgrade`)
- Commits: conventional commits (`feat:`, `fix:`, `refactor:`, `docs:`)
- PRs: created for every meaningful change, with description linking to relevant strategy/technical doc
- Never force push. Never rewrite history.

### Documentation Discipline
- Every code change has a corresponding update to a strategy/ or technical/ doc
- Findings that contradict existing docs: update the doc, note the correction
- New discoveries: create new doc or extend existing one
- All claims cite source (file path, commit hash, GitHub URL)

### Safety Rules
- Never push to upstream AssetMantle repos (only forks)
- Never deploy to mainnet without explicit human approval
- Never modify token-related code without flagging for review
- Never bypass compliance checks in test code that could be accidentally promoted
- Stop and ask for human review at every CHECKPOINT in the checklist

### Decision Log

When making non-trivial decisions, log them:

```markdown
## Decision: [Title]
**Date**: YYYY-MM-DD
**Context**: [What prompted this decision]
**Options considered**: [List options]
**Decision**: [What was decided]
**Rationale**: [Why]
**Consequences**: [What this means for future work]
```

Store in the relevant strategy/ or technical/ doc.

## Error Handling

- **Test failure**: Document the failure, attempt fix, if fix takes >30 minutes flag for human review
- **Dependency conflict**: Document exact versions and conflict, try resolution, escalate if unresolvable
- **SDK migration breaks module**: Isolate the break, create minimal reproduction, document in technical/modernization_roadmap.md
- **CosmWasm binding issue**: Check wasmd version compatibility, document in technical/cosmwasm_integration.md
- **Ambiguous requirement**: Check strategy docs first, then flag for human review via checklist comment

## Progress Reporting

After completing each checklist item:
1. Mark item as done: `- [x]`
2. Add completion note: date and brief summary
3. If findings were significant, update relevant docs
4. If findings change the plan, note the change in the decision log
