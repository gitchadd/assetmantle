# Shared Compliance Infrastructure

## Overview

Both P2P Protocol and AssetMantle need compliance infrastructure. P2P has already built ZK-KYC, SEON fraud detection, and MiCA analysis. AssetMantle needs KYC, AML, accreditation verification, and transfer restrictions. Sharing infrastructure reduces cost and creates a compliance moat.

## What P2P Already Has

| Component | Description | Reusable for AssetMantle? |
|-----------|-------------|--------------------------|
| zkTLS social verification | ZK-proof of social account criteria | Yes — Tier 1 identity verification |
| SEON fraud detection | Device fingerprinting, IP risk, email/phone scoring | Yes — risk scoring for identity issuance |
| MiCA compliance analysis | Regulatory analysis for EU markets | Yes — basis for RWA regulatory strategy |
| Proof-of-Credibility | Social verification + reputation tiering | Partially — concept maps to identity tiers |
| Sanctions screening | (assumed, standard for fiat on-ramp) | Yes — required for all RWA transactions |

## What AssetMantle Needs to Build

| Component | Description | Can P2P Help? |
|-----------|-------------|--------------|
| Accreditation verification | Prove investor is accredited (US Reg D) | No — different verification, need Verify Investor / Parallel Markets |
| Transfer restrictions | On-chain enforcement of lockups, holder limits | No — chain-level feature, AssetMantle builds |
| Compliance checker | Pre-transfer compliance middleware | Partially — P2P identity data feeds into it |
| Oracle integration | Asset valuation feeds | No — different domain |
| Legal wrapper registry | SPV/trust documentation | No — different domain |

## Shared Components

### 1. Identity Verification Pipeline

```
                    ┌─────────────────┐
                    │   Shared KYC    │
                    │   Pipeline      │
                    └────┬───────┬────┘
                         │       │
              ┌──────────▼─┐  ┌──▼──────────┐
              │ P2P.me     │  │ AssetMantle  │
              │            │  │              │
              │ Tier 1:    │  │ Tier 1:      │
              │ zkTLS      │  │ zkTLS (P2P)  │
              │            │  │              │
              │ Tier 2:    │  │ Tier 2:      │
              │ N/A        │  │ Sumsub/Onfido│
              │            │  │              │
              │ Fraud:     │  │ Fraud:       │
              │ SEON       │  │ SEON (shared)│
              └────────────┘  └──────────────┘
```

Sharing the identity pipeline means:
- One SEON integration, used by both protocols
- One zkTLS verification flow, results accepted by both
- User verifies once, uses everywhere

### 2. Sanctions Screening

Both protocols need sanctions screening (OFAC SDN, EU consolidated list).

Shared approach:
- Single integration with Chainalysis or Elliptic
- Screening results cached with TTL (e.g., 24 hours)
- Results available to both P2P compliance and AssetMantle compliance checker
- Cost shared between protocols

### 3. Regulatory Intelligence

P2P's MiCA analysis (at `notes/whitepaper/mica.md`) is a starting point for AssetMantle's regulatory strategy. Shared regulatory intelligence:
- Jurisdiction-specific requirements database
- Regulatory change monitoring
- Compliance template library

## Cost Savings

| Component | Standalone Cost (each) | Shared Cost (total) | Savings |
|-----------|----------------------|--------------------|---------|
| KYC provider (Sumsub) | $0.50-2.00/verification each | Same per-verification, but reduced volume via zkTLS pre-screen | ~30% reduction in full KYC volume |
| SEON fraud detection | Monthly subscription each | One subscription | 50% |
| Sanctions screening | Per-check pricing each | Shared integration, bulk pricing | ~40% |
| Legal/regulatory counsel | Separate engagements | Joint engagement, shared research | ~30% |

## Implementation

### Phase 1: Identity Bridge (Week 1-2 of synergy work)
- Establish P2P as deputized identity provider on AssetMantle
- Shared zkTLS verification flow
- See [p2p_identity_bridge.md](p2p_identity_bridge.md)

### Phase 2: Shared SEON (Week 3-4)
- SEON risk score passed from P2P to AssetMantle identity record
- AssetMantle compliance checker considers SEON score in transfer decisions
- High-risk scores trigger additional verification requirements

### Phase 3: Shared Sanctions (Week 5-6)
- Single Chainalysis/Elliptic integration
- API accessible to both P2P compliance layer and AssetMantle compliance checker
- Automated re-screening on schedule (daily for active identities)
