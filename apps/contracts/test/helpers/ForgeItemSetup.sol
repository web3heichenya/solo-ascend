// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ForgeItemRegistry} from "../../src/core/registries/ForgeItemRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";
import {MockForgeItemNFT} from "../mocks/MockForgeItemNFT.sol";
import {ForgeItemNFT} from "../../src/core/ForgeItemNFT.sol";

/// @title ForgeItemSetup
/// @notice Helper library for setting up forge item contracts in tests
library ForgeItemSetup {
    /// @notice Setup default forge item contracts for all qualities
    /// @param registry The ForgeItemRegistry to setup
    /// @param forgeEffectRegistry Address of the ForgeEffectRegistry
    /// @param forgeCoordinator Address of the ForgeCoordinator
    function setupDefaultForgeItemContracts(
        ForgeItemRegistry registry,
        address forgeEffectRegistry,
        address forgeCoordinator
    ) internal {
        // Create mock forge item contracts for each quality
        MockForgeItemNFT silverContract = new MockForgeItemNFT(
            "Silver Forge Items",
            "SFI",
            forgeEffectRegistry,
            forgeCoordinator
        );

        MockForgeItemNFT goldContract = new MockForgeItemNFT(
            "Gold Forge Items",
            "GFI",
            forgeEffectRegistry,
            forgeCoordinator
        );

        MockForgeItemNFT rainbowContract = new MockForgeItemNFT(
            "Rainbow Forge Items",
            "RFI",
            forgeEffectRegistry,
            forgeCoordinator
        );

        MockForgeItemNFT mythicContract = new MockForgeItemNFT(
            "Mythic Forge Items",
            "MFI",
            forgeEffectRegistry,
            forgeCoordinator
        );

        // Register contracts with registry
        registry.registerForgeItemContract(GameConstants.ForgeQuality.SILVER, address(silverContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.GOLD, address(goldContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.RAINBOW, address(rainbowContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.MYTHIC, address(mythicContract));
    }

    /// @notice Setup real forge item contracts for all qualities (no mocks)
    /// @param registry The ForgeItemRegistry to setup
    /// @param admin Admin address for the contracts
    /// @param forgeEffectRegistry Address of the ForgeEffectRegistry
    /// @param forgeCoordinator Address of the ForgeCoordinator
    function setupRealForgeItemContracts(
        ForgeItemRegistry registry,
        address admin,
        address forgeEffectRegistry,
        address forgeCoordinator
    ) internal {
        // Create real forge item contracts for each quality
        ForgeItemNFT silverContract = new ForgeItemNFT(
            "Silver Forge Items",
            "SFI",
            GameConstants.ForgeQuality.SILVER,
            admin,
            forgeEffectRegistry,
            forgeCoordinator
        );

        ForgeItemNFT goldContract = new ForgeItemNFT(
            "Gold Forge Items",
            "GFI",
            GameConstants.ForgeQuality.GOLD,
            admin,
            forgeEffectRegistry,
            forgeCoordinator
        );

        ForgeItemNFT rainbowContract = new ForgeItemNFT(
            "Rainbow Forge Items",
            "RFI",
            GameConstants.ForgeQuality.RAINBOW,
            admin,
            forgeEffectRegistry,
            forgeCoordinator
        );

        ForgeItemNFT mythicContract = new ForgeItemNFT(
            "Mythic Forge Items",
            "MFI",
            GameConstants.ForgeQuality.MYTHIC,
            admin,
            forgeEffectRegistry,
            forgeCoordinator
        );

        // Register contracts with registry
        registry.registerForgeItemContract(GameConstants.ForgeQuality.SILVER, address(silverContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.GOLD, address(goldContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.RAINBOW, address(rainbowContract));
        registry.registerForgeItemContract(GameConstants.ForgeQuality.MYTHIC, address(mythicContract));
    }
}
