# P2P Protocol RWA Fiat On-Ramp

## Overview

P2P Protocol settles stablecoin on/off-ramps via UPI (India), PIX (Brazil), and QRIS (Indonesia) in under 90 seconds. RWA tokens need fiat on-ramps for purchase. P2P rails can serve this function, creating a complete flow from fiat to fractional RWA ownership.

## User Flow

```
1. User verifies on P2P.me (zkTLS social proof)
   ↓
2. User buys USDC via P2P.me using UPI/PIX/QRIS
   ↓ (settled in <90 seconds)
3. USDC arrives in user's wallet on Base/Solana
   ↓
4. USDC bridged to MantleChain via IBC (through Noble)
   ↓ (IBC relay, ~30 seconds)
5. User purchases fractional RWA token on MantleChain
   ↓ (compliance check + order execution)
6. User holds fractional RWA token
   ↓
7. Distributions (yield/rent/dividends) paid in USDC on MantleChain
   ↓
8. User off-ramps USDC to fiat via P2P.me
```

## Why This Matters

### For Users
- Buy tokenized US treasuries with Indian rupees in under 5 minutes
- No SWIFT transfers, no bank intermediaries, no minimum investment
- Earn T-bill yield (4-5% as of 2025) from a phone in Mumbai
- Off-ramp back to INR whenever needed

### For P2P Protocol
- New revenue stream: every RWA purchase generates on-ramp volume
- Every distribution off-ramp generates more volume
- Recurring revenue: RWA holders off-ramp yield regularly
- Stickier user base (users come back for yield)

### For AssetMantle
- Fiat accessibility in 3 of the largest emerging markets (India, Brazil, Indonesia)
- No need to build fiat infrastructure — P2P already has it
- USDC settlement via Noble is a clean integration path

## Technical Integration

### USDC Path: P2P to MantleChain

```
P2P.me (Base) ──USDC──> Noble (ICS-20) ──USDC──> MantleChain
```

1. User buys USDC on P2P.me (settled on Base)
2. USDC bridged from Base to Noble via CCTP (Circle's Cross-Chain Transfer Protocol)
3. Native USDC on Noble transferred to MantleChain via IBC (ICS-20)
4. USDC arrives in user's MantleChain address

This is the canonical path for USDC in Cosmos. Noble is the official USDC issuer on Cosmos.

### RWA Purchase

1. User has USDC on MantleChain
2. User places order on an RWA token (via Orders module)
3. Compliance checker verifies user identity (Tier 1+ from P2P verification)
4. Order matches and executes
5. User receives fractional RWA token in their wallet

### Distribution Off-Ramp

1. Distribution engine pays yield in USDC to all holders
2. User IBC-transfers USDC from MantleChain to Noble
3. CCTP bridge from Noble to Base
4. User sells USDC on P2P.me for fiat (UPI/PIX/QRIS)

## Revenue Model

| Transaction | P2P Revenue | AssetMantle Revenue |
|-------------|------------|-------------------|
| Fiat to USDC (on-ramp) | P2P spread (~1-2%) | None |
| USDC to RWA (purchase) | None | Trading fee (0.1-0.5%) |
| RWA yield distribution | None | Management fee (10-30bps on AUM) |
| USDC to fiat (off-ramp) | P2P spread (~1-2%) | None |

Both protocols earn on complementary steps. No competition.

## Markets and Regulatory Fit

| Market | Fiat Rail | RWA Opportunity |
|--------|-----------|----------------|
| India (UPI) | 500M+ UPI users, instant settlement | Massive demand for USD-denominated yield (rupee depreciation hedge) |
| Brazil (PIX) | 150M+ PIX users, instant settlement | Growing crypto adoption, RWA interest (Bacen sandbox) |
| Indonesia (QRIS) | 40M+ QRIS users | Emerging market with OJK digital asset framework |

## Implementation Requirements

### P2P Side
- CCTP integration for Base to Noble USDC bridge (if not already supported)
- MantleChain address generation/management for users
- IBC relay for USDC transfers to/from MantleChain
- RWA portfolio view in P2P.me app (optional, value-add)

### AssetMantle Side
- Noble IBC channel established and tested
- USDC accepted as denomination for Orders module
- Distribution engine configured to pay in USDC
- P2P Protocol identity bridge operational (see [p2p_identity_bridge.md](p2p_identity_bridge.md))

### Joint
- Shared documentation for end-to-end flow
- Shared monitoring for cross-chain transfers
- Joint marketing for launch markets
