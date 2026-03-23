# Phase 3: RWA Module Extensions (Weeks 9-16)

## Objective

Extend the 7 existing modules for RWA use cases and build the CosmWasm contracts for compliance, distribution, oracles, and custodian bridge.

## Prerequisites

- Phase 2 complete
- All modules on SDK v0.50
- CosmWasm operational

## Tasks

### 3.1 Identities: Compliance Tiers + Jurisdiction

See [identity_compliance.md](../technical/identity_compliance.md) for full design.

1. Add `tier` field to identity schema (u8, 0-4)
2. Add `jurisdiction` field (ISO-3166 string)
3. Add `accreditation_expiry` field (timestamp)
4. Add `sanctions_cleared` field (bool + timestamp)
5. Modify `issue` to enforce tier assignment rules
6. Modify `quash` to auto-trigger on accreditation expiry
7. Add tier-check query for CosmWasm bindings
8. Tests + PR: `rwa/phase3-identity-compliance`

### 3.2 Assets: Pre-Transfer Compliance Hooks

1. Add compliance contract address to asset classification
2. Modify `send` to call compliance contract before transfer
3. Add `freeze` / `unfreeze` transactions (regulatory holds)
4. Add compliance metadata fields to asset definition
5. Tests + PR: `rwa/phase3-assets-compliance`

### 3.3 Compliance Checker Contract (CosmWasm)

See [rwa_module_design.md](../technical/rwa_module_design.md) for interface spec.

1. Scaffold Rust contract with CosmWasm SDK
2. Implement `CheckTransfer` execute handler
3. Implement custom queries to Identity and Classification modules
4. Add per-classification configuration (min tier, jurisdictions, lockup, max holders)
5. Unit tests + integration tests
6. PR: `rwa/phase3-compliance-contract`

### 3.4 Distribution Engine Contract (CosmWasm)

1. Scaffold Rust contract
2. Implement `CreateDistribution` and `ExecuteDistribution`
3. Query Splits module for holder list + percentages
4. Support multiple denomination tokens (USDC, native)
5. Implement waterfall distribution for tranched products
6. Unit tests + integration tests
7. PR: `rwa/phase3-distribution-contract`

### 3.5 Oracle Adapter Contract (CosmWasm)

1. Scaffold Rust contract
2. Implement `SubmitPrice` and `QueryPrice`/`QueryNAV`
3. Multi-source aggregation with median + outlier rejection
4. Staleness checks
5. Unit tests
6. PR: `rwa/phase3-oracle-contract`

### 3.6 Splits: Cap Table + Distribution

1. Add cap table tracking (ownership percentages, change history)
2. Add minimum denomination enforcement
3. Add max holder count enforcement
4. Add holder snapshot query (for distribution engine)
5. Add distribution schedule metadata
6. Tests + PR: `rwa/phase3-splits-extensions`

### 3.7 Maintainers: RWA Roles

1. Add role type enum (custodian, appraiser, auditor, legal_agent, servicer, oracle)
2. Add attestation transaction (maintainer signs off on asset status)
3. Add attestation schedule tracking (missed attestation alerts)
4. Add multi-sig configuration for critical operations
5. Tests + PR: `rwa/phase3-maintainers-rwa`

### 3.8 Metas: Legal Wrapper Registry

1. Add legal wrapper data model (entity type, name, jurisdiction, registration, docs hash)
2. Add create/update/verify legal wrapper transactions
3. Enforce: every RWA asset must have a legal wrapper before minting
4. Add audit trail for all metadata changes
5. Tests + PR: `rwa/phase3-metas-legal-wrapper`

### 3.9 Custodian Bridge Contract (CosmWasm)

1. Scaffold Rust contract
2. Implement attestation submission
3. Implement mint/burn request flow
4. Verify attestation before authorizing mint
5. Unit tests + integration tests
6. PR: `rwa/phase3-custodian-bridge`

### 3.10 IBC Compliance Middleware

See [ibc_rwa.md](../technical/ibc_rwa.md) for design.

1. Build IBC middleware that intercepts ICS-721 packets
2. Check receiver identity on outgoing transfers
3. Build identity attestation relay
4. Tests with simulated IBC transfer
5. PR: `rwa/phase3-ibc-compliance`

### 3.11 Integration Tests: Full RWA Lifecycle

End-to-end test covering:
1. Define identity schema (US accredited)
2. Issue identity to test user (Tier 2)
3. Define RWA classification (US Treasury)
4. Create legal wrapper for the asset
5. Assign custodian as maintainer
6. Custodian submits attestation
7. Mint RWA token
8. Transfer between two verified users (compliance check passes)
9. Attempt transfer to unverified user (compliance check fails)
10. Execute distribution to all holders
11. Burn/redeem token

### 3.12 Developer Documentation

- API reference for all new transactions and queries
- CosmWasm contract deployment guide
- RWA issuance walkthrough (step by step)
- Compliance configuration guide
- Integration guide for KYC providers

## Deliverables

- [ ] 7 modules extended for RWA
- [ ] 4 CosmWasm contracts (compliance, distribution, oracle, custodian)
- [ ] IBC compliance middleware
- [ ] Full lifecycle integration test passing
- [ ] Developer documentation complete
