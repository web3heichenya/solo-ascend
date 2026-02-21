// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title GameConstants
/// @notice Core type definitions and utility library for game constants
/// @author Solo Ascend Team
library GameConstants {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Maximum number of heroes that can be minted
    uint256 internal constant MAX_SUPPLY = 100_000;

    /// @notice Price to mint a new hero
    uint256 internal constant MINT_PRICE = 0.00033 ether;

    /// @notice Fee sent to treasury on each mint
    uint256 internal constant TREASURY_FEE = 0.00003 ether;

    /// @notice Minimum interval between forges for the same hero
    uint256 internal constant MIN_FORGE_INTERVAL = 1 days; // default is 1 day, 5 mins for testing

    /// @notice Forge count at which AMPLIFY effect is guaranteed (if not SOLO_LEVELING)
    uint256 internal constant AMPLIFY_GUARANTEE_FORGE_COUNT = 60;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           ENUMS                            */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Hero class enum
    enum HeroClass {
        WARRIOR, // 0: Warrior - High HP/Defense, strong against damage, balanced melee combat
        MAGE, // 1: Mage - High AP, strong against damage, balanced melee combat
        ARCHER, // 2: Archer - High AD, strong against damage, balanced melee combat
        ROGUE, // 3: Rogue - High AD, strong against damage, balanced melee combat
        PALADIN, // 4: Paladin - High HP/Defense, strong against damage, balanced melee combat
        SUMMONER, // 5: Summoner - High AP, strong against damage, balanced melee combat
        BERSERKER, // 6: Berserker - High AD, strong against damage, balanced melee combat
        PRIEST // 7: Priest - High AP, strong against damage, balanced melee combat
    }

    /// @notice Hero progression stages
    enum HeroStage {
        FORGING, // Still can perform daily forging
        COMPLETED, // Forged amplify effect, no more forging
        SOLO_LEVELING // Forged mythic effect, infinite leveling
    }

    /// @notice Hero attribute enum for type-safe attribute handling
    enum HeroAttribute {
        HP, // 0: Health Points
        HP_REGEN, // 1: Health Regeneration
        AD, // 2: Attack Damage
        AP, // 3: Ability Power
        ATTACK_SPEED, // 4: Attack Speed
        CRIT, // 5: Critical Strike Chance
        ARMOR, // 6: Armor (Physical Resistance)
        MR, // 7: Magic Resistance
        CDR, // 8: Cooldown Reduction
        MOVE_SPEED, // 9: Movement Speed
        LIFESTEAL, // 10: Lifesteal
        TENACITY, // 11: Tenacity
        PENETRATION, // 12: Penetration
        MANA, // 13: Mana
        MANA_REGEN, // 14: Mana Regeneration
        INTELLIGENCE // 15: Intelligence
    }

    /// @notice Forge item quality tiers
    enum ForgeQuality {
        SILVER, // Common quality, always SBT
        GOLD, // Uncommon quality, always SBT
        RAINBOW, // Rare quality, tradeable NFT
        MYTHIC // Legendary quality, tradeable NFT
    }

    /// @notice Types of forge effects
    enum ForgeEffectType {
        ATTRIBUTE, // Boosts specific hero attribute
        AMPLIFY, // Percentage boost to all attributes
        MYTHIC, // Enables infinite leveling
        ENHANCE, // Creates two new attribute forges
        FT, // Rewards treasury tokens
        NFT // Future: Creates new NFT collections
    }

    /// @notice Hero class data structure
    struct HeroClassData {
        string name; // Display name
        string description; // Class description
        HeroAttributes baseAttributes; // Base attributes for this class
        uint64 createdAt; // Registration timestamp
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Hero metadata structure
    /// @param tokenBoundAccount ERC-6551 account address
    /// @param lastForgeTime Last forge timestamp
    /// @param totalForges Total forges performed
    /// @param mintTime When hero was minted
    /// @param classId Hero class ID
    /// @param stage Current stage
    /// @param attributes Hero attributes
    struct Hero {
        address tokenBoundAccount;
        uint64 lastForgeTime;
        uint32 totalForges;
        uint64 mintTime;
        HeroClass classId;
        HeroStage stage;
        HeroAttributes attributes;
    }

    /// @notice Hero attribute structure optimized for gas efficiency
    /// @param hp Maximum health
    /// @param hpRegen Health regeneration
    /// @param ad Attack damage
    /// @param ap Ability power
    /// @param attackSpeed Attack speed
    /// @param crit Critical strike chance
    /// @param armor Armor
    /// @param mr Magic resistance
    /// @param cdr Cooldown reduction
    /// @param moveSpeed Movement speed
    /// @param lifesteal Lifesteal
    /// @param tenacity Tenacity
    /// @param penetration Penetration
    /// @param mana Mana
    /// @param manaRegen Mana regeneration
    /// @param intelligence Intelligence
    struct HeroAttributes {
        uint32 hp;
        uint32 hpRegen;
        uint32 ad;
        uint32 ap;
        uint32 attackSpeed;
        uint32 crit;
        uint32 armor;
        uint32 mr;
        uint32 cdr;
        uint32 moveSpeed;
        uint32 lifesteal;
        uint32 tenacity;
        uint32 penetration;
        uint32 mana;
        uint32 manaRegen;
        uint32 intelligence;
    }

    /// @notice Forge effect data structure
    /// @param effectType Type of effect
    /// @param quality Quality tier
    /// @param attribute Which attribute to boost
    /// @param value Effect value/percentage
    /// @param createdAt Creation timestamp
    /// @param isLocked Whether effect is locked
    struct ForgeEffect {
        ForgeEffectType effectType;
        ForgeQuality quality;
        HeroAttribute attribute;
        uint32 value;
        uint64 createdAt;
        bool isLocked;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get quality name string
    /// @param quality Forge quality enum
    /// @return Quality name
    function getQualityName(ForgeQuality quality) internal pure returns (string memory) {
        if (quality == ForgeQuality.SILVER) return "Silver";
        if (quality == ForgeQuality.GOLD) return "Gold";
        if (quality == ForgeQuality.RAINBOW) return "Rainbow";
        if (quality == ForgeQuality.MYTHIC) return "Mythic";
        return "Unknown";
    }

    /// @notice Get attribute name string
    /// @param attribute Hero attribute enum
    /// @return Attribute name
    function getAttributeName(HeroAttribute attribute) internal pure returns (string memory) {
        if (attribute == HeroAttribute.HP) return "HP";
        if (attribute == HeroAttribute.HP_REGEN) return "HP Regen";
        if (attribute == HeroAttribute.AD) return "AD";
        if (attribute == HeroAttribute.AP) return "AP";
        if (attribute == HeroAttribute.ATTACK_SPEED) return "Attack Speed";
        if (attribute == HeroAttribute.CRIT) return "Crit";
        if (attribute == HeroAttribute.ARMOR) return "Armor";
        if (attribute == HeroAttribute.MR) return "MR";
        if (attribute == HeroAttribute.CDR) return "CDR";
        if (attribute == HeroAttribute.MOVE_SPEED) return "Move Speed";
        if (attribute == HeroAttribute.LIFESTEAL) return "Lifesteal";
        if (attribute == HeroAttribute.TENACITY) return "Tenacity";
        if (attribute == HeroAttribute.PENETRATION) return "Penetration";
        if (attribute == HeroAttribute.MANA) return "Mana";
        if (attribute == HeroAttribute.MANA_REGEN) return "Mana Regen";
        if (attribute == HeroAttribute.INTELLIGENCE) return "Intelligence";
        return "Unknown";
    }

    /// @notice Get effect type name string
    /// @param effectType Forge effect type enum
    /// @return Effect type name
    function getEffectTypeName(ForgeEffectType effectType) internal pure returns (string memory) {
        if (effectType == ForgeEffectType.ATTRIBUTE) return "Attribute";
        if (effectType == ForgeEffectType.AMPLIFY) return "Amplification";
        if (effectType == ForgeEffectType.MYTHIC) return "Mythic Power";
        if (effectType == ForgeEffectType.ENHANCE) return "Enhancement";
        if (effectType == ForgeEffectType.FT) return "FT Reward";
        if (effectType == ForgeEffectType.NFT) return "NFT Reward";
        return "Unknown";
    }

    /// @notice Get forger name by effect type
    /// @param effectType Forge effect type enum
    /// @return Forger name
    function getForgerName(ForgeEffectType effectType) internal pure returns (string memory) {
        if (effectType == ForgeEffectType.ATTRIBUTE) return "Attribute Forger";
        if (effectType == ForgeEffectType.AMPLIFY) return "Amplification Forger";
        if (effectType == ForgeEffectType.MYTHIC) return "Mythic Forger";
        if (effectType == ForgeEffectType.ENHANCE) return "Enhancement Forger";
        if (effectType == ForgeEffectType.FT) return "FT Forger";
        if (effectType == ForgeEffectType.NFT) return "NFT Forger";
        return "Unknown Forger";
    }

    /// @notice Get stage name from stage enum
    /// @param stage The hero stage
    /// @return The human-readable stage name
    function getStageName(HeroStage stage) internal pure returns (string memory) {
        if (stage == HeroStage.FORGING) return "Forging";
        if (stage == HeroStage.COMPLETED) return "Completed";
        if (stage == HeroStage.SOLO_LEVELING) return "Solo Leveling";
        return "Unknown Stage";
    }

    /// @notice Get class name from class ID
    /// @param classId The hero class ID
    /// @return The human-readable class name
    function getHeroClassName(HeroClass classId) internal pure returns (string memory) {
        if (classId == HeroClass.WARRIOR) return "Warrior";
        if (classId == HeroClass.MAGE) return "Mage";
        if (classId == HeroClass.ARCHER) return "Archer";
        if (classId == HeroClass.ROGUE) return "Rogue";
        if (classId == HeroClass.PALADIN) return "Paladin";
        if (classId == HeroClass.SUMMONER) return "Summoner";
        if (classId == HeroClass.BERSERKER) return "Berserker";
        if (classId == HeroClass.PRIEST) return "Priest";
        return "Unknown Class";
    }
}
