// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {GameConstants} from "../../libraries/GameConstants.sol";
import {IHeroClassRegistry} from "../../interfaces/IHeroClassRegistry.sol";

/// @title HeroClassRegistry
/// @notice Dynamic registry for hero classes and their attributes
/// @author Solo Ascend Team
contract HeroClassRegistry is Ownable, IHeroClassRegistry {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Mapping from class ID to class metadata
    mapping(GameConstants.HeroClass => GameConstants.HeroClassData) private _heroClasses;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the HeroClassRegistry with default hero classes
    /// @param admin The address that will be granted owner privileges
    constructor(address admin) Ownable(admin) {
        _initializeDefaultClasses();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHeroClassRegistry
    function registerHeroClass(
        GameConstants.HeroClass classId,
        string calldata name,
        string calldata description,
        GameConstants.HeroAttributes calldata baseAttributes
    ) external override onlyOwner {
        if (_heroClasses[classId].createdAt > 0) revert ClassAlreadyRegistered(classId);
        if (bytes(name).length == 0) revert InvalidClassData();
        if (baseAttributes.hp == 0) revert InvalidClassData();

        _heroClasses[classId] = GameConstants.HeroClassData({
            name: name,
            description: description,
            baseAttributes: baseAttributes,
            createdAt: uint64(block.timestamp)
        });

        emit HeroClassRegistered(classId, name, baseAttributes);
    }

    /// @inheritdoc IHeroClassRegistry
    function updateClassAttributes(
        GameConstants.HeroClass classId,
        GameConstants.HeroAttributes calldata newBaseAttributes
    ) external override onlyOwner {
        if (_heroClasses[classId].createdAt == 0) revert ClassNotFound(classId);
        if (newBaseAttributes.hp == 0) revert InvalidClassData();

        _heroClasses[classId].baseAttributes = newBaseAttributes;

        emit HeroClassUpdated(classId, newBaseAttributes);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IHeroClassRegistry
    function getHeroClassData(
        GameConstants.HeroClass classId
    ) external view override returns (GameConstants.HeroClassData memory classData) {
        return _heroClasses[classId];
    }

    /// @inheritdoc IHeroClassRegistry
    function getClassBaseAttributes(
        GameConstants.HeroClass classId
    ) external view override returns (GameConstants.HeroAttributes memory attributes) {
        if (_heroClasses[classId].createdAt == 0) revert ClassNotFound(classId);
        return _heroClasses[classId].baseAttributes;
    }

    /// @inheritdoc IHeroClassRegistry
    function getActiveClassCount() external view override returns (uint256 count) {
        for (uint256 i = 0; i < 8; ) {
            if (_heroClasses[GameConstants.HeroClass(i)].createdAt > 0) {
                unchecked {
                    ++count;
                }
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IHeroClassRegistry
    function getActiveClasses() external view override returns (GameConstants.HeroClass[] memory activeClasses) {
        uint256 activeCount = 0;

        // Count active classes (8 classes: WARRIOR, MAGE, ARCHER, ROGUE, PALADIN, SUMMONER, BERSERKER, PRIEST)
        for (uint256 i = 0; i < 8; ) {
            if (_heroClasses[GameConstants.HeroClass(i)].createdAt > 0) {
                unchecked {
                    ++activeCount;
                }
            }
            unchecked {
                ++i;
            }
        }

        if (activeCount == 0) revert NoActiveClasses();

        // Populate active classes array
        activeClasses = new GameConstants.HeroClass[](activeCount);
        uint256 index = 0;

        for (uint256 i = 0; i < 8; ) {
            if (_heroClasses[GameConstants.HeroClass(i)].createdAt > 0) {
                activeClasses[index] = GameConstants.HeroClass(i);
                unchecked {
                    ++index;
                }
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IHeroClassRegistry
    function getRandomClass(uint256 randomSeed) external view override returns (GameConstants.HeroClass classId) {
        GameConstants.HeroClass[] memory activeClasses = this.getActiveClasses();
        uint256 index = randomSeed % activeClasses.length;
        return activeClasses[index];
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    INTERNAL FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize default hero classes
    function _initializeDefaultClasses() internal {
        _initializeWarriorClass();
        _initializeMageClass();
        _initializeArcherClass();
        _initializeRogueClass();
        _initializePaladinClass();
        _initializeBerserkerClass();
        _initializeSummonerClass();
        _initializePriestClass();
    }

    /// @notice Initialize Warrior class with base attributes
    function _initializeWarriorClass() private {
        _heroClasses[GameConstants.HeroClass.WARRIOR] = GameConstants.HeroClassData({
            name: "Warrior",
            description: "High HP/Defense, strong against damage, balanced melee combat",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 1200,
                hpRegen: 15,
                ad: 90,
                ap: 40,
                attackSpeed: 110,
                crit: 80,
                armor: 150,
                mr: 120,
                cdr: 100,
                moveSpeed: 110,
                lifesteal: 25,
                tenacity: 140,
                penetration: 70,
                manaRegen: 40,
                intelligence: 60,
                mana: 200
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Archer class with base attributes
    function _initializeArcherClass() private {
        _heroClasses[GameConstants.HeroClass.ARCHER] = GameConstants.HeroClassData({
            name: "Archer",
            description: "High AD, fast move, long range attacks, low HP/Defense",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 800,
                hpRegen: 8,
                ad: 120,
                ap: 30,
                attackSpeed: 140,
                crit: 120,
                armor: 60,
                mr: 50,
                cdr: 80,
                moveSpeed: 130,
                lifesteal: 20,
                tenacity: 80,
                penetration: 130,
                manaRegen: 50,
                intelligence: 70,
                mana: 180
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Mage class with base attributes
    function _initializeMageClass() private {
        _heroClasses[GameConstants.HeroClass.MAGE] = GameConstants.HeroClassData({
            name: "Mage",
            description: "High AP and CDR, magic damage specialist, low HP/Defense",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 700,
                hpRegen: 10,
                ad: 45,
                ap: 150,
                attackSpeed: 90,
                crit: 40,
                armor: 50,
                mr: 80,
                cdr: 150,
                moveSpeed: 100,
                lifesteal: 10,
                tenacity: 70,
                penetration: 90,
                manaRegen: 150,
                intelligence: 150,
                mana: 400
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Rogue class with base attributes
    function _initializeRogueClass() private {
        _heroClasses[GameConstants.HeroClass.ROGUE] = GameConstants.HeroClassData({
            name: "Rogue",
            description: "High crit and speed, stealth assassin, moderate survivability",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 900,
                hpRegen: 10,
                ad: 100,
                ap: 50,
                attackSpeed: 130,
                crit: 140,
                armor: 70,
                mr: 60,
                cdr: 90,
                moveSpeed: 140,
                lifesteal: 30,
                tenacity: 90,
                penetration: 140,
                manaRegen: 60,
                intelligence: 80,
                mana: 160
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Paladin class with base attributes
    function _initializePaladinClass() private {
        _heroClasses[GameConstants.HeroClass.PALADIN] = GameConstants.HeroClassData({
            name: "Paladin",
            description: "Holy warrior with healing abilities, balanced offense/defense",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 1100,
                hpRegen: 18,
                ad: 80,
                ap: 100,
                attackSpeed: 95,
                crit: 60,
                armor: 120,
                mr: 140,
                cdr: 140,
                moveSpeed: 105,
                lifesteal: 20,
                tenacity: 150,
                penetration: 70,
                manaRegen: 120,
                intelligence: 110,
                mana: 300
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Berserker class with base attributes
    function _initializeBerserkerClass() private {
        _heroClasses[GameConstants.HeroClass.BERSERKER] = GameConstants.HeroClassData({
            name: "Berserker",
            description: "Relentless melee DPS with high AD/AS/Crit and HP; lower defenses",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 1150,
                hpRegen: 12,
                ad: 135,
                ap: 30,
                attackSpeed: 135,
                crit: 130,
                armor: 70,
                mr: 60,
                cdr: 80,
                moveSpeed: 120,
                lifesteal: 35,
                tenacity: 100,
                penetration: 120,
                manaRegen: 30,
                intelligence: 50,
                mana: 100
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Summoner class with base attributes
    function _initializeSummonerClass() private {
        _heroClasses[GameConstants.HeroClass.SUMMONER] = GameConstants.HeroClassData({
            name: "Summoner",
            description: "Pet-focused controller; high AP/CDR/mana regen, fragile defenses",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 850,
                hpRegen: 12,
                ad: 60,
                ap: 130,
                attackSpeed: 95,
                crit: 50,
                armor: 60,
                mr: 110,
                cdr: 140,
                moveSpeed: 110,
                lifesteal: 15,
                tenacity: 80,
                penetration: 90,
                manaRegen: 140,
                intelligence: 140,
                mana: 350
            }),
            createdAt: uint64(block.timestamp)
        });
    }

    /// @notice Initialize Priest (Healer) class with base attributes
    function _initializePriestClass() private {
        _heroClasses[GameConstants.HeroClass.PRIEST] = GameConstants.HeroClassData({
            name: "Priest",
            description: "Primary healer/support; very high CDR/mana regen and MR",
            baseAttributes: GameConstants.HeroAttributes({
                hp: 850,
                hpRegen: 20,
                ad: 40,
                ap: 130,
                attackSpeed: 90,
                crit: 50,
                armor: 60,
                mr: 150,
                cdr: 150,
                moveSpeed: 105,
                lifesteal: 10,
                tenacity: 110,
                penetration: 60,
                manaRegen: 160,
                intelligence: 140,
                mana: 400
            }),
            createdAt: uint64(block.timestamp)
        });
    }
}
