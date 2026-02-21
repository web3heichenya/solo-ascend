// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {DeployConfig} from "./DeployConfig.sol";

// All contracts to deploy directly
import {Treasury} from "../src/core/Treasury.sol";
import {HeroMetadataRenderer} from "../src/utils/HeroMetadataRenderer.sol";
import {HeroTraitRegistry} from "../src/core/registries/HeroTraitRegistry.sol";

// Registry contracts
import {HeroClassRegistry} from "../src/core/registries/HeroClassRegistry.sol";
import {ForgeEffectRegistry} from "../src/core/registries/ForgeEffectRegistry.sol";
import {OracleRegistry} from "../src/core/registries/OracleRegistry.sol";
import {HookRegistry} from "../src/core/registries/HookRegistry.sol";
import {ForgeItemRegistry} from "../src/core/registries/ForgeItemRegistry.sol";

// Effect contracts
import {AttributeForgeEffect} from "../src/effects/AttributeForgeEffect.sol";
import {AmplifyForgeEffect} from "../src/effects/AmplifyForgeEffect.sol";
import {EnhanceForgeEffect} from "../src/effects/EnhanceForgeEffect.sol";
import {MythicForgeEffect} from "../src/effects/MythicForgeEffect.sol";
import {NFTForgeEffect} from "../src/effects/NFTForgeEffect.sol";
import {FTForgeEffect} from "../src/effects/FTForgeEffect.sol";

// Oracle contracts
import {SimpleOracle} from "../src/oracles/SimpleOracle.sol";
import {ChainlinkVRFDirectOracle} from "../src/oracles/ChainlinkVRFDirectOracle.sol";

// ForgeItem NFT contracts
import {ForgeItemNFT} from "../src/core/ForgeItemNFT.sol";

// Main contracts
import {ForgeCoordinator} from "../src/core/ForgeCoordinator.sol";
import {SoloAscendHero} from "../src/core/SoloAscendHero.sol";

// Hook contracts
import {ForgeAnalyticsHook} from "../src/hooks/ForgeAnalyticsHook.sol";

// Libraries
import {GameConstants} from "../src/libraries/GameConstants.sol";
import {IHookRegistry} from "../src/interfaces/IHookRegistry.sol";

/// @title WorkingDeploy - Solo Ascend Complete Deployment Script
/// @author Solo Ascend Team
/// @notice Unified deployment script that replaces modular architecture to avoid nested broadcast issues
/// @dev Deploys all Solo Ascend contracts in a single transaction session with proper dependency ordering
contract WorkingDeploy is Script {
    struct DeployedContracts {
        // Core
        Treasury treasury;
        HeroTraitRegistry traitRegistry;
        HeroMetadataRenderer metadataRenderer;
        // Registries
        HeroClassRegistry heroClassRegistry;
        ForgeEffectRegistry forgeEffectRegistry;
        OracleRegistry oracleRegistry;
        HookRegistry hookRegistry;
        ForgeItemRegistry forgeItemRegistry;
        // Effects
        AttributeForgeEffect attributeForgeEffect;
        AmplifyForgeEffect amplifyForgeEffect;
        EnhanceForgeEffect enhanceForgeEffect;
        MythicForgeEffect mythicForgeEffect;
        // NFTForgeEffect nftForgeEffect;
        FTForgeEffect ftForgeEffect;
        // Oracles
        SimpleOracle simpleOracle;
        ChainlinkVRFDirectOracle chainlinkOracle;
        // ForgeItem NFTs
        ForgeItemNFT silverForgeItemNFT;
        ForgeItemNFT goldForgeItemNFT;
        ForgeItemNFT rainbowForgeItemNFT;
        ForgeItemNFT mythicForgeItemNFT;
        // Main contracts
        ForgeCoordinator forgeCoordinator;
        SoloAscendHero heroContract;
        // Hooks
        ForgeAnalyticsHook forgeAnalyticsHook;
    }

    DeployedContracts public deployed;
    DeployConfig.NetworkConfig public config;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        MAIN DEPLOYMENT                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Main deployment function - executes all deployment phases in correct order
    /// @dev This function coordinates the complete Solo Ascend deployment process
    function run() external {
        console.log("=== Solo Ascend Complete Deployment ===");

        // Initialize deployment configuration
        config = DeployConfig.getCurrentNetworkConfig();
        console.log("Network:", config.name);
        console.log("Admin:", config.admin);

        // Setup deployer account
        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );
        address deployer = vm.addr(privateKey);
        console.log("Deployer:", deployer);

        require(deployer == config.admin, "Deployer must match admin");

        // Start single broadcast session (avoids nested broadcast issues)
        vm.startBroadcast(privateKey);

        console.log("Starting deployment phases...");

        // ========== PHASE 01: CORE INFRASTRUCTURE ==========
        _phase01_DeployCore();

        // ========== PHASE 02: REGISTRY CONTRACTS ==========
        _phase02_DeployRegistries();

        // ========== PHASE 03: UTILITY CONTRACTS ==========
        _phase03_DeployUtilities();

        // ========== PHASE 04: GAME MECHANICS ==========
        _phase04_DeployGameMechanics();

        // ========== PHASE 05: MAIN CONTRACTS ==========
        _phase05_DeployMainContracts();

        // ========== PHASE 06: INTEGRATION & HOOKS ==========
        _phase06_DeployIntegration();

        // ========== PHASE 07: CONFIGURATION ==========
        _phase07_ConfigureSystem();

        vm.stopBroadcast();

        // Post-deployment verification and saving
        _verifyDeployment();
        _saveDeploymentAddresses();

        console.log("=== Solo Ascend Deployment Completed Successfully ===");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      PHASE 01: CORE                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 01: Deploy core infrastructure contracts
    /// @dev Deploys fundamental contracts that serve as foundation for the entire system
    function _phase01_DeployCore() internal {
        console.log("========== PHASE 01: DEPLOYING CORE INFRASTRUCTURE ==========");

        // Deploy Treasury - Central treasury for managing protocol fees and rewards
        console.log("01.1 Deploying Treasury...");
        deployed.treasury = new Treasury(config.admin);
        console.log("     Treasury deployed at:", address(deployed.treasury));
        console.log("     Treasury bytecode length:", address(deployed.treasury).code.length);

        // Deploy HeroTraitRegistry - Registry for hero trait layers
        console.log("01.2 Deploying HeroTraitRegistry...");
        deployed.traitRegistry = new HeroTraitRegistry(config.admin);
        console.log("     HeroTraitRegistry deployed at:", address(deployed.traitRegistry));
        console.log("     HeroTraitRegistry bytecode length:", address(deployed.traitRegistry).code.length);

        console.log("========== PHASE 01 COMPLETED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    PHASE 02: REGISTRIES                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 02: Deploy registry contracts for system components
    /// @dev Deploys all registry contracts that manage different aspect of the game
    function _phase02_DeployRegistries() internal {
        console.log("========== PHASE 02: DEPLOYING REGISTRY CONTRACTS ==========");

        // Deploy Hero Class Registry - Manages hero class definitions and metadata
        console.log("02.1 Deploying HeroClassRegistry...");
        deployed.heroClassRegistry = new HeroClassRegistry(config.admin);
        console.log("     HeroClassRegistry deployed at:", address(deployed.heroClassRegistry));

        // Deploy Forge Effect Registry - Manages forge effect types and implementations
        console.log("02.2 Deploying ForgeEffectRegistry...");
        deployed.forgeEffectRegistry = new ForgeEffectRegistry(config.admin);
        console.log("     ForgeEffectRegistry deployed at:", address(deployed.forgeEffectRegistry));

        // Deploy Oracle Registry - Manages randomness oracle providers
        console.log("02.3 Deploying OracleRegistry...");
        deployed.oracleRegistry = new OracleRegistry(config.admin);
        console.log("     OracleRegistry deployed at:", address(deployed.oracleRegistry));

        // Deploy Hook Registry - Manages system hooks and event listeners
        console.log("02.4 Deploying HookRegistry...");
        deployed.hookRegistry = new HookRegistry(config.admin);
        console.log("     HookRegistry deployed at:", address(deployed.hookRegistry));

        // Deploy ForgeItem Registry - Manages ForgeItem NFT contracts by quality
        console.log("02.5 Deploying ForgeItemRegistry...");
        deployed.forgeItemRegistry = new ForgeItemRegistry(config.admin);
        console.log("     ForgeItemRegistry deployed at:", address(deployed.forgeItemRegistry));

        console.log("========== PHASE 02 COMPLETED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    PHASE 03: UTILITIES                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 03: Deploy utility contracts
    /// @dev Deploys utility contracts like SVG renderer and oracles that support game mechanics
    function _phase03_DeployUtilities() internal {
        console.log("========== PHASE 03: DEPLOYING UTILITY CONTRACTS ==========");

        // Deploy Hero Metadata Renderer - Generates dynamic SVG and metadata for hero NFTs
        console.log("03.1 Deploying HeroMetadataRenderer...");
        deployed.metadataRenderer = new HeroMetadataRenderer(
            config.admin,
            address(deployed.heroClassRegistry),
            address(deployed.traitRegistry)
        );
        console.log("     HeroMetadataRenderer deployed at:", address(deployed.metadataRenderer));
        console.log("     Connected to HeroClassRegistry:", address(deployed.heroClassRegistry));
        console.log("     Connected to HeroTraitRegistry:", address(deployed.traitRegistry));

        // Note: SimpleOracle will be deployed later in Phase 04 after ForgeCoordinator
        console.log("03.2 Note: SimpleOracle will be deployed after ForgeCoordinator in Phase 04");

        console.log("========== PHASE 03 COMPLETED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PHASE 04: GAME MECHANICS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 04: Deploy core game mechanics contracts
    /// @dev Deploys ForgeCoordinator and all forge effect implementations
    function _phase04_DeployGameMechanics() internal {
        console.log("========== PHASE 04: DEPLOYING GAME MECHANICS ==========");

        // Deploy Forge Coordinator - Central coordinator for all forging operations
        console.log("04.1 Deploying ForgeCoordinator...");
        deployed.forgeCoordinator = new ForgeCoordinator(
            config.admin,
            address(deployed.forgeEffectRegistry),
            address(deployed.forgeItemRegistry),
            address(deployed.oracleRegistry),
            address(deployed.hookRegistry),
            address(deployed.treasury)
        );
        console.log("     ForgeCoordinator deployed at:", address(deployed.forgeCoordinator));
        console.log("     Connected to registries and treasury");

        // Deploy SimpleOracle with ForgeCoordinator address
        console.log("04.2 Deploying SimpleOracle...");
        deployed.simpleOracle = new SimpleOracle(config.admin, address(deployed.forgeCoordinator));
        console.log("     SimpleOracle deployed at:", address(deployed.simpleOracle));

        // Deploy Chainlink VRF Direct Oracle if enabled
        console.log("04.3 Deploying ChainlinkVRFDirectOracle...");
        if (config.chainlinkVRF.enabled) {
            deployed.chainlinkOracle = new ChainlinkVRFDirectOracle(
                config.admin,
                config.chainlinkVRF.wrapper,
                address(deployed.forgeCoordinator)
            );
            console.log("     ChainlinkVRFDirectOracle deployed at:", address(deployed.chainlinkOracle));
            console.log("     Connected to VRF Wrapper:", config.chainlinkVRF.wrapper);
        } else {
            console.log("     ChainlinkVRF disabled for this network, skipping deployment");
        }

        // Deploy Attribute Forge Effect - Direct attribute modification
        console.log("04.4 Deploying AttributeForgeEffect...");
        deployed.attributeForgeEffect = new AttributeForgeEffect(config.admin, address(deployed.forgeCoordinator));
        console.log("     AttributeForgeEffect deployed at:", address(deployed.attributeForgeEffect));

        // Deploy Amplify Forge Effect - Percentage-based attribute amplification
        console.log("04.5 Deploying AmplifyForgeEffect...");
        deployed.amplifyForgeEffect = new AmplifyForgeEffect(config.admin, address(deployed.forgeCoordinator));
        console.log("     AmplifyForgeEffect deployed at:", address(deployed.amplifyForgeEffect));

        // Deploy Enhance Forge Effect - Specific attribute enhancement
        console.log("04.6 Deploying EnhanceForgeEffect...");
        deployed.enhanceForgeEffect = new EnhanceForgeEffect(config.admin, address(deployed.forgeCoordinator));
        console.log("     EnhanceForgeEffect deployed at:", address(deployed.enhanceForgeEffect));

        // Deploy Mythic Forge Effect - Rare mythic transformation
        console.log("04.7 Deploying MythicForgeEffect...");
        deployed.mythicForgeEffect = new MythicForgeEffect(config.admin, address(deployed.forgeCoordinator));
        console.log("     MythicForgeEffect deployed at:", address(deployed.mythicForgeEffect));

        // Deploy NFT Forge Effect - NFT reward effect
        // console.log("04.8 Deploying NFTForgeEffect...");
        // deployed.nftForgeEffect = new NFTForgeEffect(config.admin, address(deployed.forgeCoordinator));
        // console.log("     NFTForgeEffect deployed at:", address(deployed.nftForgeEffect));

        // Deploy ForgeItem NFTs for each quality tier
        console.log("04.9 Deploying ForgeItem NFTs...");
        _deployForgeItemNFTs();

        console.log("========== PHASE 04 COMPLETED ==========");
    }

    /// @notice Deploy ForgeItem NFT contracts for each quality tier
    /// @dev Creates separate NFT contracts for Silver, Gold, Rainbow, and Mythic quality items
    function _deployForgeItemNFTs() internal {
        // Deploy Silver ForgeItem NFT (70% probability)
        deployed.silverForgeItemNFT = new ForgeItemNFT(
            "Silver Forge Item",
            "SILVER",
            GameConstants.ForgeQuality.SILVER,
            config.admin,
            address(deployed.forgeEffectRegistry),
            address(deployed.forgeCoordinator)
        );
        console.log("     Silver ForgeItemNFT deployed at:", address(deployed.silverForgeItemNFT));

        // Deploy Gold ForgeItem NFT (20% probability)
        deployed.goldForgeItemNFT = new ForgeItemNFT(
            "Gold Forge Item",
            "GOLD",
            GameConstants.ForgeQuality.GOLD,
            config.admin,
            address(deployed.forgeEffectRegistry),
            address(deployed.forgeCoordinator)
        );
        console.log("     Gold ForgeItemNFT deployed at:", address(deployed.goldForgeItemNFT));

        // Deploy Rainbow ForgeItem NFT (9% probability)
        deployed.rainbowForgeItemNFT = new ForgeItemNFT(
            "Rainbow Forge Item",
            "RAINBOW",
            GameConstants.ForgeQuality.RAINBOW,
            config.admin,
            address(deployed.forgeEffectRegistry),
            address(deployed.forgeCoordinator)
        );
        console.log("     Rainbow ForgeItemNFT deployed at:", address(deployed.rainbowForgeItemNFT));

        // Deploy Mythic ForgeItem NFT (1% probability)
        deployed.mythicForgeItemNFT = new ForgeItemNFT(
            "Mythic Forge Item",
            "MYTHIC",
            GameConstants.ForgeQuality.MYTHIC,
            config.admin,
            address(deployed.forgeEffectRegistry),
            address(deployed.forgeCoordinator)
        );
        console.log("     Mythic ForgeItemNFT deployed at:", address(deployed.mythicForgeItemNFT));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PHASE 05: MAIN CONTRACTS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 05: Deploy main game contracts
    /// @dev Deploys the core hero NFT contract and token effects
    function _phase05_DeployMainContracts() internal {
        console.log("========== PHASE 05: DEPLOYING MAIN CONTRACTS ==========");

        // Deploy Solo Ascend Hero Contract - Main hero NFT with ERC-6551 token bound accounts
        console.log("05.1 Deploying SoloAscendHero...");
        deployed.heroContract = new SoloAscendHero(
            config.admin,
            address(deployed.heroClassRegistry),
            address(deployed.forgeCoordinator),
            address(deployed.forgeEffectRegistry),
            address(deployed.hookRegistry),
            address(deployed.treasury),
            config.erc6551Registry,
            config.erc6551Implementation,
            address(deployed.metadataRenderer)
        );
        console.log("     SoloAscendHero deployed at:", address(deployed.heroContract));
        console.log("     Connected to all registries and dependencies");
        console.log("     ERC-6551 Registry:", config.erc6551Registry);
        console.log("     ERC-6551 Implementation:", config.erc6551Implementation);

        // Deploy FT Forge Effect - Fungible token reward effect (requires hero contract)
        console.log("05.2 Deploying FTForgeEffect...");
        deployed.ftForgeEffect = new FTForgeEffect(
            config.admin,
            address(deployed.treasury),
            address(deployed.heroContract),
            address(deployed.forgeCoordinator)
        );
        console.log("     FTForgeEffect deployed at:", address(deployed.ftForgeEffect));
        console.log("     Connected to Treasury and Hero Contract");

        console.log("========== PHASE 05 COMPLETED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                PHASE 06: INTEGRATION & HOOKS                 */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 06: Deploy integration and hook contracts
    /// @dev Deploys analytics hooks and other integration contracts
    function _phase06_DeployIntegration() internal {
        console.log("========== PHASE 06: DEPLOYING INTEGRATION & HOOKS ==========");

        // Deploy Forge Analytics Hook - Tracks forging events and analytics
        console.log("06.1 Deploying ForgeAnalyticsHook...");
        deployed.forgeAnalyticsHook = new ForgeAnalyticsHook(config.admin, address(deployed.forgeCoordinator));
        console.log("     ForgeAnalyticsHook deployed at:", address(deployed.forgeAnalyticsHook));
        console.log("     Connected to ForgeCoordinator for event tracking");

        console.log("========== PHASE 06 COMPLETED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                 PHASE 07: SYSTEM CONFIGURATION               */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Phase 07: Configure all system contracts and relationships
    /// @dev Registers all components in their respective registries and sets permissions
    function _phase07_ConfigureSystem() internal {
        console.log("========== PHASE 07: CONFIGURING SYSTEM ==========");

        // Step 1: Register all forge effect types in the registry
        console.log("07.1 Registering forge effect types...");
        _registerEffectTypes();

        // Step 2: Register oracle providers
        console.log("07.2 Registering oracle providers...");
        _registerOracles();

        // Step 3: Register ForgeItem NFT contracts by quality
        console.log("07.3 Registering ForgeItem NFT contracts...");
        _registerForgeItems();

        // Step 4: Register system hooks
        console.log("07.4 Registering system hooks...");
        _registerHooks();

        // Step 5: Configure cross-contract relationships
        console.log("07.5 Configuring contract relationships...");

        // Configure ForgeCoordinator with hero contract address
        deployed.forgeCoordinator.setHeroContract(address(deployed.heroContract));
        console.log("     ForgeCoordinator linked to Hero Contract");

        // Configure Treasury to authorize ForgeCoordinator as distributor
        deployed.treasury.setAuthorizedDistributor(address(deployed.forgeCoordinator), true);
        console.log("     Treasury authorized ForgeCoordinator as distributor");

        // Configure ForgeItemNFTs with ForgeCoordinator as authorized minter
        deployed.silverForgeItemNFT.setAuthorizedMinter(address(deployed.forgeCoordinator), true);
        deployed.goldForgeItemNFT.setAuthorizedMinter(address(deployed.forgeCoordinator), true);
        deployed.rainbowForgeItemNFT.setAuthorizedMinter(address(deployed.forgeCoordinator), true);
        deployed.mythicForgeItemNFT.setAuthorizedMinter(address(deployed.forgeCoordinator), true);
        console.log("     ForgeItem NFTs authorized ForgeCoordinator as minter");

        // Step 6: Traits are registered separately using modular scripts
        console.log("07.6 Trait registration completed via separate scripts");
        console.log(
            "     NOTE: Run TraitRegistryLayerDeploy.sol and TraitRegistryWeaponDeploy.sol scripts to register hero traits"
        );

        console.log("========== PHASE 07 COMPLETED ==========");
        console.log("========== ALL SYSTEM CONTRACTS DEPLOYED AND CONFIGURED ==========");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    CONFIGURATION FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Register all forge effect types in the ForgeEffectRegistry
    /// @dev Maps effect type IDs to their implementation contracts
    function _registerEffectTypes() internal {
        // Register Attribute Effect - Direct attribute modifications
        deployed.forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ATTRIBUTE,
            "Attribute",
            "Direct attribute modification effect",
            address(deployed.attributeForgeEffect)
        );
        console.log("     Registered Attribute ForgeEffect");

        // Register Amplify Effect - Percentage-based attribute amplifications
        deployed.forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.AMPLIFY,
            "Amplify",
            "Percentage-based attribute amplification",
            address(deployed.amplifyForgeEffect)
        );
        console.log("     Registered Amplify ForgeEffect");

        // Register Enhance Effect - Specific attribute enhancements
        deployed.forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.ENHANCE,
            "Enhance",
            "Specific attribute enhancement",
            address(deployed.enhanceForgeEffect)
        );
        console.log("     Registered Enhance ForgeEffect");

        // Register Mythic Effect - Rare mythic transformations
        deployed.forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.MYTHIC,
            "Mythic",
            "Rare mythic transformation",
            address(deployed.mythicForgeEffect)
        );
        console.log("     Registered Mythic ForgeEffect");

        // Register FT Effect - Fungible token rewards
        deployed.forgeEffectRegistry.registerEffectType(
            GameConstants.ForgeEffectType.FT,
            "Fungible Token",
            "Fungible token reward effect",
            address(deployed.ftForgeEffect)
        );
        console.log("     Registered FT ForgeEffect");

        // Register NFT Effect - Non-fungible token rewards
        // deployed.forgeEffectRegistry.registerEffectType(
        //     GameConstants.ForgeEffectType.NFT,
        //     "Non-Fungible Token",
        //     "NFT reward effect",
        //     address(deployed.nftForgeEffect)
        // );
        // console.log("     Registered NFT ForgeEffect");

        console.log("     All forge effect types registered successfully");
    }

    /// @notice Register oracle providers in the OracleRegistry
    /// @dev Configures oracle with quality distribution weights for random generation
    function _registerOracles() internal {
        // Setup quality distribution for forge items (based on rarity)
        GameConstants.ForgeQuality[] memory qualities = new GameConstants.ForgeQuality[](4);
        qualities[0] = GameConstants.ForgeQuality.SILVER; // Common tier
        qualities[1] = GameConstants.ForgeQuality.GOLD; // Uncommon tier
        qualities[2] = GameConstants.ForgeQuality.RAINBOW; // Rare tier
        qualities[3] = GameConstants.ForgeQuality.MYTHIC; // Legendary tier

        // ========== REGISTER SIMPLE ORACLE (ID: 1) ==========
        // Setup probability weights for SimpleOracle (total: 10000 = 100%)
        uint256[] memory simpleWeights = new uint256[](4);
        simpleWeights[0] = 10_000; // 100% - Silver
        simpleWeights[1] = 0; // 0% - Gold
        simpleWeights[2] = 0; // 0% - Rainbow
        simpleWeights[3] = 0; // 0% - Mythic

        // Register SimpleOracle as the primary oracle provider
        deployed.oracleRegistry.registerOracle(
            1, // Oracle ID
            "SimpleOracle",
            "Pseudo-random oracle for low-cost networks",
            address(deployed.simpleOracle),
            0, // Free oracle
            qualities,
            simpleWeights
        );

        console.log("     Registered SimpleOracle (ID: 1) with quality distribution:");
        console.log("     Silver: 100%, Gold: 0%, Rainbow: 0%, Mythic: 0%");

        // ========== REGISTER CHAINLINK ORACLE (ID: 2) ==========
        if (config.chainlinkVRF.enabled && address(deployed.chainlinkOracle) != address(0)) {
            // Setup probability weights for ChainlinkOracle
            uint256[] memory chainlinkWeights = new uint256[](4);
            chainlinkWeights[0] = 0; // 0% - Silver
            chainlinkWeights[1] = 6700; // 67% - Gold
            chainlinkWeights[2] = 3200; // 32% - Rainbow
            chainlinkWeights[3] = 100; // 1% - Mythic

            deployed.oracleRegistry.registerOracle(
                2, // Oracle ID
                "ChainlinkVRFDirectOracle",
                "Chainlink VRF v2.5 Direct Funding Oracle for verifiable randomness",
                address(deployed.chainlinkOracle),
                0, // Free oracle
                qualities,
                chainlinkWeights
            );

            console.log("     Registered ChainlinkVRFDirectOracle (ID: 2) with quality distribution:");
            console.log("     Silver: 0%, Gold: 70%, Rainbow: 35%, Mythic: 1%");
        } else {
            console.log("     ChainlinkVRF not enabled or not deployed, skipping registration");
        }
    }

    /// @notice Register ForgeItem NFT contracts in the ForgeItemRegistry
    /// @dev Maps each quality tier to its corresponding NFT contract
    function _registerForgeItems() internal {
        // Register Silver tier ForgeItem NFT
        deployed.forgeItemRegistry.registerForgeItemContract(
            GameConstants.ForgeQuality.SILVER,
            address(deployed.silverForgeItemNFT)
        );
        console.log("     Registered Silver ForgeItem NFT");

        // Register Gold tier ForgeItem NFT
        deployed.forgeItemRegistry.registerForgeItemContract(
            GameConstants.ForgeQuality.GOLD,
            address(deployed.goldForgeItemNFT)
        );
        console.log("     Registered Gold ForgeItem NFT");

        // Register Rainbow tier ForgeItem NFT
        deployed.forgeItemRegistry.registerForgeItemContract(
            GameConstants.ForgeQuality.RAINBOW,
            address(deployed.rainbowForgeItemNFT)
        );
        console.log("     Registered Rainbow ForgeItem NFT");

        // Register Mythic tier ForgeItem NFT
        deployed.forgeItemRegistry.registerForgeItemContract(
            GameConstants.ForgeQuality.MYTHIC,
            address(deployed.mythicForgeItemNFT)
        );
        console.log("     Registered Mythic ForgeItem NFT");

        console.log("     All ForgeItem NFT contracts registered successfully");
    }

    /// @notice Register system hooks in the HookRegistry
    /// @dev Configures analytics hooks for key game events
    function _registerHooks() internal {
        // Register analytics hook for before hero minting events
        deployed.hookRegistry.registerHook(
            IHookRegistry.HookPhase.BEFORE_HERO_MINTING,
            address(deployed.forgeAnalyticsHook),
            1, // priority (lower = higher priority)
            100_000 // gas limit for hook execution
        );
        console.log("     Registered analytics hook for BEFORE_HERO_MINTING");

        // Register analytics hook for after hero minted events
        deployed.hookRegistry.registerHook(
            IHookRegistry.HookPhase.AFTER_HERO_MINTED,
            address(deployed.forgeAnalyticsHook),
            1, // priority
            100_000 // gas limit
        );
        console.log("     Registered analytics hook for AFTER_HERO_MINTED");

        // Register analytics hook for forge initiation events
        deployed.hookRegistry.registerHook(
            IHookRegistry.HookPhase.FORGE_INITIATION,
            address(deployed.forgeAnalyticsHook),
            1, // priority
            100_000 // gas limit
        );
        console.log("     Registered analytics hook for FORGE_INITIATION");

        console.log("     All system hooks registered successfully");
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*              POST-DEPLOYMENT VERIFICATION                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Verify all contracts have been deployed successfully
    /// @dev Checks that all deployed contracts have non-zero bytecode
    function _verifyDeployment() internal view {
        console.log("========== VERIFYING DEPLOYMENT ==========");

        // Verify core contracts
        require(address(deployed.treasury).code.length > 0, "Treasury deployment failed");
        require(address(deployed.traitRegistry).code.length > 0, "HeroTraitRegistry deployment failed");
        console.log("Treasury and HeroTraitRegistry verified");

        // Verify registry contracts
        require(address(deployed.heroClassRegistry).code.length > 0, "HeroClassRegistry deployment failed");
        require(address(deployed.forgeEffectRegistry).code.length > 0, "ForgeEffectRegistry deployment failed");
        require(address(deployed.oracleRegistry).code.length > 0, "OracleRegistry deployment failed");
        require(address(deployed.hookRegistry).code.length > 0, "HookRegistry deployment failed");
        require(address(deployed.forgeItemRegistry).code.length > 0, "ForgeItemRegistry deployment failed");
        console.log("All registries verified");

        // Verify utility contracts
        require(address(deployed.metadataRenderer).code.length > 0, "HeroMetadataRenderer deployment failed");
        require(address(deployed.simpleOracle).code.length > 0, "SimpleOracle deployment failed");
        if (config.chainlinkVRF.enabled && address(deployed.chainlinkOracle) != address(0)) {
            require(address(deployed.chainlinkOracle).code.length > 0, "ChainlinkVRFDirectOracle deployment failed");
            console.log("Utility contracts verified (including ChainlinkOracle)");
        } else {
            console.log("Utility contracts verified (ChainlinkOracle skipped)");
        }

        // Verify game mechanics contracts
        require(address(deployed.forgeCoordinator).code.length > 0, "ForgeCoordinator deployment failed");
        require(address(deployed.attributeForgeEffect).code.length > 0, "AttributeForgeEffect deployment failed");
        require(address(deployed.amplifyForgeEffect).code.length > 0, "AmplifyForgeEffect deployment failed");
        require(address(deployed.enhanceForgeEffect).code.length > 0, "EnhanceForgeEffect deployment failed");
        require(address(deployed.mythicForgeEffect).code.length > 0, "MythicForgeEffect deployment failed");
        // require(address(deployed.nftForgeEffect).code.length > 0, "NFTForgeEffect deployment failed");
        console.log("Game mechanics contracts verified");

        // Verify ForgeItem NFTs
        require(address(deployed.silverForgeItemNFT).code.length > 0, "Silver ForgeItem deployment failed");
        require(address(deployed.goldForgeItemNFT).code.length > 0, "Gold ForgeItem deployment failed");
        require(address(deployed.rainbowForgeItemNFT).code.length > 0, "Rainbow ForgeItem deployment failed");
        require(address(deployed.mythicForgeItemNFT).code.length > 0, "Mythic ForgeItem deployment failed");
        console.log("ForgeItem NFT contracts verified");

        // Verify main contracts
        require(address(deployed.heroContract).code.length > 0, "SoloAscendHero deployment failed");
        require(address(deployed.ftForgeEffect).code.length > 0, "FTForgeEffect deployment failed");
        console.log("Main contracts verified");

        // Verify hooks
        require(address(deployed.forgeAnalyticsHook).code.length > 0, "ForgeAnalyticsHook deployment failed");
        console.log("Hook contracts verified");

        console.log("========== ALL CONTRACTS VERIFIED SUCCESSFULLY ==========");
    }

    /// @notice Save all deployed contract addresses to a JSON file
    /// @dev Creates a comprehensive deployment record for easy reference
    function _saveDeploymentAddresses() internal {
        console.log("========== SAVING DEPLOYMENT ADDRESSES ==========");

        string memory chainId = vm.toString(block.chainid);
        string memory filename = string(abi.encodePacked("./deployments/", chainId, ".json"));

        // Build comprehensive JSON with all deployed contracts
        string memory json = string(
            abi.encodePacked(
                "{",
                '"network":"',
                config.name,
                '",',
                '"chainId":',
                chainId,
                ",",
                '"deployer":"',
                vm.toString(config.admin),
                '",',
                '"timestamp":',
                vm.toString(block.timestamp),
                ",",
                '"contracts":{',
                // Core contracts
                '"treasury":"',
                vm.toString(address(deployed.treasury)),
                '",',
                '"traitRegistry":"',
                vm.toString(address(deployed.traitRegistry)),
                '",',
                // Registry contracts
                '"heroClassRegistry":"',
                vm.toString(address(deployed.heroClassRegistry)),
                '",',
                '"forgeEffectRegistry":"',
                vm.toString(address(deployed.forgeEffectRegistry)),
                '",',
                '"oracleRegistry":"',
                vm.toString(address(deployed.oracleRegistry)),
                '",',
                '"hookRegistry":"',
                vm.toString(address(deployed.hookRegistry)),
                '",',
                '"forgeItemRegistry":"',
                vm.toString(address(deployed.forgeItemRegistry)),
                '",',
                // Utility contracts
                '"metadataRenderer":"',
                vm.toString(address(deployed.metadataRenderer)),
                '",',
                '"simpleOracle":"',
                vm.toString(address(deployed.simpleOracle)),
                '",',
                // Add chainlinkOracle if deployed
                config.chainlinkVRF.enabled && address(deployed.chainlinkOracle) != address(0)
                    ? string(
                        abi.encodePacked('"chainlinkOracle":"', vm.toString(address(deployed.chainlinkOracle)), '",')
                    )
                    : "",
                // Game mechanics
                '"forgeCoordinator":"',
                vm.toString(address(deployed.forgeCoordinator)),
                '",',
                '"attributeForgeEffect":"',
                vm.toString(address(deployed.attributeForgeEffect)),
                '",',
                '"amplifyForgeEffect":"',
                vm.toString(address(deployed.amplifyForgeEffect)),
                '",',
                '"enhanceForgeEffect":"',
                vm.toString(address(deployed.enhanceForgeEffect)),
                '",',
                '"mythicForgeEffect":"',
                vm.toString(address(deployed.mythicForgeEffect)),
                '",',
                // '"nftForgeEffect":"',
                // vm.toString(address(deployed.nftForgeEffect)),
                // '",',
                '"ftForgeEffect":"',
                vm.toString(address(deployed.ftForgeEffect)),
                '",',
                // ForgeItem NFTs
                '"silverForgeItemNFT":"',
                vm.toString(address(deployed.silverForgeItemNFT)),
                '",',
                '"goldForgeItemNFT":"',
                vm.toString(address(deployed.goldForgeItemNFT)),
                '",',
                '"rainbowForgeItemNFT":"',
                vm.toString(address(deployed.rainbowForgeItemNFT)),
                '",',
                '"mythicForgeItemNFT":"',
                vm.toString(address(deployed.mythicForgeItemNFT)),
                '",',
                // Main contracts
                '"heroContract":"',
                vm.toString(address(deployed.heroContract)),
                '",',
                // Hooks
                '"forgeAnalyticsHook":"',
                vm.toString(address(deployed.forgeAnalyticsHook)),
                '"',
                "}}"
            )
        );

        vm.writeFile(filename, json);
        console.log("All deployment addresses saved to:", filename);
        string memory contractCount = config.chainlinkVRF.enabled ? "22" : "21";
        console.log("Deployment record contains", contractCount, "contract addresses");
        console.log("========== DEPLOYMENT ADDRESSES SAVED ==========");
    }
}
