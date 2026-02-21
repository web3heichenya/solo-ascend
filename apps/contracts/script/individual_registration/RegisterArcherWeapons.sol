// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterArcherWeapons - Complete archer weapon registration
contract RegisterArcherWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.ARCHER);
        console.log("Current archer weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Archer weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Archer Weapon Registration ===");

        // Register Longbow (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_archer_longbow_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_archer_longbow_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_archer_longbow_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ARCHER, stage1, stage2, stage3, "Longbow");
            console.log("Registered: Longbow");
        }

        // Register Crossbow (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_archer_crossbow_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_archer_crossbow_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_archer_crossbow_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ARCHER, stage1, stage2, stage3, "Crossbow");
            console.log("Registered: Crossbow");
        }

        // Register Quiver Set (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_archer_quiver_set_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_archer_quiver_set_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_archer_quiver_set_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.ARCHER, stage1, stage2, stage3, "Quiver Set");
            console.log("Registered: Quiver Set");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.ARCHER);
        console.log("Final archer weapons count:", finalCount);
        console.log("=== Archer Weapon Registration Completed ===");
    }
}
