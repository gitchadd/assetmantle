# Transaction Reference

All known transaction types across AssetMantle's 7 modules.

> **Status**: Verified against source code (2026-03-23). Checked `x/*/transactions/` dirs.
> **Correction**: Classifications and Maintainers have fewer external transactions than originally estimated. Their core logic lives in auxiliaries (internal module-to-module calls). See auxiliaries section below.

## Assets Module

| Transaction | Description |
|-------------|-------------|
| `assets/define` | Create asset type definition with properties |
| `assets/mint` | Create new asset instance |
| `assets/burn` | Destroy asset |
| `assets/send` | Transfer asset ownership |
| `assets/mutate` | Update mutable asset properties |
| `assets/wrap` | Wrap external asset into interNFT format |
| `assets/unwrap` | Unwrap interNFT to external format |
| `assets/deputize` | Delegate asset operations to another identity |
| `assets/govern` | Governance-level asset operations |
| `assets/renumerate` | Update asset indexing |
| `assets/revoke` | Revoke asset access/permissions |

## Identities Module

| Transaction | Description |
|-------------|-------------|
| `identities/define` | Create identity schema/classification |
| `identities/issue` | Issue identity to address |
| `identities/quash` | Temporarily suspend identity |
| `identities/revoke` | Permanently revoke identity |
| `identities/deputize` | Delegate identity operations |
| `identities/govern` | Governance-level identity operations |
| `identities/name` | Assign human-readable name to identity |
| `identities/provision` | Grant access to specific resources |
| `identities/unprovision` | Revoke resource access |
| `identities/update` | Update identity properties |

## Classifications Module

| Transaction | Description |
|-------------|-------------|
| `classifications/define` | Create classification schema |
| `classifications/deputize` | Delegate classification operations |
| `classifications/govern` | Governance-level classification operations |

## Splits Module

| Transaction | Description |
|-------------|-------------|
| `splits/govern` | Governance-level split operations |

## Orders Module

| Transaction | Description |
|-------------|-------------|
| `orders/make` | Create new order |
| `orders/take` | Fill existing order |
| `orders/get` | Retrieve order (buy side) |
| `orders/put` | Place order (sell side) |
| `orders/cancel` | Cancel order |
| `orders/modify` | Modify order parameters |
| `orders/define` | Define order type |
| `orders/deputize` | Delegate order operations |
| `orders/govern` | Governance-level order operations |
| `orders/immediate` | Instant execution order |
| `orders/revoke` | Revoke order capabilities |

## Maintainers Module

| Transaction | Description |
|-------------|-------------|
| `maintainers/deputize` | Delegate maintainer rights |
| `maintainers/govern` | Governance-level maintainer operations |

## Metas Module

| Transaction | Description |
|-------------|-------------|
| `metas/reveal` | Reveal/store metadata |
| `metas/govern` | Governance-level meta operations |

## Auxiliaries (Internal Module-to-Module Calls)

Verified from source: `x/*/auxiliaries/` directories.

### Classifications Auxiliaries
| Auxiliary | Description |
|-----------|-------------|
| `bond` | Bond tokens to classification |
| `burn` | Burn classification tokens |
| `conform` | Check conformance to classification schema |
| `define` | Define new classification (called internally, not direct tx) |
| `member` | Check membership in classification |
| `unbond` | Unbond tokens from classification |

### Maintainers Auxiliaries
| Auxiliary | Description |
|-----------|-------------|
| `authorize` | Check authorization for operation |
| `deputize` | Delegate maintainer rights (called internally) |
| `maintain` | Perform maintenance operation |
| `revoke` | Revoke maintainer rights |
| `super` | Super-admin operations |

### Splits Auxiliaries
| Auxiliary | Description |
|-----------|-------------|
| `burn` | Burn split tokens |
| `mint` | Mint split tokens |
| `purge` | Purge zero-balance splits |
| `renumerate` | Renumerate split indices |
| `transfer` | Transfer split ownership |

## Summary

| Module | Transactions | Auxiliaries | Total |
|--------|-------------|-------------|-------|
| Assets | 11 | — | 11 |
| Identities | 10 | — | 10 |
| Orders | 11 | — | 11 |
| Classifications | 1 (govern) | 6 | 7 |
| Maintainers | 1 (govern) | 5 | 6 |
| Splits | 1 (govern) | 5 | 6 |
| Metas | 2 | — | 2 |
| **Total** | **37** | **16** | **53** |

## Notes

- Every module has a `govern` transaction for governance-level operations
- `deputize` exists as a transaction in assets, identities, orders — and as an auxiliary in maintainers
- Assets and Orders have the richest external transaction sets
- Classifications, Maintainers, and Splits operate primarily through auxiliaries — their logic is invoked by other modules, not directly by users
- Splits auxiliaries (mint, burn, transfer) are the actual fractional ownership primitives — they're called by Assets module during mint/burn/send operations
- **IBM/sarama Kafka dependency** in modules suggests event streaming was planned. Could be useful for RWA event publishing (compliance events, distributions, price updates)
