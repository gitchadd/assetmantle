# Dependency Map

Known dependency versions across key repos.

> **Status**: Verified from go.mod extraction (2026-03-23).

## Node Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Target: v0.50.x |
| CometBFT | v0.37.5 | Target: v0.38.x (ABCI 2.0) |
| IBC-Go | v7.4.0 | Target: v8.x |
| IBC Packet Forward Middleware | v7.1.3 | |
| Stride IBC Rate Limiting | v1.0.1 | |
| Go | 1.23.1 | Requires Go 1.23+ |
| CosmWasm (wasmd) | N/A | To be added |
| AssetMantle/modules | v0.4.1-0.20241014065044 | Pinned to specific commit |

## Modules Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Must match node |
| CometBFT | v0.37.5 | |
| CometBFT-DB | v0.7.0 | |
| Schema | v1.0.1-0.20241014062620 | Pinned to specific commit |
| gogoproto | v1.7.0 | |
| grpc-gateway | v1.16.0 | |
| IBM/sarama | v1.43.3 | Kafka client (interesting — possible event streaming) |
| Go | 1.23.1 | |

## Schema Repo

| Dependency | Version | Notes |
|-----------|---------|-------|
| Cosmos SDK | v0.47.14 | Must match node |
| cosmossdk.io/math | v1.3.0 | |
| gogoproto | v1.7.0 | |
| Go | 1.23 | |

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

## Notable Findings

- **IBM/sarama (Kafka)** in modules repo — suggests event streaming was planned or used. Worth investigating for RWA event publishing.
- **Stride IBC Rate Limiting** in node — chain already has IBC rate limiting middleware. Good for RWA compliance.
- **IBC Packet Forward Middleware** — enables multi-hop IBC. Good for cross-chain RWA routing.
- All three repos pin to exact same SDK (v0.47.14) and CometBFT (v0.37.5) — no version conflicts.

## Action Items

- [x] Extract full go.mod from each repo via GitHub API
- [ ] Map all transitive dependencies
- [ ] Identify version conflicts between repos — **None found** (all aligned on SDK v0.47.14)
- [ ] Create compatibility matrix for SDK v0.50 upgrade
