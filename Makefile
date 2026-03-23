.PHONY: help inventory deps chain-status

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

inventory: ## Fetch full repo inventory from GitHub API
	@echo "Fetching AssetMantle repos..."
	@gh api orgs/AssetMantle/repos --per-page=100 --paginate \
		--jq '.[] | "\(.name)|\(.language // "none")|\(.stargazers_count)|\(.updated_at)|\(.archived)|\(.description // "no description")"' \
		| sort -t'|' -k4 -r

deps: ## Extract go.mod dependencies from key repos
	@for repo in node modules schema; do \
		echo "=== $$repo ===" ; \
		gh api repos/AssetMantle/$$repo/contents/go.mod --jq '.content' | base64 -d 2>/dev/null || echo "Failed to fetch" ; \
		echo "" ; \
	done

chain-status: ## Check MantleChain RPC status
	@echo "Checking known RPC endpoints..."
	@curl -s --connect-timeout 5 https://rpc.assetmantle.one/status 2>/dev/null | jq '.result.sync_info' || echo "RPC unreachable"
	@echo ""
	@echo "Checking chain registry..."
	@curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/assetmantle/chain.json 2>/dev/null | jq '.chain_name, .status, .network_type' || echo "Not in chain registry"

fork-repos: ## Fork key AssetMantle repos into gitchadd
	@for repo in node modules schema wallet documentation client; do \
		echo "Forking $$repo..." ; \
		gh repo fork AssetMantle/$$repo --clone=false 2>&1 || echo "Already forked or error" ; \
	done
