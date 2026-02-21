# Solo Ascend Technical Architecture

## Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [Contract Architecture](#contract-architecture)
- [Data Flow](#data-flow)
- [Security Architecture](#security-architecture)
- [Integration Points](#integration-points)
- [Performance Considerations](#performance-considerations)

## Overview

Solo Ascend is a sophisticated on-chain gaming protocol built on Ethereum using a modular architecture. The system combines multiple smart contracts, external oracles, and an extensible hook system to create a fully decentralized RPG experience.

### Design Principles

1. **Modularity**: Each component has a specific responsibility and can be upgraded independently
2. **Extensibility**: Hook system allows for future enhancements without core contract changes
3. **Security**: Multi-layered security with fail-safes and economic protections
4. **Gas Efficiency**: Optimized storage patterns and computation strategies
5. **Decentralization**: No single points of failure or centralized control

## System Architecture

### High-Level Component Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Solo Ascend Protocol                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │   Frontend  │    │   Oracles   │    │   Hooks     │             │
│  │             │    │             │    │             │             │
│  │ • Web App   │◄──►│ • Chainlink │◄──►│ • Analytics │             │
│  │ • Mobile    │    │   VRF       │    │ • Custom    │             │
│  │ • Game UI   │    │ • Simple    │    │   Logic     │             │
│  └─────────────┘    │   Oracle    │    │ • Future    │             │
│         │            └─────────────┘    │   Features  │             │
│         ▼                               └─────────────┘             │
│  ┌─────────────────────────────────────────────────────────────────┐ │
│  │                    Core Protocol                               │ │
│  │                                                               │ │
│  │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────┐ │ │
│  │ │    Hero     │ │   Forge     │ │  ForgeItem  │ │ Treasury  │ │ │
│  │ │   Contract  │ │ Coordinator │ │    NFTs     │ │           │ │ │
│  │ └─────────────┘ └─────────────┘ └─────────────┘ └───────────┘ │ │
│  │                                                               │ │
│  │ ┌─────────────────────────────────────────────────────────────┐ │ │
│  │ │                   Registry System                          │ │ │
│  │ │                                                           │ │ │
│  │ │ ┌──────────┐┌──────────┐┌──────────┐┌──────────┐┌──────┐ │ │ │
│  │ │ │  Hero    ││  Forge   ││  Oracle  ││   Hook   ││ Item │ │ │ │
│  │ │ │  Class   ││  Effect  ││          ││          ││      │ │ │ │
│  │ │ │ Registry ││ Registry ││ Registry ││ Registry ││ Reg. │ │ │ │
│  │ │ └──────────┘└──────────┘└──────────┘└──────────┘└──────┘ │ │ │
│  │ └─────────────────────────────────────────────────────────────┘ │ │
│  │                                                               │ │
│  │ ┌─────────────────────────────────────────────────────────────┐ │ │
│  │ │                    Effect System                           │ │ │
│  │ │                                                           │ │ │
│  │ │ ┌──────────┐┌──────────┐┌──────────┐┌──────────┐┌──────┐ │ │ │
│  │ │ │Attribute ││ Amplify  ││  Mythic  ││ Enhance  ││  FT  │ │ │ │
│  │ │ │ Effect   ││  Effect  ││  Effect  ││  Effect  ││Effect│ │ │ │
│  │ │ └──────────┘└──────────┘└──────────┘└──────────┘└──────┘ │ │ │
│  │ └─────────────────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────────────┘ │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## Contract Architecture

### Core Contracts

#### SoloAscendHero.sol

**Purpose**: Main NFT contract representing game heroes

**Key Responsibilities**:

- Hero minting with one-per-address limit
- Attribute management and updates
- ERC-6551 token-bound account creation
- Daily forge eligibility validation
- On-chain metadata generation

**Storage Optimization**:

```solidity
struct Hero {
  address tokenBoundAccount; // 20 bytes
  uint64 lastForgeTime; // 8 bytes
  uint32 totalForges; // 4 bytes
  uint64 mintTime; // 8 bytes (total: 40 bytes, 2 slots)
  HeroClass classId; // 1 byte
  HeroStage stage; // 1 byte
  HeroAttributes attributes; // 30 bytes (fits in 1 slot)
}
```

#### ForgeCoordinator.sol

**Purpose**: Orchestrates the complete forging process

**Key Responsibilities**:

- Forge request initiation and tracking
- Oracle integration and randomness fulfillment
- Quality determination and effect selection
- Forge item NFT minting coordination
- Hook execution management

**State Management**:

```solidity
mapping(bytes32 => ForgeRequest) private _forgeRequests;
mapping(uint256 => bytes32) private _heroToPendingRequest;
mapping(uint256 => PendingEffect) private _pendingEffects;
```

#### ForgeItemNFT.sol

**Purpose**: NFT contract for forge items with quality-based mechanics

**Key Features**:

- Quality-based transferability (Silver/Gold are soulbound)
- Dynamic attribute effects on transfer
- Auto-destruction for certain effect types
- Integration with ForgeCoordinator via hooks

#### Treasury.sol

**Purpose**: Manages game revenue and reward distribution

**Key Features**:

- ETH and ERC-20 token management
- Reward distribution to players
- Owner-controlled fund management
- Integration with FT forge effects

### Registry System

#### HeroClassRegistry.sol

Manages hero classes and their base attributes:

```solidity
struct HeroClassData {
  string name;
  string description;
  HeroAttributes baseAttributes;
  uint64 createdAt;
}
```

#### ForgeEffectRegistry.sol

Manages forge effect types and their implementations:

- Effect type registration and authorization
- Quality-weight mappings for effect selection
- Effect implementation contract management

#### OracleRegistry.sol

Manages randomness oracles and quality determination:

- Oracle registration and authorization
- Fee calculation for different oracles
- Quality determination based on randomness

#### HookRegistry.sol

Manages the extensible hook system:

- Hook registration by phase
- Hook execution with gas limits
- Failure isolation (hooks cannot break main flow)

### Effect System

Each effect type implements the `IForgeEffect` interface:

```solidity
interface IForgeEffect {
  function generateEffect(
    uint256 randomSeed,
    GameConstants.ForgeQuality quality,
    uint256 totalForges
  ) external view returns (GameConstants.ForgeEffect memory);

  function executeEffect(uint256 heroId, GameConstants.ForgeEffect memory effect, uint256 effectId) external;
}
```

#### AttributeForgeEffect

- Permanently increases specific hero attributes
- Values scale with quality tier
- Creates soulbound or tradeable items based on quality

#### AmplifyForgeEffect

- Provides percentage boost to all hero attributes
- Transitions hero to COMPLETED stage (no more daily forging)
- Guaranteed at 50th forge for non-SOLO_LEVELING heroes

#### MythicForgeEffect

- Enables SOLO_LEVELING stage for infinite progression
- Extremely rare (typically <1% chance)
- Mints tradeable Mythic quality items

#### EnhanceForgeEffect

- Creates two additional attribute forge items
- Provides immediate benefit plus future forge items
- Auto-destructs after execution

#### FTForgeEffect

- Distributes treasury tokens to player
- Reward amount based on quality tier
- Integrates with Treasury contract

## Data Flow

### Hero Minting Flow

```
User → SoloAscendHero.mint()
  ├── Validate: not already minted, sufficient payment
  ├── Execute: BEFORE_HERO_MINTING hook
  ├── Generate: random class selection
  ├── Create: hero data structure with base attributes
  ├── Mint: ERC-721 NFT
  ├── Deploy: ERC-6551 token-bound account
  ├── Transfer: treasury fee
  ├── Execute: AFTER_HERO_MINTED hook
  └── Emit: HeroMinted event
```

### Daily Forge Flow

```
User → SoloAscendHero.performDailyForge()
  ├── Validate: hero exists, cooldown passed, no pending forge
  ├── Forward: ForgeCoordinator.initiateForgeAndRequestAuto()
  │   ├── Generate: unique request ID
  │   ├── Store: forge request data
  │   ├── Execute: FORGE_INITIATION hook
  │   └── Request: oracle randomness
  │
Oracle → ForgeCoordinator.fulfillForge()
  ├── Validate: request exists, authorized oracle
  ├── Execute: BEFORE_EFFECT_GENERATION hook
  ├── Determine: forge quality from randomness
  ├── Select: effect type based on weights and rules
  ├── Generate: effect implementation contract call
  ├── Mint: forge item NFT to appropriate recipient
  ├── Execute: effect logic (attribute updates, stage changes)
  ├── Execute: AFTER_EFFECT_GENERATED hook
  ├── Execute: HERO_ATTRIBUTE_UPDATED hook (if attributes changed)
  ├── Execute: HERO_STAGE_CHANGED hook (if stage changed)
  └── Emit: ForgeCompleted event
```

### Forge Item Lifecycle

```
ForgeCoordinator.mintForgeItem()
  ├── Determine: mint destination based on effect type
  ├── Store: pending effect data
  ├── Mint: ForgeItemNFT to recipient
  └── Trigger: ForgeCoordinator.handleForgeItemUpdate()
      ├── Minting (to TBA): Apply attribute effects immediately
      ├── Transfer (between TBAs): Update attributes dynamically
      └── Burning (auto-destruction): Execute remaining effects
```

## Security Architecture

### Access Control Matrix

| Contract         | Admin             | Hero Contract  | Forge Coordinator | Oracle        | Effect Contract  |
| ---------------- | ----------------- | -------------- | ----------------- | ------------- | ---------------- |
| SoloAscendHero   | Owner functions   | -              | Attribute updates | -             | -                |
| ForgeCoordinator | Set hero contract | Initiate forge | -                 | Fulfill forge | Hero updates     |
| ForgeItemNFT     | Owner functions   | -              | Handle updates    | -             | -                |
| Registries       | Owner functions   | -              | -                 | -             | Register effects |

### Security Measures

#### Reentrancy Protection

- All external calls protected with `ReentrancyGuard`
- State changes before external calls
- Fail-safe patterns for hook execution

#### Economic Protection

- Daily forge cooldown prevents spam
- One mint per address prevents Sybil attacks
- Oracle fees prevent economic attacks
- Supply caps on special items

#### Oracle Security

- Multiple oracle support reduces single point of failure
- Request validation prevents replay attacks
- Authorized oracle list prevents manipulation

#### Hook System Security

- Hook execution isolated with try-catch
- Gas limits prevent DOS attacks
- Failed hooks don't break main operations
- Authorization required for hook registration

### Attack Vector Mitigation

#### Flash Loan Attacks

- Cooldown periods prevent rapid exploitation
- One-mint-per-address rule prevents account farming
- State changes committed before external calls

#### Front-Running

- Commit-reveal not needed due to oracle randomness
- MEV protection through proper transaction ordering
- Fair distribution through randomness

#### Economic Attacks

- Treasury fee ensures protocol sustainability
- Forge costs prevent spam attacks
- Quality distributions balance economy

## Integration Points

### ERC-6551 Token-Bound Accounts

```solidity
// Each hero gets a dedicated smart contract wallet
IERC6551Registry registry = IERC6551Registry(ERC6551_REGISTRY);
address account = registry.createAccount(
    ERC6551_IMPLEMENTATION,
    salt,
    block.chainid,
    address(this),
    tokenId
);
```

**Benefits**:

- Heroes can own forge items directly
- Enable complex item interactions
- Future expansion for hero-to-hero trading
- Composability with other protocols

### Chainlink VRF Integration

```solidity
function requestRandomness(bytes32 requestId, uint256 heroId, address requester, uint32 gasLimit) external payable {
  uint256 requestId = COORDINATOR.requestRandomWords(keyHash, subscriptionId, requestConfirmations, gasLimit, 1);
}
```

**Features**:

- Verifiable randomness for fair forge outcomes
- Gas limit protection against DOS
- Multiple oracle support for redundancy

### Hook System Integration

```solidity
enum HookPhase {
  BEFORE_HERO_MINTING, // Before hero minting
  AFTER_HERO_MINTED, // After hero minted
  BEFORE_EFFECT_GENERATION, // Before effect generation
  AFTER_EFFECT_GENERATED, // After effect generated
  FORGE_INITIATION, // Before forge initiation
  HERO_STAGE_CHANGED, // Hero stage changed
  HERO_ATTRIBUTE_UPDATED // Hero attribute updated
}
```

**Capabilities**:

- Hero lifecycle tracking and analytics
- Custom minting and forging logic
- Attribute and stage change monitoring
- Community-driven feature extensions
- A/B testing for game mechanics
- Real-time statistics and metrics collection

#### Hook System Usage Examples

##### Analytics Hook

```solidity
contract ForgeAnalyticsHook is IHook {
  mapping(address => uint256) public mintCounts;
  mapping(GameConstants.HeroClass => uint256) public classCounts;

  function execute(HookPhase phase, bytes calldata data) external override {
    if (phase == HookPhase.AFTER_HERO_MINTED) {
      (uint256 tokenId, GameConstants.HeroClass classId, address owner, address tba) = abi.decode(
        data,
        (uint256, GameConstants.HeroClass, address, address)
      );

      mintCounts[owner]++;
      classCounts[classId]++;
      emit HeroMintTracked(owner, tokenId, classId);
    }

    if (phase == HookPhase.HERO_ATTRIBUTE_UPDATED) {
      (uint256 heroId, GameConstants.HeroAttributes memory attrs) = abi.decode(
        data,
        (uint256, GameConstants.HeroAttributes)
      );

      emit AttributeUpdateTracked(heroId, attrs.hp, attrs.ad);
    }
  }
}
```

##### Custom Logic Hook

```solidity
contract BonusRewardHook is IHook {
  ITreasury public treasury;

  function execute(HookPhase phase, bytes calldata data) external override {
    if (phase == HookPhase.FORGE_INITIATION) {
      (bytes32 requestId, uint256 heroId, uint256 oracleId, address requester) = abi.decode(
        data,
        (bytes32, uint256, uint256, address)
      );

      // Give bonus reward for 10th forge
      GameConstants.Hero memory hero = ISoloAscendHero(heroContract).getHero(heroId);
      if (hero.totalForges == 10) {
        treasury.distributeReward(requester, 500); // 5% bonus
      }
    }
  }
}
```

## Performance Considerations

### Gas Optimization Strategies

#### Storage Packing

- Hero attributes packed into 30-byte struct (1 storage slot)
- Forge request data optimized for minimal storage
- Bit packing for boolean flags and enums

#### Computation Efficiency

- Unchecked arithmetic where overflow is impossible
- Loop unrolling for attribute operations
- Minimal external calls during forge process

#### Batch Operations

- Multiple forge items can be generated in single transaction
- Batch hook execution where applicable
- Efficient registry lookups with mappings

### Scalability Considerations

#### State Growth Management

- Automatic cleanup of fulfilled forge requests
- Temporary storage for pending effects
- Efficient data structures for lookups

#### Network Congestion Handling

- Configurable gas limits for oracle requests
- Priority queuing for time-sensitive operations
- Fallback mechanisms for oracle failures

### Monitoring and Observability

#### Event Logging

- Comprehensive event emission for all state changes
- Structured data for analytics and monitoring
- Error events for debugging and support

#### Metrics Collection

- Gas usage tracking per operation type
- Success rates for forge operations
- Quality distribution monitoring

#### Health Checks

- Oracle availability monitoring
- Treasury balance tracking
- System-wide health indicators

## Deployment Architecture

### Environment Management

- **Local**: Anvil with mock oracles for development
- **Testnet**: Sepolia with Chainlink VRF testnet
- **Mainnet**: Ethereum with production Chainlink VRF

### Upgrade Strategy

- Registry pattern allows component upgrades
- Hook system enables feature additions
- Proxy patterns for critical infrastructure

### Configuration Management

```solidity
struct DeployConfig {
  address admin;
  address[] oracles;
  uint256[] oracleWeights;
  address erc6551Registry;
  address erc6551Implementation;
  HeroClassData[] heroClasses;
}
```

This technical architecture provides a robust foundation for a decentralized gaming protocol while maintaining flexibility for future enhancements and community-driven development.
