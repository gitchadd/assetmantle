# P2P Protocol Identity Bridge

## Overview

P2P Protocol (p2p.me) has a working ZK-KYC system using zkTLS social verification. AssetMantle's Identity module has a complete identity lifecycle with `deputize` for delegating verification. Bridging these creates a path where P2P.me's verified users can instantly access RWA tokens on AssetMantle.

## P2P Verification Criteria (Current)

P2P Protocol verifies users through social proof criteria:

| Platform | Criteria |
|----------|----------|
| LinkedIn | 250+ connections, 1+ education, 1+ experience |
| Instagram | 200+ followers, account created pre-2023 |
| Facebook | 250+ friends |
| GitHub | 50+ contributions, 1+ follower |
| X (Twitter) | 100+ followers |

Verification is done via zkTLS — the user proves they meet criteria without revealing account details. This produces a ZK attestation.

P2P also uses SEON for fraud detection (device fingerprinting, IP risk, email/phone risk scoring).

## Bridge Design

### Step 1: Deputize P2P Protocol on AssetMantle

```
deputize(
  provider: p2p_protocol_identity,
  tier_authority: 1,          // P2P can issue up to Tier 1
  jurisdictions: ["IN", "BR", "ID", "NG", ...],  // Markets where P2P operates
  expiry: 2027-01-01
)
```

P2P Protocol is authorized to issue Tier 1 identities on AssetMantle for users in jurisdictions where P2P has operational presence.

### Step 2: Identity Issuance Flow

```
User                  P2P Protocol              AssetMantle
  │                       │                         │
  ├──verify via zkTLS────>│                         │
  │                       │                         │
  │<──ZK attestation──────│                         │
  │                       │                         │
  │                       ├──issue_identity(────────>│
  │                       │   address: user_cosmos,  │
  │                       │   tier: 1,               │
  │                       │   jurisdiction: "IN",    │
  │                       │   attestation: zk_proof, │
  │                       │   seon_score: 85         │
  │                       │ )                        │
  │                       │                         │
  │                       │<──identity_issued────────│
  │                       │                         │
  │<──identity confirmed──│                         │
```

### Step 3: User Transacts on AssetMantle

With Tier 1 identity, user can:
- View all RWA assets
- Purchase non-security tokens (commodity-backed, utility tokens)
- Trade on secondary market for Tier 1 assets
- Receive distributions

Cannot (needs Tier 2+):
- Purchase security tokens (tokenized equities, debt)
- Access US Reg D offerings
- Serve as maintainer/custodian

### Upgrade Path to Tier 2

For users wanting access to security tokens:
1. Start with P2P Tier 1 verification (instant, free)
2. P2P identity serves as "pre-verification" — reduces friction for Tier 2 KYC
3. User completes additional verification through Sumsub/Onfido (document verification)
4. Tier upgraded to 2 on AssetMantle
5. Full RWA access unlocked

## Technical Implementation

### On P2P Side
- New API endpoint: `POST /api/v1/assetmantle/attestation`
- Returns signed attestation compatible with AssetMantle Identity module
- Includes: address, verification result, jurisdiction, SEON score, timestamp
- Signed with P2P Protocol's deputized key

### On AssetMantle Side
- Custom `issue` handler that accepts P2P attestation format
- Validates P2P signature against deputized identity
- Checks attestation freshness (< 24 hours)
- Issues Tier 1 identity with P2P as verification source

### IBC Relay Option
If P2P Protocol runs on a different chain:
- Attestation relayed via IBC packet
- MantleChain IBC handler processes attestation
- Identity issued automatically on receipt
- Trustless: no centralized relay needed

## Value Exchange

| P2P Protocol Gets | AssetMantle Gets |
|-------------------|-----------------|
| Expanded use case for verification system | Instant access to P2P's user base |
| Revenue share on RWA transactions from P2P-verified users | Fiat on-ramp for RWA purchases (UPI, PIX, QRIS) |
| Cross-chain identity standard contribution | Reduced KYC cost for Tier 1 users |
| RWA access for P2P.me users (retention) | Market presence in India, Brazil, Indonesia |
