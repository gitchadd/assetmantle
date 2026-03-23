# Module Audit

Detailed inventory of all 7 AssetMantle modules. Each module is scored for RWA readiness (1-5) and annotated with required changes.

> **Note**: Transaction and query lists are based on GitHub source analysis. Full verification requires running the forked repos. See [checklist item #5](../execution/checklist.md).

## 1. Assets Module

**RWA Readiness: 4/5** — Highest readiness. Wrap/unwrap is the RWA tokenization primitive.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| define | Create asset type definition | Define RWA asset class (treasury, property, etc.) |
| mint | Create new asset instance | Tokenize a real-world asset |
| burn | Destroy asset | Redeem/delist RWA token |
| send | Transfer ownership | Transfer RWA token between investors |
| mutate | Update asset properties | Update valuation, status, metadata |
| wrap | Wrap external asset into interNFT | Wrap off-chain asset into on-chain representation |
| unwrap | Unwrap interNFT to external | Redeem on-chain token for off-chain asset |
| deputize | Delegate operations to another identity | Delegate asset management to custodian/servicer |
| govern | Governance-level operations | Regulatory override, emergency freeze |
| renumerate | Update asset numbering/indexing | Re-index after splits or corporate actions |
| revoke | Revoke asset access/permissions | Compliance enforcement, sanctions |

### Required Changes for RWA
- Add compliance metadata to `define` (jurisdiction, regulatory class, accreditation tier)
- Add pre-transfer hooks to `send` (call compliance checker)
- Extend `wrap` to require custodian attestation
- Add freeze/unfreeze capability (regulatory holds)
- Add oracle price reference to asset properties

## 2. Identities Module

**RWA Readiness: 4/5** — Complete identity lifecycle. Needs KYC-specific extensions.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| define | Create identity schema | Define KYC requirements per jurisdiction |
| issue | Issue identity to address | Onboard verified investor |
| quash | Temporarily suspend identity | Compliance review, suspicious activity |
| revoke | Permanently revoke identity | Ban, sanctions match, fraud |
| deputize | Delegate identity operations | Authorize P2P Protocol or KYC provider |
| govern | Governance operations | Regulatory authority actions |
| name | Assign human-readable name | Investor alias, institution name |
| provision | Grant access to specific resources | Grant access to specific RWA classes |
| unprovision | Revoke resource access | Remove access to RWA class |
| update | Update identity properties | Update accreditation status, jurisdiction |

### Required Changes for RWA
- Add accreditation tier field (0-4, see [regulatory.md](../strategy/regulatory.md))
- Add jurisdiction field with supported jurisdictions enum
- Add ZK-proof verification support (prove accreditation without PII)
- Add expiry/renewal logic (accreditation lapses, KYC refresh)
- Add sanctions list check integration point

## 3. Classifications Module

**RWA Readiness: 3/5** — Good foundation for asset taxonomy. Needs RWA-specific hierarchy.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| define | Create classification schema | Define RWA categories (equity, debt, RE, commodity) |
| deputize | Delegate classification operations | Allow issuers to classify their assets |
| govern | Governance operations | Update classification rules |

### Required Changes for RWA
- Define RWA classification hierarchy with regulatory mapping
- Add compliance rule templates per classification (lockup, investor limits, transfer rules)
- Add sub-classifications (e.g., debt > corporate bond > investment grade)
- Add jurisdiction-specific classification variants

## 4. Splits Module

**RWA Readiness: 3/5** — Fractional ownership exists. Needs distribution and cap table logic.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| govern | Governance operations | Update split parameters |

### Required Changes for RWA
- Add minimum denomination enforcement
- Add cap table tracking (ownership percentages, history)
- Add distribution schedules (dividend, yield, rent)
- Add waterfall logic for structured products (senior/junior tranches)
- Add max holder count enforcement
- Add reporting queries (who owns what, distribution history)

## 5. Orders Module

**RWA Readiness: 3/5** — Complete order lifecycle. Needs compliance hooks.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| make | Create order | List RWA token for sale |
| take | Fill order | Purchase RWA token |
| get | Retrieve order details | View listing |
| put | Update order | Modify price/terms |
| cancel | Cancel order | Remove listing |
| modify | Modify order parameters | Adjust terms |
| define | Define order type | Create order type with compliance rules |
| deputize | Delegate order operations | Allow brokers to manage orders |
| govern | Governance operations | Market circuit breakers |
| immediate | Instant execution order | Market orders |
| revoke | Revoke order capabilities | Disable trading for compliance |

### Required Changes for RWA
- Add pre-trade compliance check (buyer identity tier, jurisdiction, lockup)
- Add settlement delay option (T+0 to T+3)
- Add price band limits for illiquid assets
- Add transfer restriction enforcement (holding periods, accreditation)
- Add order type for primary issuance vs secondary market

## 6. Maintainers Module

**RWA Readiness: 3/5** — Delegated authority pattern. Needs real-world role definitions.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| deputize | Delegate maintainer rights | Authorize custodian, auditor, appraiser |
| govern | Governance operations | Update maintainer requirements |

### Required Changes for RWA
- Define role types: custodian, appraiser, auditor, legal agent, servicer, oracle
- Add attestation workflow (maintainer signs off on asset status periodically)
- Add accountability mechanics (slashing for failed attestations, missed deadlines)
- Add multi-sig requirements for critical operations
- Add maintainer registry (queryable list of authorized maintainers per asset)

## 7. Metas Module

**RWA Readiness: 2/5** — Basic metadata storage. Needs significant extension for legal/compliance docs.

### Transactions
| Tx | Description | RWA Use |
|----|-------------|---------|
| reveal | Reveal metadata | Disclose asset information |
| govern | Governance operations | Update metadata rules |

### Required Changes for RWA
- Add document hashing with IPFS/Arweave storage references
- Add valuation records with timestamp and oracle source
- Add immutable audit trail (version history for all metadata changes)
- Add regulatory filing references (SEC EDGAR, MiCA disclosures)
- Add structured document types (prospectus, offering memo, appraisal, audit report)

## Module Interaction Map

```
Classifications ──defines──> Assets ──fractionalized-by──> Splits
       │                        │                            │
       │                        │                            │
       └──compliance-rules──> Orders <──distributes──────────┘
                                │
                                │
Identities ──verifies-buyer──> Orders
                                │
Maintainers ──attests-to──> Assets
                                │
Metas ──documents──────────> Assets
```

## Priority Order for RWA Migration

1. **Identities** — Must work first. Nothing else functions without KYC.
2. **Assets** — Core tokenization. Depends on Identities for compliance.
3. **Classifications** — Asset taxonomy. Required before minting first RWA.
4. **Orders** — Secondary market. Depends on Identities + Assets.
5. **Splits** — Fractional ownership. Depends on Assets.
6. **Maintainers** — Custodian roles. Depends on Assets + Identities.
7. **Metas** — Documentation layer. Can be enhanced incrementally.
