# Solo Ascend - Smart Contracts

This module contains the Foundry smart contracts for Solo Ascend.

## 🏗️ Architecture Overview

The Solo Ascend protocol consists of several interconnected smart contracts:

### Core Contracts

- **`SoloAscendHero`** - Main hero NFT contract with minting and attribute management
- **`ForgeCoordinator`** - Orchestrates the complete forging process from randomness to effect application
- **`ForgeItemNFT`** - NFT contract for forge items with quality-based mechanics
- **`Treasury`** - Manages game revenue and reward distribution

### Registry System

- **`HeroClassRegistry`** - Manages hero classes and base attributes
- **`ForgeEffectRegistry`** - Manages forge effect types and implementations
- **`ForgeItemRegistry`** - Manages forge item contracts by quality
- **`HookRegistry`** - Manages extensible hook system
- **`OracleRegistry`** - Manages randomness oracles and quality determination

### Effect System

- **`AttributeForgeEffect`** - Boosts specific hero attributes
- **`AmplifyForgeEffect`** - Provides percentage boosts to all attributes
- **`MythicForgeEffect`** - Enables infinite leveling stage
- **`EnhanceForgeEffect`** - Creates additional attribute forge items
- **`FTForgeEffect`** - Distributes treasury token rewards
- **`NFTForgeEffect`** - Future expansion for NFT collection generation

### Oracle Integration

- **`ChainlinkVRFDirectOracle`** - Chainlink VRF integration for true randomness
- **`SimpleOracle`** - Simple oracle for testing and development

## 🚀 Getting Started

### Prerequisites

- Node.js (v18+)
- Foundry
- Git

### Installation

1. **Install dependencies**

   ```bash
   make install
   # or
   forge install && npm install
   ```

2. **Set up environment**

   ```bash
   make setup-env
   # Edit .env with your configuration
   ```

3. **Build contracts**

   ```bash
   make build
   ```

4. **Run tests**
   ```bash
   make test
   ```

### Quick Development Setup

```bash
# Complete development setup
make dev-setup

# Start local node (in separate terminal)
make start-local-node

# Deploy to local network
make deploy-local
```

## 📋 Core Mechanics

### Hero System

#### Hero Classes

- **Warrior**: Balanced melee fighter with high HP and armor
- **Mage**: Magic-focused with high AP and mana efficiency
- **Archer**: Ranged attacker with high critical strike and attack speed
- **Rogue**: Agile assassin with high movement speed and critical damage
- **Paladin**: Support tank with healing and defensive capabilities

#### Hero Stages

1. **Forging**: Can perform daily forges to improve attributes
2. **Completed**: Forged an Amplify effect, no more daily forging allowed
3. **Solo Leveling**: Forged a Mythic effect, enables infinite progression

### Forging System

#### Daily Forge Process

1. Player initiates forge with oracle selection and gas limit
2. Oracle provides verifiable randomness
3. ForgeCoordinator determines quality based on randomness
4. Effect type is selected based on quality and game rules
5. Forge item NFT is minted with corresponding effect
6. Effect is automatically applied based on item destination

#### Quality Tiers

- **Silver (70%)**: Basic quality, always soulbound
- **Gold (20%)**: Uncommon quality, always soulbound
- **Rainbow (9%)**: Rare quality, tradeable NFT
- **Mythic (1%)**: Legendary quality, tradeable NFT

#### Effect Types

- **Attribute**: Permanently boosts a specific hero attribute
- **Amplify**: Provides percentage boost to all attributes (ends daily forging)
- **Mythic**: Enables infinite leveling stage (extremely rare)
- **Enhance**: Creates two additional attribute forge items
- **FT**: Distributes treasury token rewards to player
- **NFT**: Future feature for generating new NFT collections

### Economic Model

#### Minting Costs

- **Hero Mint Price**: 0.00033 ETH
- **Treasury Fee**: 0.00001 ETH (goes to community treasury)
- **Forge Costs**: Variable based on oracle and gas requirements

#### Revenue Distribution

- Project development fund (mint price minus treasury fee)
- Community treasury (treasury fees + additional deposits)
- Player rewards through FT forge effects

## 🛠️ Development

### Project Structure

```
contracts/
├── src/
│   ├── core/                 # Core game contracts
│   │   ├── SoloAscendHero.sol
│   │   ├── ForgeCoordinator.sol
│   │   ├── ForgeItemNFT.sol
│   │   ├── Treasury.sol
│   │   └── registries/       # Registry contracts
│   ├── effects/              # Forge effect implementations
│   ├── hooks/               # Hook system contracts
│   ├── oracles/             # Oracle implementations
│   ├── interfaces/          # Contract interfaces
│   ├── libraries/           # Shared libraries
│   └── utils/               # Utility contracts
├── test/                    # Test files
├── script/                  # Deployment scripts
└── docs/                    # Documentation
```

### Key Development Commands

```bash
# Linting and formatting
make lint-all            # Run all linting checks
make format              # Format all contracts

# Testing
make test                # Run all tests
make test-coverage       # Run tests with coverage
make gas-report          # Generate gas usage report

# Deployment
make deploy-local        # Deploy to local Anvil
make deploy-sepolia      # Deploy to Sepolia testnet
make deploy-mainnet      # Deploy to Ethereum mainnet

# Security
make lint-security       # Run Slither security analysis
```

### Testing Strategy

The project includes comprehensive test coverage:

- **Unit Tests**: Individual contract functionality
- **Integration Tests**: Multi-contract workflows
- **Security Tests**: Economic attack vectors and edge cases
- **Gas Optimization Tests**: Gas usage verification
- **Boundary Tests**: Edge cases and error conditions

### Hook System

The extensible hook system allows for custom game mechanics:

```solidity
// Example custom hook
contract CustomForgeHook is IHook {
  function execute(IHookRegistry.HookPhase phase, bytes calldata data) external override {
    // Custom logic here
  }
}
```

Available hook phases:

- `BEFORE_HERO_MINTING`: Before hero minting begins
- `AFTER_HERO_MINTED`: After hero is successfully minted
- `BEFORE_EFFECT_GENERATION`: Before forge effect generation
- `AFTER_EFFECT_GENERATED`: After forge effect is generated
- `FORGE_INITIATION`: When forge request is initiated
- `HERO_STAGE_CHANGED`: When hero stage transitions occur
- `HERO_ATTRIBUTE_UPDATED`: When hero attributes are modified

## 🔒 Security

### Security Measures

- **Reentrancy Protection**: All external calls protected with ReentrancyGuard
- **Access Control**: Strict role-based permissions using OpenZeppelin
- **Oracle Security**: Multiple oracle support with validation
- **Economic Protections**: Cooldown periods and supply caps
- **Hook Isolation**: Hooks cannot break main game flow

### Audits

The contracts have undergone:

- Internal security review
- Slither static analysis
- Comprehensive test coverage
- Economic modeling and attack vector analysis

### Known Limitations

- Oracle dependency for randomness (mitigated with multiple oracle support)
- Hook execution gas limits (mitigated with try-catch patterns)
- ERC-6551 implementation dependency

## 📊 Gas Optimization

The contracts are heavily optimized for gas efficiency:

- **Packed Structs**: Attributes packed into minimal storage slots
- **Unchecked Math**: Safe arithmetic operations where overflow is impossible
- **Storage Access Patterns**: Minimized SSTORE operations
- **Batch Operations**: Support for batched transactions where applicable

Typical gas costs (approximate):

- Hero Mint: ~180,000 gas
- Daily Forge: ~120,000-200,000 gas (varies by effect)
- Forge Item Transfer: ~50,000-80,000 gas

## 🌐 Deployment

### Supported Networks

- **Ethereum Mainnet**: Production deployment
- **Sepolia Testnet**: Public testing
- **Local Development**: Anvil/Hardhat

### Environment Variables

Required environment variables:

```bash
PRIVATE_KEY=                 # Deployer private key
ETHERSCAN_API_KEY=          # For contract verification
SEPOLIA_RPC_URL=            # Sepolia RPC endpoint
MAINNET_RPC_URL=            # Mainnet RPC endpoint
```

### Deployment Process

1. **Configure environment variables**
2. **Deploy core contracts**: `make deploy-sepolia`
3. **Verify contracts**: Automatic with deployment
4. **Initialize registries**: Done via deployment script
5. **Set up oracles**: Configure Chainlink VRF
6. **Deploy hook system**: `make deploy-hooks-sepolia`
