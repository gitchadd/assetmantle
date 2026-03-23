# CLAUDE.md

## Purpose

This is the strategy and execution repo for reviving the AssetMantle protocol with an RWA (Real World Asset) tokenization pivot. It serves as the command center for automated agent execution across forked AssetMantle repos.

## Directory Map

| Path | Contents |
|------|----------|
| **strategy/** | Revival analysis, RWA pivot plan, token strategy, competitive landscape, regulatory |
| **technical/** | SDK modernization roadmap, module audit, RWA module design, identity/compliance, CosmWasm, IBC |
| **execution/** | Master checklist, phased plans (weeks 1-24), agent playbook |
| **synergies/** | P2P Protocol integration: identity bridge, fiat on-ramp, shared compliance |
| **reference/** | Module inventory (all 45 repos), transaction reference, dependency map |

## Upstream Repos (AssetMantle org)

| Repo | Stack | Purpose |
|------|-------|---------|
| [AssetMantle/node](https://github.com/AssetMantle/node) | Go, Cosmos SDK v0.47.14, CometBFT v0.37.5 | Core blockchain node |
| [AssetMantle/modules](https://github.com/AssetMantle/modules) | Go | 7 protocol modules: assets, identities, splits, orders, classifications, maintainers, metas |
| [AssetMantle/schema](https://github.com/AssetMantle/schema) | Go | Type system: data, documents, ids, lists, parameters, properties, qualified, types |
| [AssetMantle/wallet](https://github.com/AssetMantle/wallet) | TypeScript | Official wallet |
| [AssetMantle/client](https://github.com/AssetMantle/client) | JavaScript | Client library |

## Domain Glossary

| Term | Meaning |
|------|---------|
| **MantleChain** | AssetMantle's sovereign Cosmos SDK appchain. Tendermint/CometBFT consensus. |
| **interNFT** | Cross-chain NFT standard predating ICS-721. Core innovation of AssetMantle. |
| **Classifications** | Module defining asset type schemas. Maps to RWA taxonomy (equity, debt, RE, commodity). |
| **Splits** | Module for fractional ownership. Key for RWA fractionalization + distribution. |
| **Maintainers** | Module for delegated authority over assets. Maps to custodians, auditors, oracles. |
| **Assets** | Module with define/mint/burn/send/mutate/wrap/unwrap. Wrap/unwrap = RWA tokenization primitive. |
| **Identities** | Module with define/issue/quash/revoke/deputize/govern/provision. Maps to KYC lifecycle. |
| **Orders** | Module with make/take/get/put/cancel/modify/immediate. Secondary market for RWA. |
| **Metas** | Module for on-chain metadata. Legal docs, valuations, audit trails for RWA. |
| **$MNTL** | Native governance/staking token. Currently inactive (stopped trading Dec 2025). |
| **ICS-721** | Cosmos interchain NFT transfer standard (ratified). Successor to interNFT concepts. |
| **RWA** | Real World Assets. Tokenized representations of off-chain assets (treasuries, real estate, credit, commodities). |

## Cross-Reference Guide

| If editing... | Read first... |
|---------------|---------------|
| Revival strategy | `strategy/revival_analysis.md` |
| RWA module mapping | `strategy/rwa_pivot.md` |
| Token options | `strategy/token_strategy.md` |
| SDK upgrade path | `technical/modernization_roadmap.md` |
| Module capabilities | `technical/module_audit.md` + `reference/transaction_reference.md` |
| Identity/KYC design | `technical/identity_compliance.md` |
| P2P integration | `synergies/p2p_identity_bridge.md` |
| Execution progress | `execution/checklist.md` |

## Execution Rules

1. Work through `execution/checklist.md` sequentially. Update status as you go.
2. For each checklist item, read the corresponding phase doc (e.g., `execution/phase1_triage.md`).
3. Write findings back to the appropriate `strategy/` or `technical/` doc.
4. When working on forked AssetMantle repos: create PRs, never push directly to main.
5. Pause for human review at phase boundaries (end of each phase).

## Authoring Conventions

- Markdown with relative links to other repo files.
- Never paste API keys, private keys, or credentials. Use placeholders.
- Cite sources: link to upstream repos, specific files, commit hashes.
- No emojis. Plain text. Let the analysis carry the document.
