# Competitive Landscape: RWA Tokenization

## Major Players

### Ondo Finance
- **Focus**: Tokenized US Treasuries and money market funds
- **AUM**: $2B+ (as of early 2025)
- **Chain**: Ethereum mainnet, expanding to Solana and own L1 (Ondo Chain)
- **Products**: OUSG (US treasuries), USDY (yield-bearing stablecoin)
- **Moat**: First mover in tokenized treasuries, institutional partnerships (BlackRock via BUIDL)
- **Gap we can fill**: Not interchain. Single-chain products. No fractional ownership infrastructure.

### Securitize
- **Focus**: Full-stack RWA issuance platform
- **Products**: Digital securities issuance, compliance, transfer agent services
- **Chain**: Ethereum, Avalanche, Polygon
- **Moat**: SEC-registered transfer agent, licensed broker-dealer
- **Gap**: Centralized platform. Not a protocol. No interchain capability.

### Centrifuge
- **Focus**: Tokenized private credit
- **AUM**: $250M+ (as of 2024)
- **Chain**: Own Substrate chain + Ethereum integration
- **Products**: Tinlake (lending pools), Centrifuge Chain
- **Moat**: Real DeFi integration (MakerDAO, Aave vaults)
- **Gap**: Substrate not Cosmos. Limited interchain. Complex UX.

### Backed Finance
- **Focus**: Tokenized ETFs and securities (EU-regulated)
- **Chain**: Ethereum, Gnosis, Base
- **Products**: bIB01 (treasury ETF), bCSPX (S&P 500)
- **Moat**: Swiss-regulated, FINMA compliant
- **Gap**: EU-only initially. Not interchain.

### RealT
- **Focus**: Tokenized real estate (US residential)
- **Chain**: Ethereum, Gnosis
- **Products**: Fractional property tokens with rental income
- **Moat**: Operating since 2019, proven model
- **Gap**: US-only. Small scale. Not interchain.

### Maple Finance
- **Focus**: Institutional lending / private credit
- **Chain**: Ethereum, Solana, Base
- **Products**: Lending pools for institutional borrowers
- **Moat**: Established protocol, institutional borrower relationships
- **Gap**: Not multi-chain native. No fractional ownership.

## AssetMantle Differentiation

### 1. Purpose-Built Cosmos Appchain
No major RWA protocol runs as a Cosmos appchain. This gives:
- Sovereign governance (not subject to Ethereum gas/MEV dynamics)
- IBC interoperability to 50+ Cosmos chains
- Customizable block space (prioritize RWA transactions)
- Cosmos SDK module system (compliance at the protocol level, not smart contract level)

### 2. Native Interchain RWA
IBC + ICS-721 enables RWA tokens to move between chains without bridges. No competitor has this.
- Treasury token minted on MantleChain can be used as collateral on Osmosis
- Real estate token on MantleChain can be traded on any IBC-connected DEX
- Cross-chain compliance: identity verification travels with the asset

### 3. Modular Compliance Architecture
Compliance is built into the module layer, not bolted on via smart contracts:
- Identities module = native KYC
- Classifications module = native asset taxonomy with compliance rules
- Maintainers module = native custodian/auditor roles
- This is structurally different from EVM protocols that wrap compliance in proxy contracts

### 4. Fractional Ownership as a Primitive
Splits module provides fractional ownership at the protocol level:
- Not a smart contract feature, a chain-level primitive
- Distribution engine for yields/dividends built in
- Cap table is on-chain, not in a database

## Positioning

**"The interchain RWA protocol."**

Compete on:
- Cross-chain portability (IBC) — no one else has this
- Protocol-level compliance (not smart contract band-aids)
- Native fractional ownership with distributions
- Cosmos ecosystem integration (Osmosis, Noble, Stride, Neutron)

Do not compete on:
- AUM at launch (Ondo has years of head start)
- Regulatory licenses (Securitize has transfer agent + BD)
- Ethereum DeFi composability (not our chain)
