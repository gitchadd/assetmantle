# Phase 2: Modernize (Weeks 3-8)

## Objective

Upgrade the core stack from Cosmos SDK v0.47 to v0.50+, add CosmWasm, and verify everything still works.

## Prerequisites

- Phase 1 complete
- Test suites passing (or known failures documented)
- Token strategy decision made

## Tasks

### 2.1 Schema Repo Upgrade

Start here because modules depends on schema.

1. Update go.mod: SDK v0.50.x dependencies
2. Migrate type definitions for new SDK patterns
3. Run tests
4. Create PR: `rwa/phase2-schema-sdk-upgrade`

### 2.2 Metas Module — Proof of Concept

Metas is the simplest module (fewest transactions). Use it to establish the migration pattern.

1. Migrate to `appmodule.AppModule` interface
2. Add `depinject` providers
3. Update keeper constructor
4. Update genesis import/export
5. Run module tests
6. Document the migration pattern for other modules
7. Create PR: `rwa/phase2-metas-sdk-upgrade`

### 2.3 Remaining Modules

Apply the pattern from 2.2 to: classifications, maintainers, identities, splits, assets, orders (in this order — simpler to more complex).

For each module:
1. Apply migration pattern
2. Run module tests
3. Fix breakages
4. Create PR per module

### 2.4 Node Repo Upgrade

1. Update go.mod: SDK v0.50.x, CometBFT v0.38.x
2. Rewrite app.go for new module manager + depinject
3. Update genesis handling
4. Update upgrade handler
5. Run node tests
6. Create PR: `rwa/phase2-node-sdk-upgrade`

### 2.5 IBC-Go Upgrade

1. Update to IBC-Go v8.x
2. Verify ICS-20 (token transfer) works
3. Verify ICS-721 (NFT transfer) works
4. Update IBC module registration
5. Create PR: `rwa/phase2-ibc-upgrade`

### 2.6 Protobuf Regeneration

1. Update buf.yaml / buf.gen.yaml for new SDK patterns
2. Regenerate all .pb.go files
3. Verify gRPC endpoints
4. Verify REST gateway
5. Create PR: `rwa/phase2-protobuf-regen`

### 2.7 CosmWasm Integration

1. Add wasmd v0.50+ to node
2. Configure permissioned uploads
3. Write a simple test contract (hello world)
4. Deploy to local testnet
5. Verify contract execution
6. Create PR: `rwa/phase2-cosmwasm-integration`

### 2.8-2.9 Full Test + Local Testnet

1. Run all tests across all repos
2. Start local testnet with all modules + CosmWasm
3. Execute basic transactions in each module
4. Verify state persistence across restarts
5. Document any remaining issues

## Risk Mitigation

- If SDK v0.50 migration proves too complex for a module, document the specific issue and consider keeping that module on v0.47 patterns (SDK v0.50 supports legacy modules temporarily)
- If CosmWasm integration conflicts with existing modules, isolate it and defer to Phase 3
- Keep a working v0.47 branch at all times — never break the ability to run the existing chain

## Deliverables

- [ ] All 7 modules migrated to SDK v0.50
- [ ] Node running on SDK v0.50 + CometBFT v0.38
- [ ] IBC-Go v8.x functional
- [ ] CosmWasm operational on local testnet
- [ ] All PRs created and passing CI
- [ ] Migration guide documented for each module
