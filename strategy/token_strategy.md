# Token Strategy: $MNTL Options Analysis

## Current State

- **Supply**: ~2.32B total, ~2.31B circulating
- **Price**: $0.00 (no price data since Dec 2025)
- **Holders**: 139 on Etherscan (ERC-20 bridged). Native Cosmos holder count unknown pending chain state investigation.
- **Exchanges**: Delisted from all tracked exchanges
- **Staking**: Status unknown. Requires chain state investigation.
- **Treasury**: Unknown. Requires governance module query.

## Option A: Revive $MNTL

**Approach**: Keep existing token, add new utility, pursue re-listings.

**Pros**:
- No legal complexity of new token issuance
- Existing holders are grandfathered in
- Preserves chain history and governance continuity

**Cons**:
- Tainted brand association (dead token, possible SEC mention in earlier search)
- 2.32B supply is large for a niche RWA chain
- Existing tokenomics designed for NFT marketplace, not RWA
- Re-listing requires significant market-making capital

**Requirements**:
- Halving or burn mechanism to reduce effective supply
- New utility model (RWA issuance fees, compliance staking, custodian bonds)
- Market maker partnership for exchange re-listing
- Community rebuilding from near-zero

## Option B: Token Migration ($MNTL to $RWA or similar)

**Approach**: Governance proposal for 1:N swap to new token with RWA-aligned tokenomics.

**Pros**:
- Clean slate on tokenomics
- Can design supply, vesting, and utility for RWA from scratch
- Swap mechanism respects existing holders
- New ticker signals new direction

**Cons**:
- Requires functioning governance (do we have enough validators/delegators?)
- Legal review needed for swap mechanism
- Migration complexity (bridge both Cosmos native and ERC-20)
- If chain is halted, governance proposal may not be possible

**Requirements**:
- Chain must be producing blocks OR genesis migration executed
- Legal opinion on token swap implications
- Snapshot of all holder balances (Cosmos + ERC-20 + any other bridges)
- Smart contract for ERC-20 swap

## Option C: Fresh Launch

**Approach**: New chain, new token, new genesis. AssetMantle code, new identity.

**Pros**:
- Complete clean slate. No legacy baggage.
- Design everything for RWA from day one
- No obligation to existing holders (legally simpler if structured correctly)
- Can raise fresh capital through compliant token sale

**Cons**:
- Loses 802 commits of chain history
- Could face criticism for abandoning original community
- Needs to build validator set from scratch
- Longer time to market

**Requirements**:
- New branding and domain
- Validator recruitment (minimum 15-20 for credible network)
- Token sale structure (SAFT, public sale, or grants)
- Full rebrand of all repos and documentation

## Recommendation

**Investigate chain state first (checklist item #3).** The decision tree depends on:

1. **If chain is producing blocks + validators active**: Option B (token migration) is viable and respectful to existing community.
2. **If chain is halted but state is recoverable**: Option B with genesis export + migration at new genesis.
3. **If chain state is unrecoverable or governance is impossible**: Option C (fresh launch) using forked code.

In all cases, the new tokenomics should include:
- RWA issuance fees paid in token
- Compliance staking (validators must stake to run compliance nodes)
- Custodian bonding (maintainers post bonds in token)
- Protocol revenue sharing (% of AUM fees to stakers)
- Reasonable supply (100M-500M range, not billions)

## Action Items

- [ ] Query chain state: `curl https://rpc.assetmantle.one/status` (or known RPC endpoints)
- [ ] Check validator set: `curl https://rpc.assetmantle.one/validators`
- [ ] Query governance proposals: check for any recent activity
- [ ] Snapshot holder balances on both Cosmos and Ethereum
- [ ] Engage legal counsel on token swap vs fresh launch implications
