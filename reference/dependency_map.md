# Dependency Map

Known dependency versions across key repos.

> **Status**: Partial. Needs go.mod extraction from source (checklist item 1.7).

## Node Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Target: v0.50.x |
| CometBFT | v0.37.5 | Target: v0.38.x (ABCI 2.0) |
| IBC-Go | v7.4.0 | Target: v8.x |
| Go | 1.23.1 | Already current |
| CosmWasm (wasmd) | N/A | To be added |

## Modules Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Must match node |
| Schema | latest | Internal dependency |
| Go | 1.23.1 | Already current |

## Schema Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Must match node |
| Go | 1.23.1 | Already current |

## Dependency Graph

```
node
├── modules
│   └── schema
├── cosmos-sdk v0.47.14
├── cometbft v0.37.5
├── ibc-go v7.4.0
└── (future) wasmd v0.50+
```

## Upgrade Order

Schema must be upgraded first, then modules, then node. This is because:
1. Schema defines types used by modules
2. Modules implement business logic using schema types
3. Node wires everything together

```
schema (upgrade first)
  ↓
modules (upgrade second)
  ↓
node (upgrade last)
```

## Action Items

- [ ] Extract full go.mod from each repo via GitHub API
- [ ] Map all transitive dependencies
- [ ] Identify version conflicts between repos
- [ ] Create compatibility matrix for SDK v0.50 upgrade
