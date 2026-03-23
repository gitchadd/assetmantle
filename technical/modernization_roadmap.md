# Technical Modernization Roadmap

## Current Stack

| Component | Current Version | Target Version |
|-----------|----------------|----------------|
| Cosmos SDK | v0.47.14 | v0.50.x (or v0.52.x if stable) |
| CometBFT | v0.37.5 | v0.38.x (ABCI 2.0) |
| IBC-Go | v7.4.0 | v8.x |
| Go | 1.23.1 | 1.23+ (already current) |
| CosmWasm | N/A | wasmd v0.50+ |
| Protobuf | proto3 | proto3 (regenerate for new SDK) |

## Phase A: Cosmos SDK v0.47 to v0.50 (Weeks 3-5)

### Key Changes in v0.50
- **Depinject**: New dependency injection framework for module registration. All 7 modules need `depinject` providers.
- **Module Manager v2**: Replaces the old `BasicManager`/`Manager` pattern. Each module needs `appmodule.AppModule` interface.
- **AutoCLI**: Automatic CLI generation from protobuf. Replaces hand-written CLI commands.
- **Collections**: New storage API. Optional but recommended for new code.
- **ORM**: Table-based storage pattern. Optional.
- **Store v2**: New multi-store implementation. Can adopt incrementally.

### Migration Steps
1. Update `go.mod` dependencies (SDK, CometBFT, IBC-Go)
2. Migrate each module to implement `appmodule.AppModule`
3. Add `depinject` providers to each module
4. Update protobuf service definitions for new registration patterns
5. Migrate keeper constructors to use `depinject`
6. Update `app.go` to use new module manager
7. Run all existing tests, fix breakages

### Risk Assessment
- **High risk**: The 7 custom modules are deeply integrated with SDK v0.47 patterns. Each module has its own mapper, keeper, and genesis patterns that may not align with v0.50 conventions.
- **Mitigation**: Incremental migration. Start with one simple module (metas) as proof of concept, then apply pattern to others.

## Phase B: CometBFT v0.37 to v0.38 (Week 5)

### Key Changes
- **ABCI 2.0**: New `FinalizeBlock` replaces `BeginBlock`/`EndBlock`/`DeliverTx`. SDK v0.50 handles most of this abstraction.
- **Vote extensions**: Enable validators to include custom data in votes. Useful for oracle price feeds.
- **Optimistic execution**: Parallel transaction processing preparation.

### Migration Steps
1. Update CometBFT dependency
2. SDK v0.50 abstracts most ABCI 2.0 changes — minimal direct work
3. Configure vote extensions if needed for oracle integration

## Phase C: IBC-Go v7.4 to v8.x (Week 6)

### Key Changes
- **ICS-721 improvements**: Better NFT transfer support
- **Callbacks middleware**: IBC callbacks for post-transfer actions
- **Channel upgradability**: Upgrade existing channels without closing

### Migration Steps
1. Update IBC-Go dependency
2. Update IBC module registration in `app.go`
3. Verify ICS-721 compatibility with Assets module
4. Add IBC callbacks for compliance checks on incoming RWA transfers

## Phase D: CosmWasm Integration (Weeks 7-8)

### Why CosmWasm
- Programmable compliance rules without chain upgrades
- Rapid iteration on RWA business logic
- Third-party developers can build on the chain
- Oracle adapters, distribution contracts, custodian bridges

### Integration Steps
1. Add `wasmd` module to `app.go`
2. Configure CosmWasm permissions (permissioned upload initially — only governance-approved contracts)
3. Build Rust contracts for:
   - Compliance checker (called by Assets module as pre-transfer hook)
   - Distribution engine (triggered by maintainers for yield distribution)
   - Oracle adapter (aggregates price feeds for NAV)
4. Create bindings between Go modules and CosmWasm contracts (custom msg/query)

### Architecture Decision
- **Permissioned CosmWasm**: Only governance-approved contracts can be deployed. This is appropriate for an RWA chain where contract behavior must be auditable.
- **Module-to-Wasm bindings**: Go modules call CosmWasm contracts via custom messages. This keeps core logic in Go but allows configurable business rules in Wasm.

## Phase E: Protobuf Regeneration (Week 6, parallel with C)

1. Regenerate all protobuf files for SDK v0.50 patterns
2. Update gRPC gateway endpoints
3. Verify REST API compatibility
4. Update client libraries (JavaScript/TypeScript)

## Testing Strategy

### Per-Phase Testing
- Run existing test suite after each phase
- Add integration tests for cross-module interactions
- Simulate genesis export/import to verify state migration

### End-to-End Testing
- Deploy testnet with full module set
- Execute all transaction types across all modules
- Test IBC transfers (ICS-20 for tokens, ICS-721 for assets)
- Test CosmWasm contract execution with module bindings
- Simulate upgrade from v0.47 chain state to v0.50

## Dependencies and Blockers

| Blocker | Impact | Resolution |
|---------|--------|------------|
| Module mapper pattern unique to AssetMantle | High | May need significant refactor for v0.50 keeper patterns |
| Schema repo tightly coupled to modules | Medium | Upgrade schema first, then modules |
| Custom genesis handling per module | Medium | Rewrite genesis import/export for new patterns |
| No existing CosmWasm bindings | Medium | Write custom bindings (Rust + Go) |
