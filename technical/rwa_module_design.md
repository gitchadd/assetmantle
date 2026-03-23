# RWA Module Design: New Capabilities

## Overview

This document specifies the new capabilities required on top of the existing 7 modules to support RWA tokenization. These are implemented as either module extensions (Go) or CosmWasm contracts.

## 1. Compliance Layer

**Implementation**: CosmWasm contract (configurable per asset classification)

**Purpose**: Pre-transfer checks called by Assets module `send` transaction.

### Interface

```
CheckTransfer {
  asset_id: AssetID,
  sender: Address,
  receiver: Address,
  amount: Uint128,
} -> Result<Allowed | Denied { reason: String }>
```

### Checks Performed (configurable per classification)

1. **Sender identity valid**: Not quashed/revoked, not expired
2. **Receiver identity valid**: Same checks
3. **Receiver tier sufficient**: Identity tier >= asset classification required tier
4. **Jurisdiction match**: Receiver jurisdiction in asset's allowed jurisdictions list
5. **Lockup check**: Sender has held asset for minimum required period
6. **Max holders**: Adding new holder won't exceed asset's max holder limit
7. **Sanctions**: Neither party on active sanctions list
8. **Amount limits**: Transfer doesn't exceed per-transaction or per-period limits

### Configuration (per classification)

```json
{
  "classification_id": "US_TREASURY",
  "min_identity_tier": 1,
  "allowed_jurisdictions": ["US", "EU", "SG", "AE", "CH"],
  "lockup_days": 0,
  "max_holders": 0,
  "sanctions_check": true,
  "max_transfer_per_tx": "0",
  "max_transfer_per_day": "0"
}
```

Zero values mean no limit.

## 2. Distribution Engine

**Implementation**: CosmWasm contract

**Purpose**: Automated distribution of yield/dividends/rent to fractional holders via Splits module.

### Interface

```
CreateDistribution {
  asset_id: AssetID,
  distribution_type: "dividend" | "yield" | "rent" | "coupon",
  total_amount: Uint128,
  denomination: String,
  record_date: Timestamp,
  payment_date: Timestamp,
}

ExecuteDistribution {
  distribution_id: DistributionID,
}

QueryDistributionHistory {
  asset_id: AssetID,
  start_date: Timestamp,
  end_date: Timestamp,
}
```

### Flow

1. Maintainer (asset servicer) creates distribution with total amount and dates
2. At record date, contract snapshots all holders from Splits module
3. At payment date, contract distributes pro-rata to all holders
4. Distribution record stored in Metas module for audit trail
5. Supports multiple denomination tokens (USDC via IBC, native token, etc.)

### Waterfall Distributions (Structured Products)

For tranched products (senior/junior debt):

```
CreateWaterfallDistribution {
  asset_id: AssetID,
  total_amount: Uint128,
  tranches: [
    { classification_id: "SENIOR_TRANCHE", priority: 1, target_yield: "0.05" },
    { classification_id: "JUNIOR_TRANCHE", priority: 2, target_yield: "0.12" },
    { classification_id: "EQUITY_TRANCHE", priority: 3, target_yield: "0" },
  ]
}
```

Senior gets paid first up to target yield, then junior, then equity gets remainder.

## 3. Oracle Adapter

**Implementation**: CosmWasm contract + CometBFT vote extensions (Phase B)

**Purpose**: Aggregate price feeds for asset valuations (NAV).

### Interface

```
SubmitPrice {
  asset_id: AssetID,
  price: Decimal,
  source: String,
  timestamp: Timestamp,
}

QueryPrice {
  asset_id: AssetID,
} -> { price: Decimal, sources: Vec<String>, last_updated: Timestamp }

QueryNAV {
  asset_id: AssetID,
} -> { nav_per_unit: Decimal, total_nav: Decimal, last_updated: Timestamp }
```

### Sources

- **Treasury tokens**: Fed funds rate, T-bill yields (via API oracle)
- **Real estate**: Appraisal values submitted by maintainer (auditor role)
- **Commodities**: Spot prices from LBMA (gold), CME (others)
- **Private credit**: Par value + accrued interest (calculated on-chain)

### Aggregation

- Multiple oracle sources per asset
- Median price with outlier rejection
- Staleness check (reject prices older than configurable threshold)
- Vote extensions (CometBFT v0.38): validators include price attestations in blocks

## 4. Legal Wrapper Registry

**Implementation**: Extension to Metas module (Go)

**Purpose**: On-chain registry linking tokenized assets to their legal structures.

### Data Model

```
LegalWrapper {
  asset_id: AssetID,
  entity_type: "SPV" | "Trust" | "LLC" | "Fund",
  entity_name: String,
  jurisdiction: String,
  registration_number: String,
  custodian_id: IdentityID,
  governing_docs_hash: Hash,
  governing_docs_uri: String,
  created_at: Timestamp,
  last_verified: Timestamp,
  verified_by: IdentityID,
}
```

### Rules

- Every RWA asset must have a legal wrapper before minting
- Legal wrapper can only be created by a Tier 4 identity (qualified custodian)
- Wrapper must be re-verified periodically (configurable, e.g., annually)
- Changes to legal wrapper require governance proposal or multi-sig from designated maintainers

## 5. Custodian Bridge

**Implementation**: CosmWasm contract + off-chain relayer

**Purpose**: Interface between on-chain tokens and off-chain asset custodians.

### On-Chain Interface

```
SubmitAttestation {
  asset_id: AssetID,
  attestation_type: "custody_confirmed" | "value_confirmed" | "audit_completed",
  details: String,
  evidence_hash: Hash,
  evidence_uri: String,
}

RequestMint {
  asset_id: AssetID,
  amount: Uint128,
  custodian_reference: String,
}

RequestBurn {
  asset_id: AssetID,
  amount: Uint128,
  redemption_details: String,
}
```

### Flow (Mint)

1. Issuer deposits real-world asset with custodian (off-chain)
2. Custodian confirms receipt, submits `SubmitAttestation` with custody_confirmed
3. Issuer submits `RequestMint` referencing the attestation
4. Contract verifies attestation is valid and recent
5. Assets module `mint` is called (requires governance or multi-sig approval for large amounts)

### Flow (Burn/Redeem)

1. Holder submits `RequestBurn` with redemption details
2. Contract locks the tokens
3. Custodian verifies request, releases underlying asset (off-chain)
4. Custodian submits `SubmitAttestation` confirming release
5. Contract calls Assets module `burn`

### Supported Custodians (Target)

- Self-custody (for crypto-native RWA like treasury tokens)
- Securitize (digital securities custodian)
- Fireblocks (institutional custody)
- Anchorage Digital (qualified custodian)
- BitGo (institutional custody)
