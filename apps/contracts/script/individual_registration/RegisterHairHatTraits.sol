// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {IHeroTraitRegistry} from "../../src/interfaces/IHeroTraitRegistry.sol";

/// @title RegisterHairHatTraits - Complete hairhat trait registration
contract RegisterHairHatTraits is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.HAIR_HAT);
        console.log("Current hairhat traits count:", currentCount);

        if (currentCount >= 5) {
            console.log("HairHat traits already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing HairHat Trait Registration ===");

        // Register Green Hood (1/5)
        if (currentCount < 1) {
            string memory greenhoodData = vm.readFile("script/data/hair_hat_green_hood.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.HAIR_HAT, greenhoodData, "Green Hood");
            console.log("Registered: Green Hood");
        }

        // Register Short Brown Hair (2/5)
        if (currentCount < 2) {
            string memory shortbrownhairData = vm.readFile("script/data/hair_hat_short_brown_hair.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.HAIR_HAT,
                shortbrownhairData,
                "Short Brown Hair"
            );
            console.log("Registered: Short Brown Hair");
        }

        // Register Silver Long Hair (3/5)
        if (currentCount < 3) {
            string memory silverlonghairData = vm.readFile("script/data/hair_hat_silver_long_hair.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.HAIR_HAT,
                silverlonghairData,
                "Silver Long Hair"
            );
            console.log("Registered: Silver Long Hair");
        }

        // Register Royal Crown Hat (4/5)
        if (currentCount < 4) {
            string memory royalcrownhatData = vm.readFile("script/data/hair_hat_royal_crown_hat.txt");
            traitRegistry.registerLayerTrait(
                IHeroTraitRegistry.TraitLayer.HAIR_HAT,
                royalcrownhatData,
                "Royal Crown Hat"
            );
            console.log("Registered: Royal Crown Hat");
        }

        // Register Mohawk Red (5/5)
        if (currentCount < 5) {
            string memory mohawkredData = vm.readFile("script/data/hair_hat_mohawk_red.txt");
            traitRegistry.registerLayerTrait(IHeroTraitRegistry.TraitLayer.HAIR_HAT, mohawkredData, "Mohawk Red");
            console.log("Registered: Mohawk Red");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.layerTraitsCounts(IHeroTraitRegistry.TraitLayer.HAIR_HAT);
        console.log("Final hairhat traits count:", finalCount);
        console.log("=== HairHat Trait Registration Completed ===");
    }
}
