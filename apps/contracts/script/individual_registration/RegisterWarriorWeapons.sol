// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterWarriorWeapons - Complete warrior weapon registration
contract RegisterWarriorWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.WARRIOR);
        console.log("Current warrior weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Warrior weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Warrior Weapon Registration ===");

        // Register Longsword (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_warrior_longsword_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_warrior_longsword_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_warrior_longsword_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.WARRIOR, stage1, stage2, stage3, "Longsword");
            console.log("Registered: Longsword");
        }

        // Register Shield & Sword (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_warrior_shield_sword_set_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_warrior_shield_sword_set_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_warrior_shield_sword_set_stage3.txt");

            traitRegistry.registerWeaponTrait(
                GameConstants.HeroClass.WARRIOR,
                stage1,
                stage2,
                stage3,
                "Shield & Sword"
            );
            console.log("Registered: Shield & Sword");
        }

        // Register Warhammer (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_warrior_warhammer_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_warrior_warhammer_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_warrior_warhammer_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.WARRIOR, stage1, stage2, stage3, "Warhammer");
            console.log("Registered: Warhammer");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.WARRIOR);
        console.log("Final warrior weapons count:", finalCount);
        console.log("=== Warrior Weapon Registration Completed ===");
    }
}
