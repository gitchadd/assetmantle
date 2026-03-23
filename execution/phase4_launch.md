# Phase 4: Launch (Weeks 17-24)

## Objective

Deploy testnet, recruit validators, onboard pilot issuers, audit, and launch mainnet.

## Prerequisites

- Phase 3 complete
- Full RWA lifecycle test passing
- All PRs merged to fork main branches

## Tasks

### 4.1 Testnet Deployment

1. Generate genesis file with:
   - Initial validator set (self + early partners)
   - Pre-configured identity schemas (US accredited, EU professional)
   - Pre-configured classifications (treasury, real estate, credit, commodity)
   - CosmWasm contracts deployed (compliance, distribution, oracle, custodian)
   - Governance parameters (deposit, voting period, quorum)
2. Configure chain parameters:
   - Block time: 6 seconds
   - Gas prices: calibrated for RWA transactions
   - CosmWasm: permissioned uploads only
3. Deploy persistent testnet
4. Verify all modules functional on testnet

### 4.2 Validator Recruitment

Target: 15-20 validators for credible network.

Sources:
- Cosmos ecosystem validators (many run multiple chains)
- RWA-focused projects (tokenization platforms, custodians)
- P2P Protocol validator network (if applicable)
- Community validators from original AssetMantle (if any still active)

Requirements:
- Minimum hardware: 4vCPU, 32GB RAM, 200GB SSD
- Reliable uptime (99.5%+)
- Participation in testnet for at least 2 weeks before mainnet

### 4.3 Token Migration or Fresh Genesis

**If Option B (migration)**:
1. Export state from existing MantleChain
2. Transform genesis: update chain ID, add new modules, migrate token balances
3. Define swap mechanism for ERC-20 holders
4. Governance proposal on old chain (if functional) to authorize migration

**If Option C (fresh launch)**:
1. Generate new genesis with designed tokenomics
2. Allocate tokens: community, team, treasury, validators, ecosystem
3. Design vesting schedules
4. Plan initial distribution (airdrop to old holders if desired, public allocation)

### 4.4 Pilot RWA Issuers

Onboard 2-3 issuers for launch:

| Vertical | Target | What They Do |
|----------|--------|-------------|
| Treasury | Stablecoin/treasury fund | Issue tokenized T-bill product |
| Real estate | Property tokenization platform | Issue fractional property tokens |
| Credit | Private credit fund | Issue tokenized loan positions |

For each issuer:
- Set up their identity (Tier 4 custodian)
- Configure classification for their asset type
- Deploy customized compliance checker
- Configure distribution engine
- Test full lifecycle on testnet

### 4.5 Security Audit

Scope:
- All modified Go modules (focus: compliance hooks, identity extensions)
- All CosmWasm contracts (compliance, distribution, oracle, custodian)
- IBC middleware
- Genesis configuration
- Token migration contract (if applicable)

Audit firms (Cosmos-experienced):
- Oak Security
- Halborn
- SRLabs
- Informal Systems (IBC expertise)

### 4.6 Penetration Testing

Focus areas:
- Compliance bypass attempts (can unverified user acquire RWA tokens?)
- Identity spoofing (can user fake accreditation tier?)
- Oracle manipulation (can attacker influence NAV?)
- IBC exploit (can compliant token become non-compliant via cross-chain transfer?)
- Governance attack (can minority manipulate token-related governance?)

### 4.7 Monitoring and Alerting

Set up:
- Chain health: block production, missed blocks, validator set changes
- Compliance events: identity quashes, revokes, failed compliance checks
- Oracle health: price staleness, source disagreements
- Distribution tracking: successful/failed distributions
- IBC channel status: open channels, pending packets

Tools:
- Prometheus + Grafana for chain metrics
- Custom alerting for compliance events
- PagerDuty/Opsgenie for critical alerts

### 4.8 Mainnet Launch

Launch sequence:
1. Final genesis generated with audited code
2. Validators submit gentx
3. Genesis distributed
4. Chain starts at coordinated time
5. Verify all modules functional
6. Deploy CosmWasm contracts via governance proposals
7. Onboard pilot issuers
8. First RWA tokens minted

### 4.9 Exchange Listing

Prerequisites:
- Working mainnet with real RWA volume
- Audit reports published
- Legal opinion on token classification
- Market maker engaged

Target exchanges:
- Osmosis (DEX, easiest — just IBC)
- MEXC (was previously listed)
- Gate.io
- Kucoin

### 4.10 Chain Registry

Submit to:
- [cosmos/chain-registry](https://github.com/cosmos/chain-registry)
- [ping.pub](https://ping.pub/) explorer
- Keplr wallet integration
- Leap wallet integration
- Mintscan listing

## Deliverables

- [ ] Testnet operational with 15+ validators
- [ ] Token migration/genesis complete
- [ ] 2-3 pilot issuers onboarded
- [ ] Security audit passed
- [ ] Penetration testing passed
- [ ] Monitoring operational
- [ ] Mainnet launched
- [ ] At least 1 exchange listing
- [ ] Chain registry submission
