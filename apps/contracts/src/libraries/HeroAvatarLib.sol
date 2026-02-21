// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "./GameConstants.sol";

/// @title HeroAvatarLib
/// @notice Contract containing CryptoPunks-style SVG avatar data for different hero classes and stages
/// @author Solo Ascend Team
contract HeroAvatarLib {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get CryptoPunks-style avatar SVG for a hero based on class and stage
    /// @param classId Hero class ID (0-4: Warrior, Mage, Archer, Rogue, Paladin)
    /// @param stage Hero stage (FORGING, COMPLETED, SOLO_LEVELING)
    /// @return avatarSVG Complete SVG string for the full-body hero avatar with stage-specific equipment
    // solhint-disable-next-line use-natspec
    function getHeroAvatar(
        GameConstants.HeroClass classId,
        uint256 /* tokenId */,
        GameConstants.HeroStage stage
    ) external pure returns (string memory avatarSVG) {
        // Get CryptoPunks-style pixelated avatar with stage-specific upgrades
        return _getCryptoPunksStyleAvatar(classId, stage);
    }

    /// @notice Get CryptoPunks-style pixelated avatar for each class with stage progression
    /// @param classId Hero class ID
    /// @param stage Hero stage for visual upgrades
    /// @return avatar CryptoPunks-style full-body SVG avatar
    function _getCryptoPunksStyleAvatar(
        GameConstants.HeroClass classId,
        GameConstants.HeroStage stage
    ) private pure returns (string memory avatar) {
        if (classId == GameConstants.HeroClass.WARRIOR) {
            // Warrior - Pixelated knight with sword upgrades
            return _getCryptoPunksWarrior(stage);
        } else if (classId == GameConstants.HeroClass.MAGE) {
            // Mage - Pixelated wizard with staff upgrades
            return _getCryptoPunksMage(stage);
        } else if (classId == GameConstants.HeroClass.ARCHER) {
            // Archer - Pixelated ranger with bow upgrades
            return _getCryptoPunksArcher(stage);
        } else if (classId == GameConstants.HeroClass.ROGUE) {
            // Rogue - Pixelated assassin with dagger upgrades
            return _getCryptoPunksRogue(stage);
        } else if (classId == GameConstants.HeroClass.PALADIN) {
            // Paladin - Pixelated holy knight with sacred weapon upgrades
            return _getCryptoPunksPaladin(stage);
        }
        return _getCryptoPunksWarrior(stage); // Default fallback
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Generate CryptoPunks-style Warrior with stage-based equipment
    /// @param stage Hero stage affecting equipment quality and visual effects
    /// @return warrior Full-body pixelated warrior SVG
    function _getCryptoPunksWarrior(GameConstants.HeroStage stage) private pure returns (string memory warrior) {
        // Base CryptoPunks-style pixelated body (24x48 scaled for full body)
        string memory baseBody = string(
            abi.encodePacked(
                // Head (CryptoPunks style 24x24 scaled to fit full body)
                '<rect x="8" y="0" width="8" height="4" fill="#dbb180"/>', // forehead
                '<rect x="4" y="4" width="16" height="8" fill="#dbb180"/>', // face
                '<rect x="6" y="6" width="2" height="2" fill="#000000"/>', // left eye
                '<rect x="16" y="6" width="2" height="2" fill="#000000"/>', // right eye
                '<rect x="10" y="8" width="4" height="2" fill="#a66e2c"/>', // nose
                '<rect x="8" y="10" width="8" height="2" fill="#711010"/>', // mouth
                // Hair
                '<rect x="6" y="0" width="12" height="6" fill="#8B4513"/>', // brown hair
                // Torso
                '<rect x="6" y="12" width="12" height="16" fill="#4F4F4F"/>', // gray shirt base
                // Arms
                '<rect x="2" y="12" width="4" height="12" fill="#dbb180"/>', // left arm
                '<rect x="18" y="12" width="4" height="12" fill="#dbb180"/>', // right arm
                // Legs
                '<rect x="8" y="28" width="4" height="16" fill="#654321"/>', // left leg (brown pants)
                '<rect x="12" y="28" width="4" height="16" fill="#654321"/>', // right leg
                // Feet
                '<rect x="6" y="44" width="6" height="4" fill="#000000"/>', // left boot
                '<rect x="12" y="44" width="6" height="4" fill="#000000"/>' // right boot
            )
        );

        if (stage == GameConstants.HeroStage.FORGING) {
            // Basic iron equipment
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Basic iron sword
                        '<rect x="0" y="16" width="2" height="12" fill="#C0C0C0"/>', // sword blade
                        '<rect x="0" y="14" width="2" height="2" fill="#8B4513"/>', // sword handle
                        // Basic armor details
                        '<rect x="10" y="16" width="4" height="2" fill="#C0C0C0"/>', // chest plate detail
                        '<rect x="8" y="18" width="8" height="2" fill="#C0C0C0"/>', // belt
                        // Simple shield indicator
                        '<rect x="22" y="18" width="2" height="4" fill="#8B4513"/>' // shield edge
                    )
                );
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Enhanced steel equipment with more details
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Steel sword with crossguard
                        '<rect x="0" y="16" width="2" height="12" fill="#E6E6E6"/>', // brighter sword blade
                        '<rect x="0" y="14" width="2" height="2" fill="#8B4513"/>', // sword handle
                        '<rect x="-1" y="14" width="4" height="1" fill="#E6E6E6"/>', // crossguard
                        // Better armor
                        '<rect x="8" y="14" width="8" height="2" fill="#E6E6E6"/>', // shoulder armor
                        '<rect x="10" y="16" width="4" height="2" fill="#E6E6E6"/>', // chest plate detail
                        '<rect x="8" y="18" width="8" height="2" fill="#FFD700"/>', // golden belt
                        // Better shield
                        '<rect x="22" y="16" width="2" height="6" fill="#E6E6E6"/>', // steel shield
                        '<rect x="22" y="18" width="2" height="2" fill="#FFD700"/>' // shield emblem
                    )
                );
        } else {
            // Mythic/Solo Leveling stage - glowing effects and legendary equipment
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Legendary glowing sword
                        '<rect x="0" y="16" width="2" height="12" fill="#FF69B4"/>', // magical sword blade
                        '<rect x="0" y="14" width="2" height="2" fill="#9370DB"/>', // magical handle
                        '<rect x="-1" y="14" width="4" height="1" fill="#FF69B4"/>', // magical crossguard
                        // Glowing aura around sword
                        '<rect x="-1" y="15" width="1" height="12" fill="#FF69B4" opacity="0.5"/>',
                        '<rect x="2" y="15" width="1" height="12" fill="#FF69B4" opacity="0.5"/>',
                        // Legendary armor with glow
                        '<rect x="6" y="12" width="12" height="16" fill="#9370DB"/>', // purple magical armor
                        '<rect x="8" y="14" width="8" height="2" fill="#FFD700"/>', // golden shoulder guards
                        '<rect x="10" y="16" width="4" height="2" fill="#00FFFF"/>', // cyan chest gem
                        '<rect x="8" y="18" width="8" height="2" fill="#FFD700"/>', // golden belt with gems
                        // Legendary shield with aura
                        '<rect x="22" y="16" width="2" height="6" fill="#9370DB"/>', // magical shield
                        '<rect x="22" y="18" width="2" height="2" fill="#00FFFF"/>', // magical shield gem
                        // Magical aura around character
                        '<rect x="5" y="11" width="1" height="18" fill="#FF69B4" opacity="0.3"/>', // left aura
                        '<rect x="18" y="11" width="1" height="18" fill="#FF69B4" opacity="0.3"/>' // right aura
                    )
                );
        }
    }

    /// @notice Generate CryptoPunks-style Mage with stage-based magical equipment
    /// @param stage Hero stage affecting spell effects and staff quality
    /// @return mage Full-body pixelated mage SVG
    function _getCryptoPunksMage(GameConstants.HeroStage stage) private pure returns (string memory mage) {
        // Base mage body with robes
        string memory baseBody = string(
            abi.encodePacked(
                // Head
                '<rect x="8" y="0" width="8" height="4" fill="#dbb180"/>', // forehead
                '<rect x="4" y="4" width="16" height="8" fill="#dbb180"/>', // face
                '<rect x="6" y="6" width="2" height="2" fill="#4169E1"/>', // magical blue eyes
                '<rect x="16" y="6" width="2" height="2" fill="#4169E1"/>',
                '<rect x="10" y="8" width="4" height="2" fill="#a66e2c"/>', // nose
                '<rect x="8" y="10" width="8" height="2" fill="#711010"/>', // mouth
                // Wizard hat
                '<rect x="8" y="-2" width="8" height="4" fill="#4B0082"/>', // hat base
                '<rect x="10" y="-4" width="4" height="2" fill="#4B0082"/>', // hat tip
                // Long robes instead of regular clothes
                '<rect x="4" y="12" width="16" height="20" fill="#4B0082"/>', // purple robes
                '<rect x="6" y="14" width="12" height="2" fill="#FFD700"/>', // golden trim
                // Arms extending from robes
                '<rect x="2" y="12" width="2" height="12" fill="#dbb180"/>', // left arm (thinner, more scholarly)
                '<rect x="20" y="12" width="2" height="12" fill="#dbb180"/>', // right arm
                // Legs under robes (partially visible)
                '<rect x="8" y="32" width="4" height="12" fill="#4B0082"/>', // left leg in robes
                '<rect x="12" y="32" width="4" height="12" fill="#4B0082"/>', // right leg
                // Simple shoes
                '<rect x="6" y="44" width="6" height="4" fill="#8B4513"/>', // left shoe
                '<rect x="12" y="44" width="6" height="4" fill="#8B4513"/>' // right shoe
            )
        );

        if (stage == GameConstants.HeroStage.FORGING) {
            // Basic wooden staff
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Simple wooden staff
                        '<rect x="22" y="8" width="2" height="20" fill="#8B4513"/>', // wooden staff
                        '<rect x="22" y="6" width="2" height="2" fill="#CD853F"/>', // staff top
                        // Basic spellbook
                        '<rect x="0" y="20" width="4" height="3" fill="#8B4513"/>', // book
                        '<rect x="0" y="20" width="4" height="1" fill="#FFD700"/>' // book binding
                    )
                );
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Enhanced staff with crystal
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Crystal-topped staff
                        '<rect x="22" y="8" width="2" height="20" fill="#8B4513"/>', // wooden staff
                        '<rect x="21" y="6" width="4" height="2" fill="#00FFFF"/>', // crystal top
                        '<rect x="22" y="4" width="2" height="2" fill="#00FFFF"/>', // crystal tip
                        // Magical energy around staff
                        '<rect x="20" y="5" width="1" height="4" fill="#00FFFF" opacity="0.5"/>',
                        '<rect x="25" y="5" width="1" height="4" fill="#00FFFF" opacity="0.5"/>',
                        // Enhanced spellbook
                        '<rect x="0" y="20" width="4" height="3" fill="#4B0082"/>', // magical book
                        '<rect x="0" y="20" width="4" height="1" fill="#FFD700"/>', // golden binding
                        '<rect x="1" y="21" width="2" height="1" fill="#00FFFF"/>' // magical glow
                    )
                );
        } else {
            // Legendary archmage with powerful magical effects
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Legendary staff of power
                        '<rect x="22" y="8" width="2" height="20" fill="#9370DB"/>', // magical staff
                        '<rect x="20" y="6" width="6" height="2" fill="#FF69B4"/>', // large crystal head
                        '<rect x="21" y="4" width="4" height="2" fill="#FF69B4"/>', // crystal top
                        '<rect x="22" y="2" width="2" height="2" fill="#FFFF00"/>', // energy tip
                        // Powerful magical aura around staff
                        '<rect x="19" y="3" width="1" height="8" fill="#FF69B4" opacity="0.6"/>',
                        '<rect x="26" y="3" width="1" height="8" fill="#FF69B4" opacity="0.6"/>',
                        '<rect x="18" y="4" width="1" height="6" fill="#9370DB" opacity="0.4"/>',
                        '<rect x="27" y="4" width="1" height="6" fill="#9370DB" opacity="0.4"/>',
                        // Legendary tome
                        '<rect x="0" y="20" width="4" height="3" fill="#9370DB"/>', // legendary book
                        '<rect x="0" y="20" width="4" height="1" fill="#FFD700"/>', // golden binding
                        '<rect x="1" y="21" width="2" height="1" fill="#FF69B4"/>', // powerful magical glow
                        // Floating magical orbs around mage
                        '<rect x="1" y="8" width="2" height="2" fill="#00FFFF" opacity="0.7"/>', // floating orb 1
                        '<rect x="25" y="12" width="2" height="2" fill="#FF69B4" opacity="0.7"/>', // floating orb 2
                        '<rect x="2" y="28" width="2" height="2" fill="#9370DB" opacity="0.7"/>' // floating orb 3
                    )
                );
        }
    }

    /// @notice Generate CryptoPunks-style Archer with stage-based bow upgrades
    /// @param stage Hero stage affecting bow quality and arrows
    /// @return archer Full-body pixelated archer SVG
    function _getCryptoPunksArcher(GameConstants.HeroStage stage) private pure returns (string memory archer) {
        // Base archer body with leather armor
        string memory baseBody = string(
            abi.encodePacked(
                // Head
                '<rect x="8" y="0" width="8" height="4" fill="#dbb180"/>', // forehead
                '<rect x="4" y="4" width="16" height="8" fill="#dbb180"/>', // face
                '<rect x="6" y="6" width="2" height="2" fill="#228B22"/>', // green eyes (keen sight)
                '<rect x="16" y="6" width="2" height="2" fill="#228B22"/>',
                '<rect x="10" y="8" width="4" height="2" fill="#a66e2c"/>', // nose
                '<rect x="8" y="10" width="8" height="2" fill="#711010"/>', // mouth
                // Ranger cap/hood
                '<rect x="6" y="0" width="12" height="6" fill="#228B22"/>', // green hood
                // Leather armor torso
                '<rect x="6" y="12" width="12" height="16" fill="#8B4513"/>', // brown leather armor
                '<rect x="8" y="14" width="8" height="2" fill="#654321"/>', // leather straps
                '<rect x="10" y="18" width="4" height="2" fill="#654321"/>', // belt
                // Arms
                '<rect x="2" y="12" width="4" height="12" fill="#dbb180"/>', // left arm (bow arm)
                '<rect x="18" y="12" width="4" height="12" fill="#dbb180"/>', // right arm (draw arm)
                // Legs in leather pants
                '<rect x="8" y="28" width="4" height="16" fill="#8B4513"/>', // left leg
                '<rect x="12" y="28" width="4" height="16" fill="#8B4513"/>', // right leg
                // Boots
                '<rect x="6" y="44" width="6" height="4" fill="#654321"/>', // left boot
                '<rect x="12" y="44" width="6" height="4" fill="#654321"/>' // right boot
            )
        );

        if (stage == GameConstants.HeroStage.FORGING) {
            // Basic wooden bow
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Simple wooden bow held in left hand
                        '<rect x="0" y="14" width="2" height="14" fill="#8B4513"/>', // bow stave
                        '<rect x="0" y="12" width="1" height="2" fill="#8B4513"/>', // upper tip
                        '<rect x="0" y="28" width="1" height="2" fill="#8B4513"/>', // lower tip
                        // Bowstring
                        '<rect x="1" y="12" width="1" height="16" fill="#F5DEB3"/>', // string
                        // Quiver on back
                        '<rect x="22" y="16" width="2" height="8" fill="#654321"/>', // quiver
                        // Basic arrows
                        '<rect x="22" y="14" width="2" height="1" fill="#8B4513"/>', // arrow shaft
                        '<rect x="24" y="14" width="1" height="1" fill="#C0C0C0"/>' // arrow tip
                    )
                );
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Enhanced composite bow with better arrows
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Composite bow with reinforcements
                        '<rect x="0" y="14" width="2" height="14" fill="#654321"/>', // darker bow stave
                        '<rect x="0" y="12" width="1" height="2" fill="#8B4513"/>', // upper tip
                        '<rect x="0" y="28" width="1" height="2" fill="#8B4513"/>', // lower tip
                        '<rect x="1" y="16" width="1" height="10" fill="#FFD700"/>', // golden reinforcement
                        // Enhanced bowstring
                        '<rect x="1" y="12" width="1" height="16" fill="#E6E6E6"/>', // better string
                        // Better quiver
                        '<rect x="22" y="16" width="2" height="8" fill="#8B4513"/>', // leather quiver
                        '<rect x="22" y="16" width="2" height="1" fill="#FFD700"/>', // golden trim
                        // Steel-tipped arrows
                        '<rect x="22" y="14" width="2" height="1" fill="#8B4513"/>', // arrow shaft 1
                        '<rect x="24" y="14" width="1" height="1" fill="#E6E6E6"/>', // steel tip 1
                        '<rect x="22" y="15" width="2" height="1" fill="#8B4513"/>', // arrow shaft 2
                        '<rect x="24" y="15" width="1" height="1" fill="#E6E6E6"/>' // steel tip 2
                    )
                );
        } else {
            // Legendary elven bow with magical arrows
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Legendary elven bow with magical glow
                        '<rect x="0" y="14" width="2" height="14" fill="#9370DB"/>', // magical bow
                        '<rect x="0" y="12" width="1" height="2" fill="#FFD700"/>', // golden tips
                        '<rect x="0" y="28" width="1" height="2" fill="#FFD700"/>',
                        '<rect x="1" y="16" width="1" height="10" fill="#00FFFF"/>', // magical core
                        // Glowing magical bowstring
                        '<rect x="1" y="12" width="1" height="16" fill="#FF69B4"/>', // magical string
                        // Magical aura around bow
                        '<rect x="-1" y="13" width="1" height="16" fill="#FF69B4" opacity="0.5"/>',
                        // Legendary quiver with magical arrows
                        '<rect x="22" y="16" width="2" height="8" fill="#9370DB"/>', // magical quiver
                        '<rect x="22" y="16" width="2" height="1" fill="#FFD700"/>', // golden trim
                        // Magical arrows with different elements
                        '<rect x="22" y="14" width="2" height="1" fill="#FF4500"/>', // fire arrow
                        '<rect x="24" y="14" width="1" height="1" fill="#FF69B4"/>', // magical tip
                        '<rect x="22" y="15" width="2" height="1" fill="#00FFFF"/>', // ice arrow
                        '<rect x="24" y="15" width="1" height="1" fill="#E6E6E6"/>', // frost tip
                        '<rect x="22" y="17" width="2" height="1" fill="#9370DB"/>', // lightning arrow
                        '<rect x="24" y="17" width="1" height="1" fill="#FFFF00"/>', // electric tip
                        // Floating magical energy
                        '<rect x="25" y="12" width="1" height="1" fill="#FF69B4" opacity="0.7"/>',
                        '<rect x="25" y="20" width="1" height="1" fill="#00FFFF" opacity="0.7"/>'
                    )
                );
        }
    }

    /// @notice Generate CryptoPunks-style Rogue with stage-based stealth equipment
    /// @param stage Hero stage affecting daggers and stealth gear
    /// @return rogue Full-body pixelated rogue SVG
    function _getCryptoPunksRogue(GameConstants.HeroStage stage) private pure returns (string memory rogue) {
        // Base rogue body with dark clothing
        string memory baseBody = string(
            abi.encodePacked(
                // Head
                '<rect x="8" y="0" width="8" height="4" fill="#dbb180"/>', // forehead
                '<rect x="4" y="4" width="16" height="8" fill="#dbb180"/>', // face
                '<rect x="6" y="6" width="2" height="2" fill="#8B0000"/>', // red eyes (dangerous)
                '<rect x="16" y="6" width="2" height="2" fill="#8B0000"/>',
                '<rect x="10" y="8" width="4" height="2" fill="#a66e2c"/>', // nose
                '<rect x="8" y="10" width="8" height="2" fill="#711010"/>', // mouth
                // Dark hood/mask
                '<rect x="6" y="0" width="12" height="8" fill="#2F2F2F"/>', // dark hood
                '<rect x="8" y="4" width="8" height="4" fill="#2F2F2F"/>', // face mask
                // Dark leather armor
                '<rect x="6" y="12" width="12" height="16" fill="#2F2F2F"/>', // black leather
                '<rect x="8" y="14" width="8" height="2" fill="#696969"/>', // gray straps
                '<rect x="10" y="18" width="4" height="2" fill="#696969"/>', // utility belt
                // Arms
                '<rect x="2" y="12" width="4" height="12" fill="#dbb180"/>', // left arm
                '<rect x="18" y="12" width="4" height="12" fill="#dbb180"/>', // right arm
                // Legs in dark pants
                '<rect x="8" y="28" width="4" height="16" fill="#2F2F2F"/>', // left leg
                '<rect x="12" y="28" width="4" height="16" fill="#2F2F2F"/>', // right leg
                // Silent boots
                '<rect x="6" y="44" width="6" height="4" fill="#000000"/>', // left boot
                '<rect x="12" y="44" width="6" height="4" fill="#000000"/>' // right boot
            )
        );

        if (stage == GameConstants.HeroStage.FORGING) {
            // Basic iron daggers
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Simple dagger in right hand
                        '<rect x="22" y="16" width="1" height="6" fill="#C0C0C0"/>', // dagger blade
                        '<rect x="22" y="22" width="1" height="2" fill="#8B4513"/>', // handle
                        // Throwing knife on belt
                        '<rect x="12" y="20" width="2" height="1" fill="#C0C0C0"/>', // throwing knife
                        '<rect x="14" y="20" width="1" height="1" fill="#8B4513"/>', // knife handle
                        // Simple pouch
                        '<rect x="8" y="20" width="2" height="2" fill="#654321"/>' // utility pouch
                    )
                );
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Enhanced steel daggers with poison
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Enhanced dagger with better grip
                        '<rect x="22" y="16" width="1" height="6" fill="#E6E6E6"/>', // steel blade
                        '<rect x="22" y="22" width="1" height="2" fill="#8B4513"/>', // wrapped handle
                        '<rect x="21" y="22" width="3" height="1" fill="#FFD700"/>', // golden crossguard
                        // Poison vial indicator
                        '<rect x="22" y="15" width="1" height="1" fill="#32CD32"/>', // poison on blade
                        // Multiple throwing knives
                        '<rect x="12" y="20" width="2" height="1" fill="#E6E6E6"/>', // knife 1
                        '<rect x="14" y="20" width="1" height="1" fill="#8B4513"/>',
                        '<rect x="10" y="21" width="2" height="1" fill="#E6E6E6"/>', // knife 2
                        '<rect x="12" y="21" width="1" height="1" fill="#8B4513"/>',
                        // Lockpick tools
                        '<rect x="8" y="20" width="3" height="1" fill="#C0C0C0"/>', // lockpicks
                        '<rect x="8" y="21" width="2" height="2" fill="#654321"/>' // tool pouch
                    )
                );
        } else {
            // Legendary shadow assassin with magical stealth
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Legendary shadow blade with dark magic
                        '<rect x="22" y="16" width="1" height="6" fill="#9370DB"/>', // magical blade
                        '<rect x="22" y="22" width="1" height="2" fill="#8B4513"/>', // handle
                        '<rect x="21" y="22" width="3" height="1" fill="#FFD700"/>', // golden guard
                        // Shadow energy around blade
                        '<rect x="21" y="15" width="1" height="7" fill="#9370DB" opacity="0.6"/>',
                        '<rect x="23" y="15" width="1" height="7" fill="#9370DB" opacity="0.6"/>',
                        // Enchanted throwing weapons
                        '<rect x="12" y="20" width="2" height="1" fill="#FF69B4"/>', // magical knife 1
                        '<rect x="14" y="20" width="1" height="1" fill="#9370DB"/>',
                        '<rect x="10" y="21" width="2" height="1" fill="#00FFFF"/>', // magical knife 2
                        '<rect x="12" y="21" width="1" height="1" fill="#9370DB"/>',
                        '<rect x="8" y="22" width="2" height="1" fill="#FF4500"/>', // fire knife
                        '<rect x="10" y="22" width="1" height="1" fill="#9370DB"/>',
                        // Master thief tools
                        '<rect x="8" y="20" width="3" height="1" fill="#FFD700"/>', // golden lockpicks
                        '<rect x="8" y="21" width="2" height="2" fill="#9370DB"/>', // magical tool pouch
                        // Shadow aura around character
                        '<rect x="5" y="13" width="1" height="15" fill="#9370DB" opacity="0.3"/>',
                        '<rect x="18" y="13" width="1" height="15" fill="#9370DB" opacity="0.3"/>',
                        // Shadow clones or afterimages
                        '<rect x="0" y="16" width="2" height="8" fill="#dbb180" opacity="0.4"/>', // shadow clone arm
                        '<rect x="26" y="16" width="2" height="8" fill="#dbb180" opacity="0.4"/>' // shadow clone arm
                    )
                );
        }
    }

    /// @notice Generate CryptoPunks-style Paladin with stage-based holy equipment
    /// @param stage Hero stage affecting holy weapons and divine aura
    /// @return paladin Full-body pixelated paladin SVG
    function _getCryptoPunksPaladin(GameConstants.HeroStage stage) private pure returns (string memory paladin) {
        // Base paladin body with plate armor
        string memory baseBody = string(
            abi.encodePacked(
                // Head
                '<rect x="8" y="0" width="8" height="4" fill="#dbb180"/>', // forehead
                '<rect x="4" y="4" width="16" height="8" fill="#dbb180"/>', // face
                '<rect x="6" y="6" width="2" height="2" fill="#FFD700"/>', // golden eyes (divine)
                '<rect x="16" y="6" width="2" height="2" fill="#FFD700"/>',
                '<rect x="10" y="8" width="4" height="2" fill="#a66e2c"/>', // nose
                '<rect x="8" y="10" width="8" height="2" fill="#711010"/>', // mouth
                // Holy circlet/helmet
                '<rect x="6" y="0" width="12" height="4" fill="#C0C0C0"/>', // silver helm
                '<rect x="10" y="-1" width="4" height="2" fill="#FFD700"/>', // golden cross
                // Plate armor torso
                '<rect x="6" y="12" width="12" height="16" fill="#E6E6E6"/>', // silver plate
                '<rect x="8" y="14" width="8" height="2" fill="#FFD700"/>', // golden trim
                '<rect x="10" y="18" width="4" height="2" fill="#FFD700"/>', // holy symbol belt
                // Arms in plate
                '<rect x="2" y="12" width="4" height="12" fill="#E6E6E6"/>', // left arm armor
                '<rect x="18" y="12" width="4" height="12" fill="#E6E6E6"/>', // right arm armor
                // Legs in plate
                '<rect x="8" y="28" width="4" height="16" fill="#E6E6E6"/>', // left leg armor
                '<rect x="12" y="28" width="4" height="16" fill="#E6E6E6"/>', // right leg armor
                // Armored boots
                '<rect x="6" y="44" width="6" height="4" fill="#C0C0C0"/>', // left boot
                '<rect x="12" y="44" width="6" height="4" fill="#C0C0C0"/>' // right boot
            )
        );

        if (stage == GameConstants.HeroStage.FORGING) {
            // Basic blessed sword and shield
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Holy sword
                        '<rect x="0" y="16" width="2" height="12" fill="#E6E6E6"/>', // blessed blade
                        '<rect x="0" y="14" width="2" height="2" fill="#8B4513"/>', // leather grip
                        '<rect x="-1" y="14" width="4" height="1" fill="#FFD700"/>', // golden crossguard
                        // Small holy glow
                        '<rect x="0" y="15" width="2" height="1" fill="#FFFF00" opacity="0.5"/>',
                        // Basic shield with cross
                        '<rect x="22" y="16" width="2" height="6" fill="#E6E6E6"/>', // shield
                        '<rect x="22" y="18" width="2" height="2" fill="#FFD700"/>', // cross symbol
                        // Holy symbol on chest
                        '<rect x="11" y="16" width="2" height="2" fill="#FFD700"/>' // chest cross
                    )
                );
        } else if (stage == GameConstants.HeroStage.COMPLETED) {
            // Enhanced blessed weapons with stronger holy aura
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Enhanced holy sword
                        '<rect x="0" y="16" width="2" height="12" fill="#FFD700"/>', // golden blessed blade
                        '<rect x="0" y="14" width="2" height="2" fill="#8B4513"/>', // grip
                        '<rect x="-1" y="14" width="4" height="1" fill="#FFD700"/>', // crossguard
                        // Stronger holy glow around sword
                        '<rect x="-1" y="15" width="1" height="12" fill="#FFFF00" opacity="0.6"/>',
                        '<rect x="2" y="15" width="1" height="12" fill="#FFFF00" opacity="0.6"/>',
                        '<rect x="0" y="13" width="2" height="1" fill="#FFFF00" opacity="0.8"/>',
                        // Enhanced shield with divine protection
                        '<rect x="22" y="16" width="2" height="6" fill="#FFD700"/>', // golden shield
                        '<rect x="22" y="18" width="2" height="2" fill="#FFFF00"/>', // glowing cross
                        '<rect x="21" y="17" width="1" height="4" fill="#FFFF00" opacity="0.5"/>', // shield aura
                        '<rect x="24" y="17" width="1" height="4" fill="#FFFF00" opacity="0.5"/>',
                        // Enhanced holy symbol
                        '<rect x="11" y="16" width="2" height="2" fill="#FFFF00"/>', // glowing chest cross
                        '<rect x="10" y="15" width="4" height="4" fill="#FFFF00" opacity="0.3"/>' // holy aura
                    )
                );
        } else {
            // Legendary divine champion with radiant holy power
            return
                string(
                    abi.encodePacked(
                        baseBody,
                        // Legendary Excalibur-style holy sword
                        '<rect x="0" y="16" width="2" height="12" fill="#FFFF00"/>', // radiant blade
                        '<rect x="0" y="14" width="2" height="2" fill="#9370DB"/>', // divine grip
                        '<rect x="-1" y="14" width="4" height="1" fill="#FF69B4"/>', // magical crossguard
                        // Intense divine radiance
                        '<rect x="-2" y="14" width="1" height="14" fill="#FFFF00" opacity="0.8"/>',
                        '<rect x="3" y="14" width="1" height="14" fill="#FFFF00" opacity="0.8"/>',
                        '<rect x="-1" y="13" width="4" height="1" fill="#FFFF00" opacity="0.9"/>',
                        '<rect x="0" y="12" width="2" height="1" fill="#FFFFFF" opacity="0.7"/>',
                        // Legendary aegis shield
                        '<rect x="22" y="16" width="2" height="6" fill="#FF69B4"/>', // magical shield
                        '<rect x="22" y="18" width="2" height="2" fill="#FFFFFF"/>', // brilliant cross
                        // Divine protection aura around shield
                        '<rect x="20" y="15" width="1" height="8" fill="#FFFF00" opacity="0.7"/>',
                        '<rect x="25" y="15" width="1" height="8" fill="#FFFF00" opacity="0.7"/>',
                        '<rect x="21" y="14" width="4" height="1" fill="#FFFFFF" opacity="0.6"/>',
                        '<rect x="21" y="23" width="4" height="1" fill="#FFFFFF" opacity="0.6"/>',
                        // Divine champion aura around entire character
                        '<rect x="3" y="11" width="1" height="18" fill="#FFFF00" opacity="0.4"/>',
                        '<rect x="20" y="11" width="1" height="18" fill="#FFFF00" opacity="0.4"/>',
                        '<rect x="4" y="10" width="16" height="1" fill="#FFFFFF" opacity="0.5"/>',
                        '<rect x="4" y="29" width="16" height="1" fill="#FFFFFF" opacity="0.5"/>',
                        // Floating divine orbs
                        '<rect x="1" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.8"/>', // orb 1
                        '<rect x="25" y="12" width="2" height="2" fill="#FFFF00" opacity="0.8"/>', // orb 2
                        '<rect x="2" y="32" width="2" height="2" fill="#FF69B4" opacity="0.8"/>', // orb 3
                        // Sacred runes floating around
                        '<rect x="26" y="8" width="1" height="1" fill="#9370DB" opacity="0.9"/>', // rune 1
                        '<rect x="1" y="30" width="1" height="1" fill="#00FFFF" opacity="0.9"/>', // rune 2
                        '<rect x="25" y="28" width="1" height="1" fill="#FF69B4" opacity="0.9"/>' // rune 3
                    )
                );
        }
    }
}
