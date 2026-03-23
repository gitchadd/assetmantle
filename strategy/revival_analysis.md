# Revival Analysis: Keep / Rebuild / Kill

## Current State Summary

AssetMantle: Cosmos SDK appchain, 45 GitHub repos, launched 2022 for interchain NFTs. Protocol is dormant. $MNTL stopped trading Dec 2025. ~139 ERC-20 holders on Etherscan (native Cosmos holder count unknown). No exchange listings. Community channels inactive.

Core codebase is surprisingly healthy: SDK v0.47.14, CometBFT v0.37.5, Go 1.23.1. One major SDK version behind current (v0.50+). 4,626 commits across the modules repo alone.

## KEEP

### 1. Modules Repo (Priority: Critical)
- **Repo**: [AssetMantle/modules](https://github.com/AssetMantle/modules)
- **Why**: 7 well-structured modules with complete transaction lifecycles. Each module follows a consistent pattern (auxiliaries, genesis, invariants, key, mappable, mapper, migrations, parameters, queries, record, simulator, transactions). This is the crown jewel.
- **Modules**: assets, identities, splits, orders, classifications, maintainers, metas
- **RWA fit**: Every module has a direct RWA application (see [rwa_pivot.md](rwa_pivot.md))

### 2. Node Repo (Priority: Critical)
- **Repo**: [AssetMantle/node](https://github.com/AssetMantle/node)
- **Why**: Already on SDK v0.47.14. The v0.50 upgrade is one major version, not a rewrite. 802 commits. Last release v1.0.1 (Feb 2024).

### 3. Schema Repo (Priority: High)
- **Repo**: [AssetMantle/schema](https://github.com/AssetMantle/schema)
- **Why**: Rich type system (data, documents, ids, lists, parameters, properties, qualified, types). Provides strong foundations for RWA metadata schemas.

### 4. interNFT Standard (Priority: High)
- **Why**: The intellectual work on cross-chain NFT/asset standards predated ICS-721. The thinking applies directly to cross-chain RWA portability. The standard concepts need updating for ICS-721 compatibility but the framework is sound.

### 5. Key Module Capabilities
- **Assets wrap/unwrap**: Exactly what RWA tokenization needs. Wrapping real-world value into on-chain representation.
- **Identity lifecycle**: define, issue, quash, revoke, deputize, govern, provision/unprovision. Maps directly to KYC/AML.
- **Splits**: Fractional ownership primitives. Core RWA requirement.
- **Orders**: Complete order book (make, take, get, put, cancel, modify, immediate). Secondary market for RWA tokens.

## REBUILD

### 1. Cosmos SDK Upgrade (v0.47 to v0.50+)
- Required for: CometBFT v0.38+ (ABCI 2.0), depinject module system, latest IBC-Go v8.x
- Estimated effort: Medium. The module architecture is clean, but protobuf definitions and module registration patterns change significantly between v0.47 and v0.50.
- See [../technical/modernization_roadmap.md](../technical/modernization_roadmap.md)

### 2. CosmWasm Integration
- Current chain is pure Go modules. No smart contract capability.
- CosmWasm enables programmable RWA logic (compliance rules, distribution schedules, oracle callbacks) without chain upgrades.
- Critical for: rapid iteration on RWA-specific business logic without governance proposals for every change.

### 3. Wallet and Client Apps
- Current wallet is NFT-marketplace focused (MantleWallet).
- Needs complete rebuild for RWA UX: portfolio view, compliance status, yield tracking, document access.

### 4. Documentation
- Current docs at docs.assetmantle.one are entirely NFT-marketplace focused.
- Need comprehensive RWA developer docs, API references, integration guides.

## KILL

### 1. MantlePlace (NFT Marketplace)
- Dead product in a dead market. No users, no volume.
- **Action**: Archive repo. Preserve code for reference only.

### 2. MantleBuilder (No-Code Marketplace Creator)
- Same reasoning. The "Shopify of NFTs" vision did not materialize.
- **Action**: Archive.

### 3. MantleExplorer
- Custom explorer with no advantage over standard alternatives.
- **Action**: Replace with [ping.pub](https://ping.pub/) or [Celatone](https://celat.one/).

### 4. Legacy Websites
- mantlePlace-website, interNFT-website, mantleWorks-website, Artists4Web3 assets
- **Action**: Archive all. Build one clean RWA-focused site.

### 5. Stale Repos (30+)
- Hacktoberfest-2022, NFT-Mint-Documentation, nft-upload, rarity checkers, etc.
- Most untouched since 2022.
- **Action**: Archive. Do not fork.

### 6. $MNTL Token (In Current Form)
- 139 holders on Etherscan. No exchange listings. No liquidity.
- **Options** (detailed in [token_strategy.md](token_strategy.md)):
  - (a) Governance proposal to migrate to new token with airdrop/swap
  - (b) Relaunch with new tokenomics designed for RWA
  - (c) Revive $MNTL with new utility and listings
- Decision requires: community analysis, legal review, chain state investigation.

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| SDK upgrade breaks module compatibility | High | Incremental upgrade with comprehensive test coverage |
| No remaining community to govern chain | High | Bootstrap new validator set, new governance |
| Legal liability from original $MNTL | Medium | Legal review before any token action |
| Competitor moats (Ondo, Securitize) | Medium | Differentiate on interchain + fractional ownership |
| Chain state corrupted or unrecoverable | Medium | Option to launch fresh genesis |
