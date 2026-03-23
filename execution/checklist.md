# Master Execution Checklist

## Phase 1: Triage (Weeks 1-2)

- [ ] **1.1** Fork 7 key repos into gitchadd/: node, modules, schema, wallet, documentation, client, genesisTransactions
- [ ] **1.2** Run test suites on `modules` repo — document pass/fail per module
- [ ] **1.3** Run test suites on `node` repo — document pass/fail
- [ ] **1.4** Investigate chain state: is MantleChain producing blocks?
  - Query RPC: `curl https://rpc.assetmantle.one/status`
  - Check known RPC endpoints from chain registry
  - Check validator set: active count, total staked
  - Check governance: any recent proposals?
  - Check treasury/community pool balance
- [ ] **1.5** Complete `reference/module_inventory.md` — catalogue all 45 repos with status
- [ ] **1.6** Complete `reference/transaction_reference.md` — every tx type from source code
- [ ] **1.7** Complete `reference/dependency_map.md` — go.mod snapshot across repos
- [ ] **1.8** Verify module audit in `technical/module_audit.md` against actual source code
- [ ] **1.9** Assess: go with token migration (Option B) or fresh launch (Option C)?
  - Decision depends on chain state findings from 1.4
  - Document decision in `strategy/token_strategy.md`

## Phase 2: Modernize (Weeks 3-8)

- [ ] **2.1** Upgrade schema repo to SDK v0.50 compatibility
- [ ] **2.2** Upgrade modules repo — start with metas module as proof of concept
- [ ] **2.3** Upgrade remaining 6 modules to SDK v0.50 patterns
- [ ] **2.4** Upgrade node repo to SDK v0.50 + CometBFT v0.38
- [ ] **2.5** Upgrade IBC-Go to v8.x
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
