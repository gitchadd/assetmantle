# RWA Tokenization Pivot Plan

## Thesis

AssetMantle's 7-module architecture was designed for generic digital asset management. Each module maps to a specific RWA function with minimal conceptual rework. The SDK is one major version behind, not generations. The interNFT standard thinking gives a head start on cross-chain RWA portability. Combined with CosmWasm for programmable compliance and IBC for interoperability, this can become a purpose-built RWA chain in the Cosmos ecosystem.

## Module-to-RWA Mapping

### Assets Module
**Current**: Define, mint, burn, send, mutate, wrap/unwrap, deputize, govern, renumerate, revoke
**RWA function**: Tokenized real-world assets
**Changes needed**:
- Add compliance metadata fields to asset definitions (jurisdiction, regulatory class, accreditation requirements)
- Add oracle price feed references for NAV tracking
- Add legal wrapper references (SPV/trust entity IDs linking on-chain asset to legal structure)
- Extend wrap/unwrap to include custodian attestation (asset is held, verified, audited)
- Add transfer hooks for compliance checks pre-send

### Identities Module
**Current**: Define, issue, quash, revoke, deputize, govern, name, provision/unprovision, update
**RWA function**: KYC/AML for accredited investors
**Changes needed**:
- Add ZK-proof verification fields (prove accreditation without revealing PII)
- Add accreditation tier system (retail, qualified, accredited, institutional)
- Add jurisdiction flags (US, EU/MiCA, SG/MAS, etc.)
- Extend deputize for delegating verification to third-party KYC providers
- Add expiry/renewal logic for identity credentials

### Classifications Module
**Current**: Asset type schema definitions
**RWA function**: Asset taxonomy
**Changes needed**:
- Define RWA classification hierarchy: equity, debt, real estate, commodity, treasury, fund
- Map each classification to regulatory category (security, utility, exempt)
- Add compliance rule templates per classification (lockup periods, investor limits, transfer restrictions)

### Splits Module
**Current**: Fractional ownership primitives, govern
**RWA function**: Fractional ownership with distributions
**Changes needed**:
- Add minimum denomination rules (e.g., minimum $100 per fraction)
- Add cap table tracking (who owns what percentage, history)
- Add distribution schedules (quarterly dividends, monthly rent, yield accrual)
- Add waterfall distribution logic (senior/junior tranches for structured products)

### Orders Module
**Current**: Make, take, get, put, cancel, modify, define, deputize, govern, immediate, revoke
**RWA function**: Secondary market trading with compliance
**Changes needed**:
- Add pre-trade compliance checks (is buyer accredited? is asset in lockup? jurisdiction match?)
- Add transfer restriction enforcement (holding periods, max holder counts, qualified buyer only)
- Add price band limits for illiquid assets (prevent manipulation)
- Add settlement delay option (T+1, T+2 for regulatory alignment)

### Maintainers Module
**Current**: Delegated authority over asset operations
**RWA function**: Real-world asset servicers
**Changes needed**:
- Extend roles: custodian (holds physical asset), appraiser (valuates), auditor (verifies), legal agent (manages SPV)
- Add attestation workflow (maintainer attests to asset status on schedule)
- Add slashing/accountability for maintainers who fail duties
- Add multi-sig requirements for critical operations (large transfers, minting new units)

### Metas Module
**Current**: On-chain metadata storage
**RWA function**: Legal documents, valuations, audit trails
**Changes needed**:
- Add document hashing with IPFS/Arweave references
- Add valuation timestamps with oracle source attribution
- Add immutable audit trail (all changes to asset metadata are versioned)
- Add regulatory filing references (SEC EDGAR links, MiCA disclosures)

## New Capabilities Required

### 1. Compliance Layer
Pre-transfer middleware that checks:
- Buyer identity verified and not expired
- Buyer accreditation tier meets asset requirements
- Asset not in lockup period
- Jurisdiction restrictions satisfied
- Max holder count not exceeded
- AML/sanctions screening passed

Implementation: CosmWasm contract called as a hook from Assets module send transaction. Configurable per asset classification.

### 2. Oracle Integration
- NAV (Net Asset Value) feeds for treasury tokens, fund tokens
- Real estate appraisal values
- Commodity spot prices
- Implementation: Cosmos-native oracle (SLINKY via Skip, or Band Protocol)

### 3. Legal Wrapper Registry
On-chain registry mapping:
- Token ID to SPV/trust entity (legal name, jurisdiction, registration number)
- SPV to custodian (who holds the underlying asset)
- SPV to governing documents (operating agreement, trust deed)
- Stored in Metas module with document hashes

### 4. Distribution Engine
Automated payment distribution to fractional holders:
- Dividend payments (equities)
- Yield/coupon payments (bonds, treasuries)
- Rental income (real estate)
- Implementation: CosmWasm contract triggered by maintainer or time-based automation

### 5. Custodian Bridge
Interface between on-chain tokens and off-chain custodians:
- Attestation messages from custodians (asset verified, value confirmed)
- Mint/burn authorization (new units only when custodian confirms underlying deposited)
- Reporting API for custodian dashboards

## Target Verticals (Priority Order)

### 1. Tokenized US Treasuries
- **Why first**: Highest demand, lowest regulatory friction, proven PMF (Ondo $2B+, Backed, OpenEden)
- **Module mapping**: Assets (wrap T-bills), Splits (fractionalize), Orders (secondary market), Maintainers (custodian = treasury dealer)
- **Compliance**: Relatively simple. No accreditation required for most treasury products.
- **Revenue model**: Management fee (10-30bps) on AUM

### 2. Real Estate Fractionalization
- **Why second**: Natural fit for Splits module. Large addressable market. Clear demand for fractional access.
- **Module mapping**: Assets (property tokens), Splits (fractional ownership), Orders (secondary with lockups), Maintainers (property manager, appraiser), Metas (deed, appraisal, inspection reports)
- **Compliance**: Reg D (US accredited), MiCA (EU), varies by jurisdiction
- **Revenue model**: Platform fee on issuance + secondary trading fees

### 3. Private Credit
- **Why third**: Growing market ($1.7T+). Uses Orders module for origination and secondary.
- **Module mapping**: Classifications (loan types), Orders (origination), Splits (tranching), Maintainers (servicer, underwriter)
- **Compliance**: Accredited investor only in most jurisdictions
- **Revenue model**: Origination fees + servicing spread

### 4. Commodity-Backed Tokens
- **Why fourth**: Uses wrap/unwrap pattern from Assets module. Gold, silver, carbon credits.
- **Module mapping**: Assets (wrap/unwrap commodities), Maintainers (vault operator), Metas (assay reports)
- **Compliance**: Varies. Commodity-linked tokens often avoid securities classification.
- **Revenue model**: Custody fees + trading fees
