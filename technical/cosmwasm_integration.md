# CosmWasm Integration Plan

## Why CosmWasm

The current AssetMantle chain is pure Go modules. Every logic change requires a chain upgrade via governance proposal. For RWA, we need:

1. **Configurable compliance rules** that vary per asset class and jurisdiction
2. **Rapid iteration** on distribution logic, oracle adapters, custodian bridges
3. **Third-party extensibility** for issuers to deploy custom RWA logic
4. **Audit separation** — compliance contracts audited independently from chain code

CosmWasm provides all of this without sacrificing the benefits of the Go module architecture.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   MantleChain                    │
│                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │  Assets   │ │Identities│ │   CosmWasm VM    │ │
│  │  Module   │ │  Module  │ │                  │ │
│  │  (Go)     │ │  (Go)    │ │ ┌──────────────┐ │ │
│  │           │ │          │ │ │  Compliance   │ │ │
│  │  send ────┼─┼──────────┼─┼>│  Checker      │ │ │
│  │           │ │          │ │ │  (Rust/Wasm)  │ │ │
│  │           │ │          │ │ └──────────────┘ │ │
│  │           │ │          │ │ ┌──────────────┐ │ │
│  │           │ │          │ │ │ Distribution  │ │ │
│  │           │ │          │ │ │ Engine        │ │ │
│  │           │ │          │ │ └──────────────┘ │ │
│  │           │ │          │ │ ┌──────────────┐ │ │
│  │           │ │          │ │ │ Oracle        │ │ │
│  │           │ │          │ │ │ Adapter       │ │ │
│  │           │ │          │ │ └──────────────┘ │ │
│  └──────────┘ └──────────┘ └──────────────────┘ │
└─────────────────────────────────────────────────┘
```

## Integration Steps

### 1. Add wasmd Module

Add `cosmwasm/wasmd` v0.50+ as a dependency to the node repo. Register in `app.go` alongside existing modules.

Configuration:
- **Permissioned uploads**: Only governance can deploy new contracts. This is critical for an RWA chain.
- **Gas limits**: Set appropriate gas limits for compliance checks (must be fast)
- **Memory limits**: Standard CosmWasm limits (32MB per contract)

### 2. Custom Module-to-Wasm Bindings

Go modules need to call CosmWasm contracts and vice versa. This requires custom bindings.

**Go to Wasm (custom messages)**:
```go
// Assets module calls compliance checker before send
type ComplianceCheckMsg struct {
    AssetID    string `json:"asset_id"`
    Sender     string `json:"sender"`
    Receiver   string `json:"receiver"`
    Amount     string `json:"amount"`
}
```

**Wasm to Go (custom queries)**:
```rust
// Compliance contract queries Identity module
#[derive(Serialize, Deserialize)]
pub enum CustomQuery {
    IdentityTier { address: String },
    IdentityJurisdiction { address: String },
    AssetClassification { asset_id: String },
    SplitHolders { asset_id: String },
}
```

### 3. Contract Templates

Build reusable contract templates for common RWA patterns:

| Contract | Purpose | Instantiation |
|----------|---------|---------------|
| `compliance-checker` | Pre-transfer compliance | One per asset classification |
| `distribution-engine` | Yield/dividend distribution | One per asset |
| `oracle-adapter` | Price feed aggregation | One per price source |
| `custodian-bridge` | Mint/burn with custodian attestation | One per custodian |
| `lockup-manager` | Vesting/lockup schedules | One per asset class |

### 4. Testing

- Unit tests for each contract (Rust)
- Integration tests for module-to-wasm bindings
- Multi-contract scenario tests (compliance + distribution + oracle)
- Gas benchmarks for compliance checks (must complete within block time)

## Permissioning Model

| Action | Who Can Do It |
|--------|--------------|
| Deploy new contract | Governance proposal only |
| Instantiate from approved code | Governance or designated admin |
| Execute contract | Any identity with appropriate tier |
| Migrate contract | Governance proposal only |
| Update admin | Governance proposal only |

This ensures all deployed code is audited and approved before going live.

## Contract Development Workflow

1. Write contract in Rust using CosmWasm SDK
2. Audit contract (internal + external)
3. Submit governance proposal to store code on-chain
4. After approval, instantiate contract with configuration
5. Register contract address in relevant module (e.g., Assets module stores compliance checker address)
6. Contract is now called automatically during relevant transactions
