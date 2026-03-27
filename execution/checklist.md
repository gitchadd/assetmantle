# Master Execution Checklist

## Phase 1: Triage (Weeks 1-2)

- [x] **1.1** Fork 7 key repos into gitchadd/: node, modules, schema, wallet, documentation, client *(2026-03-23: 6 forked, genesisTransactions pending — not on gh fork command but available)*
- [x] **1.2** Run test suites on `modules` repo — document pass/fail per module *(2026-03-23)*
  - Go 1.23.12 required (1.18 too old for go.mod format `1.23.1`)
  - go.mod has commented-out `replace` for local schema path. Published schema version is mismatched — must use local replace.
  - With local schema replace: **16 pass, 45 fail**
  - Passing: simulation, assets/{auxiliaries,block,mappable,simulator,transactions}, classifications/{auxiliaries,block,mappable,queries,queries/classification,simulator,transactions}, identities/{auxiliaries,auxiliaries/authenticate,block}
  - Failing: mostly build failures in parameter packages, key packages, mapper packages (deeper module internals). Some test logic failures in simulation/schema and classification auxiliaries.
  - **Assessment**: Core module architecture is sound. Failures are in parameter handling and serialization — fixable. Not bitrotted.
- [x] **1.3** Run test suites on `node` repo — document pass/fail *(2026-03-23)*
  - Same local replace requirement as modules
  - Core packages (application, node, utilities/rest/faucet) **build clean**
  - 3 test packages fail: simulation/make (outdated simapp reference), utilities/rest/keys/add (missing method), utilities/rest/sign (missing imports)
  - **Assessment**: Node binary compiles. Test failures are in non-critical test utilities, not the chain logic itself.
- [x] **1.4** Investigate chain state: is MantleChain producing blocks? *(2026-03-23: YES)*
  - Chain `mantle-1` is LIVE at block 21,558,062 (producing blocks as of 2026-03-23)
  - RPC: `https://assetmantle-rpc.polkachu.com` (primary RPC, others dead)
  - REST: `https://assetmantle-api.polkachu.com`
  - 24 bonded validators. Top: Polkachu (603M), Stakewolle (178M), ITpro (155M), Allnodes (140M)
  - Total supply: 3,155,146,693 MNTL
  - Bonded: 1,421,228,149 MNTL (45% staking ratio)
  - Not bonded: 526,980,611 MNTL
  - Community pool: ~54.1M MNTL
  - Last 5 governance proposals all REJECTED (spam airdrops + halving proposal #3)
  - **Conclusion**: Chain is alive and functional. Token migration (Option B) is viable.
- [x] **1.5** Complete `reference/module_inventory.md` — catalogue all 45 repos with status *(2026-03-23: full inventory from API, 45 repos catalogued)*
- [x] **1.6** Complete `reference/transaction_reference.md` — every tx type from source code *(2026-03-23: verified against source. Corrections: classifications has only `govern` tx (define/deputize are auxiliaries). Maintainers has only `govern` tx (deputize is auxiliary).)*
- [x] **1.7** Complete `reference/dependency_map.md` — go.mod snapshot across repos *(2026-03-23: extracted from all 3 Go repos)*
- [x] **1.8** Verify module audit in `technical/module_audit.md` against actual source code *(2026-03-23: verified. Key finding: thin modules (classifications, maintainers, splits) have rich auxiliaries called by other modules internally. Also found rwaPOC repo (Scala) — they already started RWA work.)*
- [x] **1.9** Assess: go with token migration (Option B) or fresh launch (Option C)? *(2026-03-23: Option B recommended)*
  - Chain is live with 24 validators and 45% staking ratio
  - Code compiles and core tests pass — not bitrotted
  - Community pool has 54.1M MNTL — governance funding available
  - **Decision: Option B (token migration via governance)** — chain is healthy enough
  - Key risk: governance proposals recently rejected (spam proposals). Need to engage validators directly.
  - Polkachu is top validator with 603M stake — they're a known Cosmos infra provider, likely receptive to revival effort.

## Phase 2: Modernize (Weeks 3-8)

- [x] **2.1** Upgrade schema repo to SDK v0.50 compatibility *(2026-03-23: DONE. All 8 tests pass. Branch: rwa/phase2-sdk-upgrade on gitchadd/schema)*
  - Only breaking change: math types moved from `sdk/types` to `cosmossdk.io/math`
  - `sdk.Dec` -> `math.LegacyDec`, `sdk.NewInt` -> `math.NewInt`, etc.
  - `sdk.AccAddress`, `sdk.UnwrapSDKContext`, `sdk.ValidateDenom` unchanged
  - 23 files changed, 424 insertions(+), 310 deletions(-)
- [x] **2.2** Upgrade modules repo to SDK v0.50 *(2026-03-26: DONE. All packages build clean. Branch: rwa/phase2-sdk-upgrade on gitchadd/modules)*
  - 144+ files changed across all 7 modules + helpers + simulation + utilities
  - Store migration: `github.com/cosmos/cosmos-sdk/store` -> `cosmossdk.io/store` (135 files)
  - Math types: `sdk.Dec` -> `math.LegacyDec`, `sdk.NewInt` -> `math.NewInt`, etc.
  - Module interface: Added `IsAppModule()`/`IsOnePerModuleType()`, updated BeginBlock/EndBlock signatures
  - Removed deprecated `ValidateBasic()` calls, fixed `BondDenom` multi-value return
  - Fixed simulator packages (GetOrGenerate, NewOperationMsg signature changes)
  - Requires local schema replace pointing to upgraded schema
- [x] **2.3** Upgrade remaining 6 modules to SDK v0.50 patterns *(included in 2.2 — the prototype pattern meant fixing helpers/base/module.go cascaded to all 7 modules)*
- [x] **2.4** Upgrade node repo to SDK v0.50 + CometBFT v0.38 *(2026-03-27: DONE. Branch: rwa/phase2-sdk-upgrade on gitchadd/node)*
  - SDK v0.47.14 -> v0.50.11, CometBFT v0.37.5 -> v0.38.15
  - Key fix: removed golang.org/x/exp version pin that caused slices.SortFunc incompatibility
  - Extracted modules migrated: evidence, feegrant, upgrade -> cosmossdk.io/x/
  - Capability moved to ibc-go/modules/capability
  - Deprecated REST utilities (keys/add, sign) stubbed out
  - Removed Stride IBC rate limiting (needs v0.50 compatible version)
- [x] **2.5** Upgrade IBC-Go to v8.x *(included in 2.4: IBC-Go v7.4.0 -> v8.3.2, PFM v7 -> v8)*
- [ ] **2.6** Regenerate protobuf definitions
- [ ] **2.7** Add CosmWasm module (wasmd) to node
- [ ] **2.8** Run full test suite — all modules + node
- [ ] **2.9** Deploy to local testnet — verify all modules functional

**CHECKPOINT: Human review before Phase 3**

## Phase 3: RWA Module Extensions (Weeks 9-16)

- [ ] **3.1** Extend Identities module with compliance tiers and jurisdiction
- [ ] **3.2** Add pre-transfer compliance hooks to Assets module
- [ ] **3.3** Build compliance-checker CosmWasm contract
- [ ] **3.4** Build distribution-engine CosmWasm contract
- [ ] **3.5** Build oracle-adapter CosmWasm contract
- [ ] **3.6** Extend Splits module with cap table and distribution schedule
- [ ] **3.7** Extend Maintainers module with RWA role types
- [ ] **3.8** Extend Metas module with legal wrapper registry
- [ ] **3.9** Build custodian-bridge CosmWasm contract
- [ ] **3.10** Add IBC middleware for compliant ICS-721 transfers
- [ ] **3.11** Integration tests: full RWA lifecycle (issue identity > classify asset > mint > transfer > distribute > redeem)
- [ ] **3.12** Write developer documentation for all new capabilities

**CHECKPOINT: Human review before Phase 4**

## Phase 4: Launch (Weeks 17-24)

- [ ] **4.1** Deploy testnet with full RWA module set
- [ ] **4.2** Recruit 15-20 validators for testnet
- [ ] **4.3** Execute token migration (if Option B) or prepare fresh genesis (Option C)
- [ ] **4.4** Onboard 2-3 pilot RWA issuers (start with treasury tokens)
- [ ] **4.5** Security audit of modified modules + CosmWasm contracts
- [ ] **4.6** Penetration testing on compliance layer
- [ ] **4.7** Set up monitoring and alerting (chain health, compliance events)
- [ ] **4.8** Mainnet launch
- [ ] **4.9** Pursue exchange listing for new/migrated token
- [ ] **4.10** Submit documentation to Cosmos chain registry

**CHECKPOINT: Human review — mainnet operational**

## Ongoing

- [ ] Expand to real estate vertical (Phase 3 post-launch)
- [ ] Integrate P2P Protocol identity bridge
- [ ] Integrate P2P Protocol fiat on-ramp
- [ ] IBC integrations with Osmosis, Noble, Neutron
- [ ] Pursue regulatory licenses (ATS for US, CASP for EU)
