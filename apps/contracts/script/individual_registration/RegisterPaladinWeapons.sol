// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {HeroTraitRegistry} from "../../src/core/registries/HeroTraitRegistry.sol";
import {GameConstants} from "../../src/libraries/GameConstants.sol";

/// @title RegisterPaladinWeapons - Complete paladin weapon registration
contract RegisterPaladinWeapons is Script {
    function run(address traitRegistryAddress) external {
        require(traitRegistryAddress != address(0), "Invalid trait registry address");
        HeroTraitRegistry traitRegistry = HeroTraitRegistry(traitRegistryAddress);

        uint256 privateKey = vm.envOr(
            "PRIVATE_KEY",
            uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80)
        );

        vm.startBroadcast(privateKey);

        // Check current count to avoid duplicates
        uint256 currentCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.PALADIN);
        console.log("Current paladin weapons count:", currentCount);

        if (currentCount >= 3) {
            console.log("Paladin weapons already complete, skipping...");
            vm.stopBroadcast();
            return;
        }

        console.log("=== Completing Paladin Weapon Registration ===");

        // Register Sacred Hammer (1/3)
        if (currentCount < 1) {
            string memory stage1 = vm.readFile("script/data/weapon_paladin_sacred_hammer_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_paladin_sacred_hammer_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_paladin_sacred_hammer_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.PALADIN, stage1, stage2, stage3, "Sacred Hammer");
            console.log("Registered: Sacred Hammer");
        }

        // Register Holy Sword & Shield (2/3)
        if (currentCount < 2) {
            string memory stage1 = vm.readFile("script/data/weapon_paladin_sword_shield_holy_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_paladin_sword_shield_holy_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_paladin_sword_shield_holy_stage3.txt");

            traitRegistry.registerWeaponTrait(
                GameConstants.HeroClass.PALADIN,
                stage1,
                stage2,
                stage3,
                "Holy Sword & Shield"
            );
            console.log("Registered: Holy Sword & Shield");
        }

        // Register Relic Sigil (3/3)
        if (currentCount < 3) {
            string memory stage1 = vm.readFile("script/data/weapon_paladin_relic_sigil_stage1.txt");
            string memory stage2 = vm.readFile("script/data/weapon_paladin_relic_sigil_stage2.txt");
            string memory stage3 = vm.readFile("script/data/weapon_paladin_relic_sigil_stage3.txt");

            traitRegistry.registerWeaponTrait(GameConstants.HeroClass.PALADIN, stage1, stage2, stage3, "Relic Sigil");
            console.log("Registered: Relic Sigil");
        }

        vm.stopBroadcast();

        uint256 finalCount = traitRegistry.weaponTraitsCounts(GameConstants.HeroClass.PALADIN);
        console.log("Final paladin weapons count:", finalCount);
        console.log("=== Paladin Weapon Registration Completed ===");
    }
}
