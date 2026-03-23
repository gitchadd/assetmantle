# AssetMantle RWA Revival

Strategy and execution repo for reviving the [AssetMantle](https://github.com/AssetMantle) protocol with a pivot to **Real World Asset (RWA) tokenization**.

## Why AssetMantle

AssetMantle is a Cosmos SDK appchain with 45 repos and 4,626+ commits across 7 well-engineered Go modules. The protocol was built for interchain NFTs but the NFT market collapsed and the project went dormant. The token ($MNTL) stopped trading in late 2025.

What makes it worth reviving: the modular architecture maps directly to RWA needs.

| Module | RWA Application |
|--------|----------------|
| **Assets** | Tokenize real-world assets (wrap/unwrap pattern) |
| **Identities** | KYC/AML for accredited investors |
| **Classifications** | Asset taxonomy (equity, debt, real estate, commodity) |
| **Splits** | Fractional ownership with distribution schedules |
| **Orders** | Secondary market with transfer restrictions |
| **Maintainers** | Custodians, auditors, oracles |
| **Metas** | Legal documents, valuations, audit trails |

The chain runs on SDK v0.47.14 with CometBFT v0.37.5. One major version behind current. Upgradeable.

## Repo Structure

```
strategy/       — Revival analysis, RWA pivot plan, token strategy, regulatory, competitive landscape
technical/      — SDK modernization, module audit, RWA module design, compliance, CosmWasm, IBC
execution/      — Phased checklist, agent playbook, week-by-week plans
synergies/      — P2P Protocol identity bridge, fiat on-ramp, shared compliance
reference/      — Module inventory, transaction reference, dependency map
```

## Target RWA Verticals

1. **Tokenized US Treasuries** — highest demand, lowest regulatory friction
2. **Real estate fractionalization** — natural Splits module fit
3. **Private credit** — Orders module for origination + secondary
4. **Commodity-backed tokens** — Assets wrap/unwrap pattern

## Execution

This repo serves as the command center for an automated agent setup (local LLM + Claude Opus 4.6 API) that will execute the revival across forked AssetMantle repos. See [execution/checklist.md](execution/checklist.md) and [execution/agent_playbook.md](execution/agent_playbook.md).

## Key Repos (upstream)

- [AssetMantle/node](https://github.com/AssetMantle/node) — Core blockchain node (Go, SDK v0.47.14)
- [AssetMantle/modules](https://github.com/AssetMantle/modules) — 7 protocol modules (Go, 4,626 commits)
- [AssetMantle/schema](https://github.com/AssetMantle/schema) — Type system
