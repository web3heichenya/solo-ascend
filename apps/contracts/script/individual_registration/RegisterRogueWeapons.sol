// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterRogueWeapons - Complete rogue weapon registration
contract RegisterRogueWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.ROGUE);
        console.log("Current rogue weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Rogue weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Rogue Weapon Registration ===");

        // Register Twin Daggers (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_rogue_twin_daggers_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_rogue_twin_daggers_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_rogue_twin_daggers_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ROGUE, stage1, stage2, stage3, "Twin Daggers");
            console.log("Registered: Twin Daggers");
        }

        // Register Throwing Stars (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_rogue_throwing_stars_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_rogue_throwing_stars_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_rogue_throwing_stars_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ROGUE, stage1, stage2, stage3, "Throwing Stars");
            console.log("Registered: Throwing Stars");
        }

        // Register Shortsword (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_rogue_shortsword_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_rogue_shortsword_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_rogue_shortsword_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ROGUE, stage1, stage2, stage3, "Shortsword");
            console.log("Registered: Shortsword");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.ROGUE);
        console.log("Final rogue weapons count:", finalCount);
        console.log("=== Rogue Weapon Registration Completed ===");
    }
}
