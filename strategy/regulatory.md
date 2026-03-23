# Regulatory Landscape for RWA Tokenization

## Jurisdiction Map

### United States

**Securities Law**:
- Tokenized RWAs are almost certainly securities under the Howey test
- Issuance requires registration (S-1) or exemption:
  - **Reg D (506b/506c)**: Accredited investors only. No general solicitation (506b) or with verification (506c). No SEC registration. State blue sky exemptions via Rule 506.
  - **Reg S**: Non-US investors. Offshore transactions only.
  - **Reg A+**: Mini-IPO. Up to $75M. SEC qualification required. Open to non-accredited.
  - **Reg CF**: Crowdfunding. Up to $5M. Open to all.
- Secondary trading: Requires ATS (Alternative Trading System) license or partnership with licensed ATS

**Key Requirements**:
- KYC/AML mandatory (FinCEN, BSA)
- Accredited investor verification (506c)
- Transfer restrictions enforceable on-chain
- Transfer agent required for most securities

**Implication for AssetMantle**:
- Identities module must support accreditation verification
- Orders module must enforce transfer restrictions
- Need ATS partner or own ATS license for secondary market
- Reg D 506c is most practical starting point

### European Union (MiCA + MiFID II)

**MiCA** (Markets in Crypto-Assets Regulation, effective 2024-2025):
- Covers crypto-assets not classified as financial instruments
- Requires authorization as CASP (Crypto-Asset Service Provider)
- Whitepaper requirements for token issuance

**MiFID II**:
- Tokenized securities fall under existing securities regulation
- Requires authorization as investment firm or regulated market
- DLT Pilot Regime (EU Regulation 2022/858) allows tokenized securities on DLT-based trading platforms

**Key Requirements**:
- CASP authorization for crypto services
- AML/KYC under AMLD6
- Investor classification (retail, professional, eligible counterparty)
- Transaction reporting

**Implication**:
- Classifications module maps to MiCA asset categories
- Identity module needs EU investor classification tiers
- Consider DLT Pilot Regime for secondary trading

### Singapore (MAS)

**Securities and Futures Act (SFA)**:
- Digital tokens representing securities are regulated
- Exemptions: private placement (max 50 investors per 12 months), institutional investors, accredited investors

**Payment Services Act (PSA)**:
- DPT (Digital Payment Token) service license for token exchange

**Key Requirements**:
- Capital markets services license for dealing in securities
- AML/KYC under MAS Notice
- Technology risk management guidelines (MAS TRM)

**Implication**:
- Singapore is favorable for tokenized fund structures
- Private placement exemption works for initial launch
- MAS sandbox programs available

### UAE (DIFC / ADGM)

**DIFC**:
- Security token framework in place
- Innovation Testing License for sandbox
- Recognized jurisdiction for fund tokenization

**ADGM**:
- Virtual Assets Regulatory Authority (VARA) framework
- Comprehensive DLT framework for tokenized securities

**Implication**:
- UAE is increasingly RWA-friendly
- Good for commodity-backed tokens (gold, real estate)
- Free zone structures simplify entity setup

### Switzerland (FINMA)

- Pioneering tokenized securities regulation
- DLT Act (2021) creates legal framework for tokenized securities
- Backed Finance operates here (bIB01 treasury token)
- FINMA provides clear guidance on token classification

**Implication**:
- Strong option for regulated treasury token products
- Proven regulatory path via Backed Finance precedent

## Compliance Architecture Requirements

Based on multi-jurisdictional analysis, AssetMantle needs:

### Identity Tiers
| Tier | Description | Access |
|------|-------------|--------|
| 0 | Anonymous | View only, no transactions |
| 1 | Basic KYC | Crypto-native assets, non-security tokens |
| 2 | Accredited (US) / Professional (EU) | Security tokens, private placements |
| 3 | Institutional | All assets, higher limits |
| 4 | Qualified Custodian | Can serve as asset custodian/maintainer |

### Transfer Restriction Types
| Restriction | Description | Module |
|-------------|-------------|--------|
| Lockup | Cannot transfer for N days after acquisition | Orders |
| Accreditation | Buyer must be tier 2+ | Identities + Orders |
| Jurisdiction | Buyer must be in allowed jurisdiction | Identities + Orders |
| Max holders | Asset cannot exceed N holders | Splits + Orders |
| Minimum hold | Cannot hold less than N units | Splits |
| Sanctions | Buyer not on OFAC/EU sanctions list | Identities |

### Required Integrations
- KYC provider (Sumsub, Onfido, or P2P Protocol's ZK-KYC)
- Sanctions screening (Chainalysis, Elliptic)
- Accreditation verification (Verify Investor, Parallel Markets)
- Transfer agent (for US securities)

## Recommended Launch Jurisdiction

**Start with Reg D 506c (US accredited) + DIFC (UAE) dual-track:**

1. US accredited investors via Reg D 506c — largest market, clear framework
2. UAE via DIFC sandbox — RWA-friendly, growing market, fast licensing
3. Expand to EU (MiCA/DLT Pilot) and Singapore in subsequent phases

This minimizes initial regulatory burden while accessing the two most active RWA markets.
