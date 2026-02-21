# Solo Ascend Deployment System

A unified, battle-tested deployment system for the Solo Ascend project that enables one-click deployment with comprehensive contract management.

## Overview

This deployment system features a **unified architecture** that provides:

- **One-click full deployment** of the entire Solo Ascend ecosystem (23 contracts)
- **Network-specific configuration** using `DeployConfig.sol`
- **Dependency management** ensuring contracts are deployed in the correct order
- **Contract size optimization** with external library deployment
- **Comprehensive verification** and address tracking
- **Upgradeable components** for future enhancements

## Architecture

### Core Components

1. **WorkingDeploy.sol** - Unified deployment script for all contracts
2. **DeployConfig.sol** - Network-specific configuration management
3. **HeroAvatarLib.sol** - External avatar generation library (deployed separately)

### Key Features

- **7-Phase Deployment**: Structured deployment across logical phases
- **External Library Support**: HeroAvatarLib deployed as separate contract to solve size limits
- **Upgradeable Avatar System**: HeroSVGRenderer can update avatar library address
- **Comprehensive Logging**: Detailed deployment progress and verification
- **JSON Export**: All contract addresses saved to deployments/ directory

## Deployment Architecture

### Phase Structure

The deployment follows a carefully orchestrated 7-phase approach with an optional 8th phase for trait registration:

```
Phase 01: Core Infrastructure
├── Treasury
└── HeroAvatarLib (External Avatar Library)

Phase 02: Registry Contracts
├── HeroClassRegistry
├── ForgeEffectRegistry
├── OracleRegistry
├── HookRegistry
├── ForgeItemRegistry
└── HeroTraitRegistry

Phase 03: Utility Contracts
├── HeroSVGRenderer (connected to HeroAvatarLib)
└── HeroMetadataRenderer

Phase 04: Game Mechanics
├── ForgeCoordinator
├── SimpleOracle
├── AttributeForgeEffect
├── AmplifyForgeEffect
├── EnhanceForgeEffect
├── MythicForgeEffect
├── NFTForgeEffect
└── ForgeItem NFTs (Silver, Gold, Rainbow, Mythic)

Phase 05: Main Contracts
├── SoloAscendHero
└── FTForgeEffect

Phase 06: Integration & Hooks
└── ForgeAnalyticsHook

Phase 07: System Configuration
├── Effect type registrations
├── Oracle registrations
├── ForgeItem registrations
├── Hook registrations
└── Cross-contract relationships

Phase 08: Trait Registration (Separate)
└── Dynamic trait registration from external data files
```

## Usage

### Quick Start

```bash
# Start local node (in separate terminal)
make start-local-node

# Deploy everything
make deploy-local

# Verify deployment
make verify-deployment

# Mint a test hero
make mint-local
```

### Full Deployment Commands

```bash
# Local development
forge script script/WorkingDeploy.sol:WorkingDeploy \
  --rpc-url http://localhost:8545 \
  --broadcast -vv \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Sepolia testnet
forge script script/WorkingDeploy.sol:WorkingDeploy \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast --verify \
  --private-key $PRIVATE_KEY \
  --etherscan-api-key $ETHERSCAN_API_KEY

# Mainnet (with confirmation)
make deploy-mainnet
```

### Configuration

The deployment system automatically detects the network and applies appropriate configuration:

- **Mainnet networks**: Full feature set with production parameters
- **Testnet networks**: Reduced fees, test configurations
- **Local/Anvil**: Simplified setup for development

#### Supported Networks

- Ethereum Mainnet & Sepolia
- Polygon Mainnet & Mumbai
- Arbitrum One & Sepolia
- Optimism & Sepolia
- Base Mainnet & Sepolia
- BSC Mainnet & Testnet
- Local Anvil (Chain ID 31337)

## Contract Size Optimization

### Problem Solved

The original HeroSVGRenderer exceeded the EIP-170 contract size limit (24,576 bytes) due to large inline SVG data for CryptoPunks-style hero avatars.

### Solution Implemented

1. **External Library**: HeroAvatarLib deployed as separate contract (15,735 bytes)
2. **Interface-Based Access**: HeroSVGRenderer calls library via IHeroAvatarLib interface
3. **Upgradeable Design**: `setHeroAvatarLib()` allows avatar system upgrades
4. **Removed Attributes Display**: Simplified SVG generation for better performance

### Benefits

- ✅ All contracts now deploy successfully
- ✅ Modular avatar system for future upgrades
- ✅ Reduced gas costs for SVG generation
- ✅ Cleaner separation of concerns

## Deployed Contracts

### Core Infrastructure (2 contracts)

- **Treasury** - Handles fees and rewards distribution
- **HeroAvatarLib** - CryptoPunks-style avatar generation library

### Registry System (6 contracts)

- **HeroClassRegistry** - Manages hero classes (8 classes: Warrior, Mage, Archer, Rogue, Paladin, Summoner, Berserker, Priest)
- **ForgeEffectRegistry** - Manages forge effect implementations
- **OracleRegistry** - Manages oracle implementations and random distributions
- **HookRegistry** - Manages lifecycle hooks
- **ForgeItemRegistry** - Manages ForgeItem NFT contracts by quality
- **HeroTraitRegistry** - Manages hero visual traits for NFT generation

### Utility Contracts (2 contracts)

- **HeroSVGRenderer** - On-chain SVG generation (upgradeable avatar lib)
- **HeroMetadataRenderer** - Handles metadata generation and trait snapshots

### Game Mechanics (7 contracts)

- **ForgeCoordinator** - Orchestrates the complete forging process
- **SimpleOracle** - Pseudo-random oracle for cost-effective networks
- **AttributeForgeEffect** - Direct attribute modifications
- **AmplifyForgeEffect** - Percentage-based attribute amplification
- **EnhanceForgeEffect** - Specific attribute enhancements
- **MythicForgeEffect** - Rare mythic transformations
- **NFTForgeEffect** - NFT reward effects

### ForgeItem NFTs (4 contracts)

- **Silver ForgeItemNFT** - Soulbound, common effects (70% drop rate)
- **Gold ForgeItemNFT** - Soulbound, enhanced effects (20% drop rate)
- **Rainbow ForgeItemNFT** - Tradeable, rare effects (9% drop rate)
- **Mythic ForgeItemNFT** - Tradeable, legendary effects (1% drop rate)

### Main Game Contracts (2 contracts)

- **SoloAscendHero** - Main hero NFT with ERC-6551 token bound accounts
- **FTForgeEffect** - Fungible token reward effects

### Analytics & Hooks (1 contract)

- **ForgeAnalyticsHook** - Comprehensive analytics and statistics collection

**Total: 24 contracts deployed across 8 phases**

## Default Configurations

### Hero Classes (8 Total)

- **Warrior** - High HP/Defense, melee specialist with sword and shield
- **Mage** - High AP/CDR, magic specialist with elemental control
- **Archer** - High AD/Attack Speed, ranged specialist with precision
- **Rogue** - High crit/speed, assassin specialist with stealth
- **Paladin** - High HP Regen/AP, holy specialist with divine powers
- **Summoner** - High AP, creature summoning and control specialist
- **Berserker** - High AD/Life Steal, fury-based melee fighter
- **Priest** - High AP/CDR, healing and support specialist

### Oracle Quality Distribution

- **SimpleOracle**: 70% Silver, 20% Gold, 9% Rainbow, 1% Mythic
- Configurable weights for different oracle implementations

### Hook Registrations

ForgeAnalyticsHook registered for key lifecycle phases:

- `BEFORE_HERO_MINTING` - Pre-mint validation and stats
- `AFTER_HERO_MINTED` - Post-mint analytics tracking
- `FORGE_INITIATION` - Forge process analytics

## Verification and Monitoring

### Deployment Verification

The system includes comprehensive verification:

- Contract bytecode validation after each phase
- Dependency validation before deployment
- Final verification of all 24 contracts
- JSON export of all addresses to `./deployments/{chainId}.json`

### Deployment Progress Tracking

```bash
# Check deployment status
make verify-deployment

# Check specific contract code
cast code $CONTRACT_ADDRESS --rpc-url $RPC_URL

# View deployment addresses
cat ./deployments/31337.json | jq '.contracts'
```

### Contract Interaction

```bash
# Mint a hero (requires deployment)
make mint-local

# Check analytics stats
make check-stats

# Check specific contract
cast call $HERO_ADDRESS "tokenURI(uint256)" 1 --rpc-url http://localhost:8545
```

## Advanced Features

### Avatar System Upgrades

The HeroSVGRenderer supports avatar library upgrades:

```solidity
// Upgrade avatar library (owner only)
heroSVGRenderer.setHeroAvatarLib(newLibraryAddress);
```

### ERC-6551 Token Bound Accounts

Every hero NFT has an associated token bound account:

```solidity
// Get hero's token bound account
address account = heroContract.getTokenBoundAccount(tokenId);
```

### Cross-Contract Integration

All contracts are fully integrated:

- ForgeCoordinator orchestrates cross-contract calls
- Registry pattern enables modular effect system
- Hook system provides lifecycle extension points
- Treasury handles all fee distribution

## Gas Optimization

- **Unified Deployment**: Single broadcast session reduces transaction overhead
- **External Libraries**: Separate deployment of large libraries
- **Efficient Dependencies**: Optimal deployment order minimizes gas costs
- **Batched Operations**: Registry operations batched for efficiency

## Security Considerations

- **Access Controls**: All contracts use OpenZeppelin Ownable pattern
- **Input Validation**: Comprehensive validation before deployment
- **Dependency Verification**: Ensures no broken contract references
- **Immutable References**: Core addresses stored as immutable where appropriate
- **External Library Safety**: Interface-based library calls with address validation

## Troubleshooting

### Common Issues

1. **"InvalidAddress" errors**: Check that all dependencies are deployed first
2. **"Contract size limit" warnings**: External libraries solve this automatically
3. **"Insufficient gas" errors**: Use higher gas limit for complex phases
4. **Network configuration errors**: Verify RPC URL and chain ID

### Recovery and Debugging

```bash
# Check what failed during deployment
forge script script/WorkingDeploy.sol:WorkingDeploy --rpc-url $RPC_URL -vvv

# Verify specific contract deployment
cast code $CONTRACT_ADDRESS --rpc-url $RPC_URL

# Check deployment JSON
cat ./deployments/31337.json | jq '.'
```

### Development Workflow

```bash
# Complete development setup
make dev-setup

# Deploy and verify in one command
make deploy-and-verify

# Quick test deployment
make start-local-node && make deploy-local
```

## Testing

### Local Testing

```bash
# Start local node
anvil --chain-id 31337 --accounts 10 --balance 10000

# Deploy all contracts
make deploy-local

# Run integration tests
forge test --match-contract CompleteForgeFlowTest -vv

# Test specific functionality
make mint-local
make check-stats
```

### Testnet Deployment

```bash
# Deploy to Sepolia
export SEPOLIA_RPC_URL="https://sepolia.infura.io/v3/YOUR_KEY"
export PRIVATE_KEY="your_private_key"
export ETHERSCAN_API_KEY="your_etherscan_key"

make deploy-sepolia
```

## Migration Guide

### From Old Modular System

If migrating from the previous modular deployment system:

1. Remove old deployment contracts from `/deploy` folder
2. Update scripts to use `script/WorkingDeploy.sol`
3. Update Makefile commands to use new targets
4. Test deployment on local network first

### Upgrade Considerations

- Avatar library can be upgraded without redeploying main contracts
- Registry contracts support adding new implementations
- Hook system allows adding new analytics without core changes

## License

MIT License - see LICENSE file for details.

---

_This deployment system successfully deploys all 24 Solo Ascend contracts with full verification and cross-contract integration._

---

# 🎨 Hero Trait Registration System

## Overview

The trait system uses a dynamic approach to avoid Solidity compilation stack overflow issues with large SVG data. Instead of hardcoding SVG data in contracts, we:

1. Pre-generated trait data files stored in `script/data/` directory
2. Use `vm.readFile()` in deployment scripts to read external data
3. Register traits dynamically using individual registration scripts

## Trait Registration Process

### Pre-generated Trait Data Files

The system includes pre-generated trait data files in `script/data/` containing complete SVG data:

- 📁 3 background traits (Forest Dawn, Basalt Lavafield, Cavern Torchlight)
- 👤 3 base character traits (Human, Elf, Undead)
- 👀 3 eye traits (Blue Spark, Red Glow, Void Black)
- 👄 3 mouth traits (Grit Teeth, Simple Smile, Surprised Open)
- 👔 3 body traits (Cloth Tunic, Iron Cuirass, Gold Robe Runes)
- 💇 3 hair/hat traits (Green Hood, Short Brown Hair, Silver Long Hair)
- 👖 3 leg traits (Cloth Pants, Iron Greaves, Robe Tails Blue)
- 👟 3 foot traits (Leather Boots, Iron Sabatons, Gold Rune Shoes)
- 🎭 3 face features (Blue Tattoo, Scar Cheek, Warpaint Red)
- 👓 3 glasses traits (Monocle, Round Glasses, Square Goggles)
- ⚔️ 27 weapon traits per class (3 weapon types × 3 stages × 8 classes)
  - Warrior: Longsword, Shield & Sword, Warhammer
  - Mage: Crystal Staff, Orb Focus, Spellbook
  - Archer: Longbow, Crossbow, Quiver Set
  - Rogue: Twin Daggers, Shortsword, Throwing Stars
  - Paladin: Sacred Hammer, Sword & Shield Holy, Relic Sigil
  - Summoner: Summon Staff, Pact Tome, Bone Bell
  - Berserker: Great Axe, Berserker Sword, Spiked Club
  - Priest: Holy Staff, Holy Tome, Chalice

**Total: 93 trait data files covering all hero visual variations**

### Step 2: Register Traits Using Individual Scripts

Use the individual registration scripts in `script/individual_registration/`:

```bash
# Register background traits
forge script script/individual_registration/RegisterBackgroundTraits.sol:RegisterBackgroundTraits \
    --sig "run(address)" <TRAIT_REGISTRY_ADDRESS> \
    --rpc-url <RPC_URL> \
    --private-key <PRIVATE_KEY> \
    --broadcast

# Register base character traits
forge script script/individual_registration/RegisterBaseTraits.sol:RegisterBaseTraits \
    --sig "run(address)" <TRAIT_REGISTRY_ADDRESS> \
    --rpc-url <RPC_URL> \
    --private-key <PRIVATE_KEY> \
    --broadcast

# Register weapon traits for each class
forge script script/individual_registration/RegisterWarriorWeapons.sol:RegisterWarriorWeapons \
    --sig "run(address)" <TRAIT_REGISTRY_ADDRESS> \
    --rpc-url <RPC_URL> \
    --private-key <PRIVATE_KEY> \
    --broadcast

# Continue with other registration scripts...
```

Where `<TRAIT_REGISTRY_ADDRESS>` is the HeroTraitRegistry address from main deployment.

## Data File Structure

```
script/data/
├── background_*.txt           # Background layer traits
├── base_*.txt                 # Character base traits
├── eyes_*.txt                 # Eye traits
├── mouth_*.txt                # Mouth traits
├── body_*.txt                 # Body armor traits
├── hair_hat_*.txt            # Hair and hat traits
├── legs_*.txt                # Leg armor traits
├── foot_*.txt                # Footwear traits
├── face_feature_*.txt        # Optional face features (20% chance)
├── glasses_*.txt             # Optional glasses (20% chance)
└── weapon_*_*_stage*.txt     # Class-specific weapons with progression
```

## Trait System Features

### Layer System

- **Required layers** (100% appearance): BACKGROUND, BASE, EYES, MOUTH, HAIR_HAT, BODY, LEGS, FOOT, WEAPON
- **Optional layers** (20% chance): FACE_FEATURE, GLASSES

### Trait Snapshot System

- ✅ **Trait Stability**: Once minted, hero appearance never changes
- 🔒 **Snapshot Storage**: Trait combinations saved permanently in HeroMetadataRenderer
- 🆔 **1-Based IDs**: All trait IDs start from 1 (not 0) for snapshot detection
- 🎲 **Deterministic Generation**: Same seed always produces same hero

### Dynamic Registration Benefits

- 🚀 **No Stack Overflow**: External file reading avoids Solidity compilation limits
- 📦 **Complete Data**: Full SVG complexity preserved from traits-data.js
- 🔧 **Easy Updates**: Modify trait data without recompiling contracts
- 📊 **Scalable**: Supports unlimited trait additions

## Individual Registration Scripts

The `script/individual_registration/` directory contains specialized scripts for registering different trait categories:

### Layer Trait Registration Scripts

- `RegisterBackgroundTraits.sol` - Backgrounds (3 traits)
- `RegisterBaseTraits.sol` - Base characters (3 traits)
- `RegisterEyesTraits.sol` - Eye variations (3 traits)
- `RegisterMouthTraits.sol` - Mouth expressions (3 traits)
- `RegisterBodyTraits.sol` - Body armor (3 traits)
- `RegisterHairHatTraits.sol` - Hair and hats (3 traits)
- `RegisterLegsTraits.sol` - Leg armor (3 traits)
- `RegisterFootTraits.sol` - Footwear (3 traits)
- `RegisterFaceFeatureTraits.sol` - Optional face features (3 traits)
- `RegisterGlassesTraits.sol` - Optional glasses (3 traits)

### Weapon Registration Scripts (Per Class)

- `RegisterWarriorWeapons.sol` - Warrior weapons (9 traits)
- `RegisterMageWeapons.sol` - Mage weapons (9 traits)
- `RegisterArcherWeapons.sol` - Archer weapons (9 traits)
- `RegisterRogueWeapons.sol` - Rogue weapons (9 traits)
- `RegisterPaladinWeapons.sol` - Paladin weapons (9 traits)
- `RegisterSummonerWeapons.sol` - Summoner weapons (9 traits)
- `RegisterBerserkerWeapons.sol` - Berserker weapons (9 traits)
- `RegisterPriestWeapons.sol` - Priest weapons (9 traits)

## Trait Registration Troubleshooting

### Common Issues

1. **"NoActiveTraitsInLayer" Error**
   - **Cause**: No traits registered for required layers
   - **Solution**: Run TraitRegistryDynamicDeploy.sol to register traits

2. **File Reading Errors**
   - **Cause**: Missing trait data files in `/script/data/`
   - **Solution**: Run `node generate_trait_files.js` to create files

3. **SVG Rendering Issues**
   - **Cause**: Corrupted or malformed SVG data
   - **Solution**: Verify trait data files contain valid SVG markup

### Verification Commands

```bash
# Check trait registry has traits registered
cast call <TRAIT_REGISTRY_ADDRESS> "layerTraitsCounts(uint8)" 0  # BACKGROUND
cast call <TRAIT_REGISTRY_ADDRESS> "weaponTraitsCounts(uint8)" 0 # WARRIOR

# Verify data files exist
ls -la script/data/
wc -c script/data/base_human.txt  # Should show ~5,809 characters

# Test hero minting with traits
cast send <HERO_CONTRACT_ADDRESS> "mint()" --value 0.01ether --private-key <PRIVATE_KEY>
```

## Complete Deployment Flow

```bash
# 1. Deploy main contracts
make deploy-local

# 2. Register all traits (data files already exist in script/data/)
# Example for registering background traits:
forge script script/individual_registration/RegisterBackgroundTraits.sol:RegisterBackgroundTraits \
    --sig "run(address)" <TRAIT_REGISTRY_ADDRESS> \
    --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --broadcast

# Repeat for other trait registration scripts as needed...

# 3. Mint hero with traits
make mint-local
```

## Chainlink Oracle Support

For networks with Chainlink VRF support, update the oracle configuration:

```bash
forge script script/UpdateChainlinkOracle.sol:UpdateChainlinkOracle \
    --rpc-url <RPC_URL> \
    --private-key <PRIVATE_KEY> \
    --broadcast
```

The UpdateChainlinkOracle script will:

- Deploy a ChainlinkOracle contract configured for the network
- Register it with the OracleRegistry
- Set appropriate quality distributions for true randomness

The trait system provides millions of unique hero combinations with complete pixel art visuals!
