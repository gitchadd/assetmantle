# Identity Module to KYC/AML Extension

## Design Overview

AssetMantle's Identity module already implements a complete identity lifecycle. This document maps each existing transaction to its KYC/AML equivalent and specifies the extensions needed for RWA compliance.

## Transaction Mapping

### `define` — Create Identity Schema per Jurisdiction

**Current behavior**: Creates a new identity classification with defined properties.

**RWA extension**: Each jurisdiction gets its own identity schema defining required verification fields.

```
US Accredited Identity Schema:
  - full_name: string (encrypted/ZK)
  - accreditation_type: enum [income, net_worth, professional, entity]
  - accreditation_verified_by: identity_id (reference to KYC provider)
  - accreditation_date: timestamp
  - accreditation_expiry: timestamp (typically 90 days)
  - jurisdiction: "US"
  - sanctions_cleared: bool
  - sanctions_check_date: timestamp

EU MiCA Identity Schema:
  - full_name: string (encrypted/ZK)
  - investor_class: enum [retail, professional, eligible_counterparty]
  - aml_verified: bool
  - jurisdiction: ISO-3166 country code
  - casp_provider: identity_id
```

### `issue` — Onboard Verified Investor

**Current behavior**: Issues an identity to a blockchain address.

**RWA extension**:
1. KYC provider (deputized identity) submits verification attestation
2. System checks: all required schema fields populated, sanctions cleared, accreditation valid
3. Identity issued with tier assignment:
   - Tier 0: Anonymous (view only)
   - Tier 1: Basic KYC (non-security tokens only)
   - Tier 2: Accredited/Professional (security tokens, private placements)
   - Tier 3: Institutional (all assets, higher limits)
   - Tier 4: Qualified Custodian (can serve as maintainer)
4. Investor can now transact on assets matching their tier + jurisdiction

### `quash` — Suspend for Compliance Review

**Current behavior**: Temporarily disables an identity.

**RWA extension**:
- Triggered by: suspicious activity detection, sanctions list update, accreditation expiry
- Effect: all pending orders cancelled, no new transactions, existing holdings frozen
- Automatic quash on accreditation expiry (configurable grace period)
- Quashed identity can be reinstated via `update` after review

### `revoke` — Permanent Ban

**Current behavior**: Permanently revokes an identity.

**RWA extension**:
- Triggered by: confirmed fraud, sanctions match, regulatory order
- Effect: identity permanently disabled, all holdings must be liquidated or transferred to compliant address within N days
- Generates compliance event record in Metas module
- Cannot be reversed without governance proposal

### `deputize` — Delegate Verification to KYC Provider

**Current behavior**: Grants another identity the right to perform operations on behalf of the identity owner.

**RWA extension**: This is the key integration point for third-party KYC.

**Deputized KYC providers**:
1. **P2P Protocol** — ZK-verified social identity (LinkedIn, IG, FB, GitHub, X via zkTLS). Best for Tier 1 (basic KYC) and potentially Tier 2 with additional checks.
2. **Sumsub/Onfido** — Traditional KYC with document verification. Required for Tier 2+ in most jurisdictions.
3. **Verify Investor/Parallel Markets** — US accredited investor verification. Required for Reg D 506c.
4. **Chainalysis/Elliptic** — Sanctions and AML screening. Required for all tiers.

Deputize transaction includes:
- `provider_id`: identity of the KYC provider
- `tier_authority`: maximum tier the provider can issue (e.g., P2P can issue up to Tier 1, Sumsub up to Tier 3)
- `jurisdiction_authority`: jurisdictions the provider can verify for
- `expiry`: when the deputization expires

### `govern` — Regulatory Authority Override

**Current behavior**: Governance-level identity operations.

**RWA extension**:
- Force-quash identity (regulatory order)
- Force-revoke identity (sanctions enforcement)
- Override tier assignment (regulatory audit)
- Freeze all identities of a specific jurisdiction (emergency compliance)
- Must be executed by governance proposal or designated regulatory maintainer

### `provision` / `unprovision` — Grant/Revoke Access to RWA Classes

**Current behavior**: Grants or revokes access to specific resources.

**RWA extension**:
- Provision maps to: "this identity can transact in this asset classification"
- Example: provision(identity_123, "US_TREASURY") — investor can buy/sell tokenized treasuries
- Unprovision: remove access to a specific asset class (e.g., investor no longer qualifies)
- Provision checks: identity tier >= classification required tier, jurisdiction match

### `update` — Refresh Verification

**Current behavior**: Updates identity properties.

**RWA extension**:
- Update accreditation status (re-verification)
- Update jurisdiction (investor relocated)
- Update sanctions clearance (periodic re-screening)
- Can reinstate a quashed identity after compliance review
- Must be executed by a deputized KYC provider with appropriate authority

## Integration with P2P Protocol ZK-KYC

### Bridge Architecture

```
P2P Protocol                          AssetMantle
┌──────────────┐                      ┌──────────────────┐
│ zkTLS verify │                      │ Identities Module │
│ (social      │──attestation-msg──>  │                  │
│  proof)      │                      │ deputize(P2P,    │
│              │                      │   tier_1,        │
│ SEON fraud   │                      │   [IN,BR,ID])    │
│ detection    │                      │                  │
└──────────────┘                      │ issue(user,      │
                                      │   tier_1,        │
                                      │   schema_basic)  │
                                      └──────────────────┘
```

### Flow

1. User verifies on P2P.me using zkTLS social proof (LinkedIn 250+ connections, etc.)
2. P2P Protocol issues ZK attestation: "this address is verified, meets criteria X"
3. Attestation relayed to MantleChain via IBC or direct submission
4. AssetMantle Identities module: P2P is deputized for Tier 1, jurisdictions [IN, BR, ID, ...]
5. Identity issued to user at Tier 1 with P2P as verification source
6. User can now transact in Tier 1 RWA assets (non-security, low-risk)
7. For Tier 2+ (securities), user must complete additional verification through Sumsub or equivalent

### Value Proposition

- P2P.me users get instant Tier 1 access to AssetMantle RWA assets
- No duplicate KYC — verification from P2P carries over
- P2P benefits from expanded use case for their verification system
- AssetMantle benefits from P2P's existing user base and fiat rails

## Compliance Event Trail

Every identity operation generates an immutable event stored in Metas:

```
Event {
  type: "identity_issued" | "identity_quashed" | "identity_revoked" | ...
  identity_id: ID
  operator_id: ID (who performed the action)
  reason: string
  timestamp: block_time
  jurisdiction: string
  regulatory_reference: string (optional, e.g., "OFAC SDN List update 2025-03-15")
}
```

This creates an auditable compliance trail for regulators.
