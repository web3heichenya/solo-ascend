# Solo Ascend Deployment Makefile
# Simplifies deployment across different networks

# Load environment variables
include .env
export

# Default values
NETWORK ?= local
VERIFY ?= false

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help install build test deploy deploy-hooks deploy-full clean lint format

help: ## Show this help message
	@echo "$(GREEN)Solo Ascend Deployment Commands$(NC)"
	@echo "================================="
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: ## Install dependencies
	@echo "$(GREEN)Installing dependencies...$(NC)"
	forge install
	npm install

build: ## Build contracts
	@echo "$(GREEN)Building contracts...$(NC)"
	forge build

test: ## Run tests
	@echo "$(GREEN)Running tests...$(NC)"
	forge test -vv

test-coverage: ## Run tests with coverage
	@echo "$(GREEN)Running tests with coverage...$(NC)"
	forge coverage

lint: ## Lint contracts with Solhint
	@echo "$(GREEN)Linting contracts...$(NC)"
	@command -v solhint >/dev/null 2>&1 || { echo "$(YELLOW)Installing solhint...$(NC)"; npm install -g solhint; }
	solhint 'src/**/*.sol' 'test/**/*.sol' 'script/**/*.sol'

lint-security: ## Run security analysis with Slither
	@echo "$(GREEN)Running security analysis...$(NC)"
	@command -v slither >/dev/null 2>&1 || { echo "$(YELLOW)Installing slither...$(NC)"; pip3 install slither-analyzer; }
	slither . --filter-paths lib/

format: ## Format contracts with Forge and Prettier
	@echo "$(GREEN)Formatting contracts...$(NC)"
	forge fmt
	npx prettier --write 'src/**/*.sol' 'test/**/*.sol' 'script/**/*.sol'

format-check: ## Check if contracts are formatted
	@echo "$(GREEN)Checking contract formatting...$(NC)"
	forge fmt --check

lint-all: format-check lint lint-security ## Run all linting tools
	@echo "$(GREEN)All linting checks completed!$(NC)"

# ================================
# DEPLOYMENT COMMANDS
# ================================

deploy-local: ## Deploy to local Anvil node
	@echo "$(GREEN)Deploying to local Anvil node...$(NC)"
	PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
	forge script script/WorkingDeploy.sol:WorkingDeploy \
		--rpc-url http://localhost:8545 \
		--broadcast -vv

deploy-sepolia: ## Deploy to Sepolia testnet
	@echo "$(GREEN)Deploying to Sepolia testnet...$(NC)"
	forge script script/WorkingDeploy.sol:WorkingDeploy \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--broadcast \
		--verify \
		--private-key $(PRIVATE_KEY) \
		--etherscan-api-key $(ETHERSCAN_API_KEY)

deploy-mainnet: ## Deploy to Ethereum mainnet
	@echo "$(RED)⚠️  DEPLOYING TO MAINNET ⚠️$(NC)"
	@echo "$(YELLOW)This will deploy to Ethereum mainnet. Are you sure? [y/N]$(NC)"
	@read line; if [ $$line = "y" ]; then \
		forge script script/WorkingDeploy.sol:WorkingDeploy \
			--rpc-url $(MAINNET_RPC_URL) \
			--broadcast \
			--verify \
			--private-key $(PRIVATE_KEY) \
			--etherscan-api-key $(ETHERSCAN_API_KEY) \
			--legacy; \
	fi

# ================================
# DEPLOYMENT VERIFICATION
# ================================

verify-deployment: ## Verify deployment status and addresses
	@echo "$(GREEN)Checking deployment status...$(NC)"
	@if [ -f "./deployments/31337.json" ]; then \
		echo "$(GREEN)Local deployment found:$(NC)"; \
		echo "$(YELLOW)Deployment file:$(NC) ./deployments/31337.json"; \
		echo "$(YELLOW)Contract count:$(NC) $$(grep -o '"[^"]*":' ./deployments/31337.json | grep -v network | grep -v chainId | grep -v deployer | grep -v timestamp | grep -v contracts | wc -l)"; \
		echo "$(YELLOW)Sample contracts:$(NC)"; \
		grep -o '"[^"]*":"0x[^"]*"' ./deployments/31337.json | head -5; \
	else \
		echo "$(YELLOW)No local deployment found$(NC)"; \
		echo "$(YELLOW)Run 'make deploy-local' first$(NC)"; \
	fi

check-deployment: ## Check if all contracts are deployed correctly
	@echo "$(GREEN)Verifying contract deployment...$(NC)"
	@if [ -z "$(HERO_ADDRESS)" ]; then \
		echo "$(RED)ERROR: HERO_ADDRESS not set in deployment$(NC)"; \
		exit 1; \
	fi
	cast code $(HERO_ADDRESS) --rpc-url http://localhost:8545

# ================================
# UTILITY COMMANDS
# ================================

setup-env: ## Create .env file from template
	@if [ ! -f .env ]; then \
		echo "$(GREEN)Creating .env file from template...$(NC)"; \
		cp .env.example .env; \
		echo "$(YELLOW)Please edit .env file with your actual values$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists$(NC)"; \
	fi

check-env: ## Check if environment variables are set
	@echo "$(GREEN)Checking environment variables...$(NC)"
	@if [ -z "$(PRIVATE_KEY)" ]; then \
		echo "$(RED)ERROR: PRIVATE_KEY not set$(NC)"; \
		exit 1; \
	fi
	@if [ -z "$(ETHERSCAN_API_KEY)" ]; then \
		echo "$(YELLOW)WARNING: ETHERSCAN_API_KEY not set (verification will fail)$(NC)"; \
	fi
	@echo "$(GREEN)Environment check passed$(NC)"

start-local-node: ## Start local Anvil node
	@echo "$(GREEN)Starting local Anvil node...$(NC)"
	anvil --host 0.0.0.0 --port 8545

# ================================
# INTERACTION COMMANDS
# ================================

mint-local: ## Mint a hero on local network (requires deployed contracts)
	@echo "$(GREEN)Minting hero on local network...$(NC)"
	@if [ ! -f "./deployments/31337.json" ]; then \
		echo "$(RED)ERROR: No deployment found$(NC)"; \
		echo "$(YELLOW)Run 'make deploy-local' first$(NC)"; \
		exit 1; \
	fi
	@HERO_ADDRESS=$$(grep '"heroContract":' ./deployments/31337.json | sed 's/.*"heroContract":"\([^"]*\)".*/\1/'); \
	if [ -z "$$HERO_ADDRESS" ]; then \
		echo "$(RED)ERROR: Hero contract not found in deployment$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)Minting hero at address: $$HERO_ADDRESS$(NC)"; \
	cast send $$HERO_ADDRESS "mint()" \
		--value 0.01ether \
		--rpc-url http://localhost:8545 \
		--private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

check-stats: ## Check analytics stats (requires deployed contracts)
	@echo "$(GREEN)Checking analytics stats...$(NC)"
	@if [ ! -f "./deployments/31337.json" ]; then \
		echo "$(RED)ERROR: No deployment found$(NC)"; \
		echo "$(YELLOW)Run 'make deploy-local' first$(NC)"; \
		exit 1; \
	fi
	@ANALYTICS_ADDRESS=$$(grep '"forgeAnalyticsHook":' ./deployments/31337.json | sed 's/.*"forgeAnalyticsHook":"\([^"]*\)".*/\1/'); \
	if [ -z "$$ANALYTICS_ADDRESS" ]; then \
		echo "$(RED)ERROR: Analytics contract not found in deployment$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)Checking stats at address: $$ANALYTICS_ADDRESS$(NC)"; \
	cast call $$ANALYTICS_ADDRESS "getComprehensiveStats()" \
		--rpc-url http://localhost:8545

# ================================
# MAINTENANCE COMMANDS
# ================================

clean: ## Clean build artifacts
	@echo "$(GREEN)Cleaning build artifacts...$(NC)"
	forge clean
	rm -rf cache/
	rm -rf out/

update-deps: ## Update dependencies
	@echo "$(GREEN)Updating dependencies...$(NC)"
	forge update

gas-report: ## Generate gas usage report
	@echo "$(GREEN)Generating gas usage report...$(NC)"
	forge test --gas-report

# ================================
# VERIFICATION COMMANDS
# ================================

verify-sepolia: ## Verify contracts on Sepolia
	@echo "$(GREEN)Verifying contracts on Sepolia...$(NC)"
	@if [ -z "$(CONTRACT_ADDRESS)" ]; then \
		echo "$(RED)ERROR: CONTRACT_ADDRESS not set$(NC)"; \
		exit 1; \
	fi
	forge verify-contract \
		--chain-id 11155111 \
		--num-of-optimizations 200 \
		--compiler-version v0.8.23 \
		$(CONTRACT_ADDRESS) \
		src/core/SoloAscendHero.sol:SoloAscendHero \
		--etherscan-api-key $(ETHERSCAN_API_KEY)

# ================================
# DEVELOPMENT WORKFLOW
# ================================

dev-setup: install setup-env build test ## Complete development setup
	@echo "$(GREEN)Development setup complete!$(NC)"
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "  1. Edit .env file with your private keys and RPC URLs"
	@echo "  2. Run 'make start-local-node' in another terminal"
	@echo "  3. Run 'make deploy-local' to deploy contracts"
	@echo "  4. Start developing!"

deploy-and-verify: deploy-local verify-deployment ## Deploy locally and verify
	@echo "$(GREEN)Deployment and verification complete!$(NC)"

dev-deploy: ## Deploy to local development environment
	@echo "$(GREEN)Starting development deployment...$(NC)"
	@echo "$(YELLOW)Make sure anvil is running on port 8545$(NC)"
	@$(MAKE) deploy-local
	@$(MAKE) verify-deployment

quick-test: build test ## Quick build and test
	@echo "$(GREEN)Quick test complete!$(NC)"

# ================================
# CI/CD COMMANDS
# ================================

ci-test: install build test lint ## Complete CI test suite
	@echo "$(GREEN)CI test suite passed!$(NC)"

ci-coverage: install build test-coverage ## CI with coverage
	@echo "$(GREEN)CI coverage test complete!$(NC)"

# Show help by default
.DEFAULT_GOAL := help