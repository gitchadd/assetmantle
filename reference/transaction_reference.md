# Transaction Reference

All known transaction types across AssetMantle's 7 modules.

> **Status**: Based on GitHub analysis. Needs source code verification (checklist item 1.6).

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

## Summary

| Module | Transaction Count |
|--------|------------------|
| Assets | 11 |
| Identities | 10 |
| Orders | 11 |
| Classifications | 3 |
| Maintainers | 2 |
| Splits | 1 |
| Metas | 2 |
| **Total** | **40** |

## Notes

- Every module has a `govern` transaction for governance-level operations
- `deputize` is common across 5 modules (assets, identities, classifications, orders, maintainers)
- Assets and Orders have the richest transaction sets — these are the most complex modules
- Splits module has only 1 transaction — needs significant extension for RWA (distributions, cap table)
