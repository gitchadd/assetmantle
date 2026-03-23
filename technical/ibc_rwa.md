# Cross-Chain RWA via IBC

## Thesis

No major RWA protocol offers native cross-chain asset portability. IBC + ICS-721 gives AssetMantle a unique capability: RWA tokens that can move between Cosmos chains while preserving compliance metadata. A treasury token minted on MantleChain can serve as collateral on Osmosis or be traded on Neutron DEX.

## ICS-721 for RWA

ICS-721 (Interchain NFT Transfer) enables non-fungible token transfers over IBC. Since RWA tokens are effectively NFTs with metadata (each represents a unique or semi-fungible real-world asset), ICS-721 is the right standard.

### How It Works

1. User initiates ICS-721 transfer on MantleChain
2. Token is escrowed on source chain
3. IBC packet sent to destination chain with full metadata
4. Destination chain mints a voucher token representing the escrowed original
5. Voucher can be transferred, traded, used as collateral on destination chain
6. Return transfer burns voucher and releases original on MantleChain

### Compliance Challenge

Standard ICS-721 does not include compliance checks. A token sent via IBC could end up with an unverified receiver on the destination chain. Solutions:

**Option A: Pre-transfer compliance on source chain**
- MantleChain compliance checker verifies the destination address before sending
- Requires the destination address to have a MantleChain identity (cross-chain identity registry)
- Simplest to implement but limits portability

**Option B: IBC middleware for compliance**
- Custom IBC middleware on MantleChain that intercepts ICS-721 packets
- Checks receiver address against identity registry
- Rejects packets to unverified addresses
- More flexible but requires middleware development

**Option C: Compliance on destination chain (IBC callbacks)**
- Use IBC callbacks (IBC-Go v8+) to trigger compliance check on destination chain
- Destination chain must also run compliance logic (or trust MantleChain's attestation)
- Most decentralized but requires coordination with destination chains

**Recommendation**: Start with Option B (IBC middleware). It keeps compliance enforcement on MantleChain where the identity module lives, and doesn't require destination chains to change anything.

## Cross-Chain Identity

For RWA tokens to be usable across chains, identity must travel with them.

### Approach: Identity Attestation via IBC

1. User verifies identity on MantleChain (Identities module)
2. MantleChain issues an identity attestation (lightweight proof of verification + tier)
3. Attestation can be relayed to other Cosmos chains via IBC
4. Destination chain stores attestation and checks it during RWA operations

This means a user verified once on MantleChain can transact with RWA tokens on Osmosis, Neutron, etc.

### Data Model

```
IdentityAttestation {
  source_chain: "mantle-1",
  identity_id: ID,
  address: String,
  tier: u8,
  jurisdiction: String,
  verified_at: Timestamp,
  expires_at: Timestamp,
  attestation_hash: Hash,
}
```

Lightweight enough to include in IBC packets or relay separately.

## Target Chain Integrations

### Osmosis
- **Use case**: RWA tokens as collateral in lending pools
- **Integration**: ICS-721 transfer + identity attestation
- **Value**: Treasury tokens earning DeFi yield on top of underlying yield

### Noble
- **Use case**: USDC settlement for RWA purchases
- **Integration**: ICS-20 (USDC) + ICS-721 (RWA) coordination
- **Value**: Native USDC on Cosmos for RWA settlement

### Neutron
- **Use case**: RWA trading on Neutron DEX (Astroport)
- **Integration**: ICS-721 transfer + CosmWasm compliance contract on Neutron
- **Value**: Deeper liquidity for RWA secondary markets

### Stride
- **Use case**: Liquid staking of $MNTL (or successor token)
- **Integration**: Standard Stride liquid staking
- **Value**: Staked token remains liquid for DeFi

## Implementation Phases

### Phase 1: Basic ICS-721 (Week 12)
- Verify ICS-721 works with Assets module NFTs
- Test transfer to Osmosis testnet
- Ensure metadata (classification, compliance status) preserved in transfer

### Phase 2: Compliance Middleware (Week 14)
- Build IBC middleware that intercepts outgoing ICS-721 transfers
- Verify receiver has valid identity attestation
- Reject non-compliant transfers

### Phase 3: Cross-Chain Identity (Week 16)
- Build identity attestation relay via IBC
- Deploy attestation verifier on target chains (CosmWasm contract)
- End-to-end: verify on MantleChain, attest to Osmosis, trade RWA on Osmosis

### Phase 4: DeFi Composability (Week 20+)
- RWA as collateral on Mars Protocol (Osmosis)
- RWA trading pools on Astroport (Neutron)
- USDC settlement via Noble
