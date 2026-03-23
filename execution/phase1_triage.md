# Phase 1: Triage (Weeks 1-2)

## Objective

Understand the current state of everything: code health, chain status, dependencies, and make the key decision on token strategy (migrate vs fresh launch).

## Tasks

### 1.1 Fork Key Repos

Fork into `gitchadd/` GitHub account:

| Repo | URL | Priority |
|------|-----|----------|
| node | github.com/AssetMantle/node | Critical |
| modules | github.com/AssetMantle/modules | Critical |
| schema | github.com/AssetMantle/schema | Critical |
| wallet | github.com/AssetMantle/wallet | Medium |
| documentation | github.com/AssetMantle/documentation | Medium |
| client | github.com/AssetMantle/client | Medium |
| genesisTransactions | github.com/AssetMantle/genesisTransactions | High (chain state) |

```bash
for repo in node modules schema wallet documentation client genesisTransactions; do
  gh repo fork AssetMantle/$repo --org gitchadd --clone=false
done
```

### 1.2 Test Modules Repo

```bash
cd modules
go mod download
go test ./... -v -count=1 2>&1 | tee test_results.txt
```

Document per-module:
- Pass/fail count
- Any compilation errors
- Missing dependencies
- Flaky tests

### 1.3 Test Node Repo

```bash
cd node
go mod download
go test ./... -v -count=1 2>&1 | tee test_results.txt
```

### 1.4 Investigate Chain State

Try known RPC endpoints:
```bash
curl -s https://rpc.assetmantle.one/status | jq .
curl -s https://rpc.assetmantle.one/validators | jq '.result.validators | length'
curl -s https://rpc.assetmantle.one/genesis | jq '.result.genesis.chain_id'
```

Check chain registry:
```bash
curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/assetmantle/chain.json | jq .
```

Key questions:
- Is the chain producing blocks? (check latest block time vs current time)
- How many validators are active?
- What is the total staked amount?
- Are there any recent governance proposals?
- What is the community pool balance?

### 1.5-1.7 Reference Documents

Populate the reference/ directory by scanning all 45 repos:

```bash
# List all repos with key metadata
gh api orgs/AssetMantle/repos --per-page=100 --paginate \
  --jq '.[] | "\(.name)|\(.language)|\(.stargazers_count)|\(.updated_at)|\(.archived)|\(.description)"'
```

For dependency map, read go.mod from each Go repo:
```bash
for repo in node modules schema; do
  echo "=== $repo ==="
  gh api repos/AssetMantle/$repo/contents/go.mod --jq '.content' | base64 -d
done
```

### 1.8 Verify Module Audit

Cross-reference `technical/module_audit.md` against actual source code:
- Check that listed transactions match source
- Check that listed queries match source
- Note any transactions/queries we missed
- Note any deprecated or unused code

### 1.9 Token Strategy Decision

Based on findings from 1.4:

| Chain State | Recommendation |
|-------------|---------------|
| Blocks producing, validators active | Option B: Token migration via governance |
| Chain halted, state recoverable | Option B: Genesis export + migration |
| Chain halted, state unrecoverable | Option C: Fresh launch |
| Chain status unknown | Try to contact last known validators |

## Deliverables

- [ ] 7 repos forked
- [ ] Test results documented
- [ ] Chain state report
- [ ] reference/module_inventory.md complete
- [ ] reference/transaction_reference.md complete
- [ ] reference/dependency_map.md complete
- [ ] Module audit verified
- [ ] Token strategy decision documented
