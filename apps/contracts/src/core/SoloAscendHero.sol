// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Royalty} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {LibPRNG} from "solady/utils/LibPRNG.sol";
import {LibString} from "solady/utils/LibString.sol";
import {ISoloAscendHero} from "../interfaces/ISoloAscendHero.sol";
import {ISVGRenderer} from "../interfaces/ISVGRenderer.sol";
import {IERC6551Registry} from "../interfaces/IERC6551Registry.sol";
import {IHookRegistry} from "../interfaces/IHookRegistry.sol";
import {GameConstants} from "../libraries/GameConstants.sol";
import {IHeroClassRegistry} from "../interfaces/IHeroClassRegistry.sol";
import {IForgeCoordinator} from "../interfaces/IForgeCoordinator.sol";
import {IForgeEffectRegistry} from "../interfaces/IForgeEffectRegistry.sol";
import {ITreasury} from "../interfaces/ITreasury.sol";

/// @title SoloAscendHero
/// @notice Main Hero NFT contract with dynamic on-chain metadata and forging system
/// @author Solo Ascend Team
contract SoloAscendHero is ERC721Royalty, Ownable, ReentrancyGuard, ISoloAscendHero {
    using LibString for uint256;
    using LibPRNG for LibPRNG.PRNG;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         STORAGE                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Current token ID counter
    uint256 private _nextTokenId = 1;

    /// @notice SVG renderer for on-chain metadata
    ISVGRenderer private _svgRenderer;

    /// @notice Mapping from address to whether they have minted
    mapping(address => uint256) private _hasMinted;

    /// @notice Mapping from token ID to hero data
    mapping(uint256 => GameConstants.Hero) private _heroes;

    /// @notice Custom names for _heroes (tokenId => custom name)
    mapping(uint256 => string) private _customHeroNames;

    /// @notice Mapping from TBA address to hero ID for reverse lookup
    mapping(address => uint256) private _accountToHeroId;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Hero class registry
    IHeroClassRegistry public immutable HERO_CLASS_REGISTRY;

    /// @notice Forge coordinator
    IForgeCoordinator public immutable FORGE_COORDINATOR;

    /// @notice Forge effect registry
    IForgeEffectRegistry public immutable FORGE_EFFECT_REGISTRY;

    /// @notice Hook registry for extensible functionality
    IHookRegistry public immutable HOOK_REGISTRY;

    /// @notice Treasury contract
    ITreasury public immutable TREASURY;

    /// @notice ERC-6551 registry for token bound accounts
    address public immutable ERC6551_REGISTRY;

    /// @notice ERC-6551 account implementation
    address public immutable ERC6551_IMPLEMENTATION;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Modifier to ensure only the token owner can call the function
    /// @param tokenId Token ID
    modifier onlyTokenOwner(uint256 tokenId) {
        if (ownerOf(tokenId) != msg.sender) revert UnauthorizedAccess();
        _;
    }

    /// @notice Modifier to ensure the token exists
    /// @param tokenId Token ID
    modifier validHero(uint256 tokenId) {
        if (!_exists(tokenId)) revert InvalidHeroId(tokenId);
        _;
    }

    /// @notice Modifier to ensure only the forge coordinator can call the function
    modifier onlyForgeCoordinator() {
        if (msg.sender != address(FORGE_COORDINATOR)) revert UnauthorizedAccess();
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the SoloAscendHero contract
    /// @param admin The address that will be granted owner privileges
    /// @param heroClassRegistry Address of the HeroClassRegistry contract
    /// @param forgeCoordinator Address of the ForgeCoordinator contract
    /// @param forgeEffectRegistry Address of the ForgeEffectRegistry contract
    /// @param hookRegistry Address of the HookRegistry contract
    /// @param treasury Address of the Treasury contract
    /// @param erc6551Registry Address of the ERC-6551 registry
    /// @param erc6551Implementation Address of the ERC-6551 account implementation
    /// @param svgRenderer Address of the SVG renderer for metadata
    constructor(
        address admin,
        address heroClassRegistry,
        address forgeCoordinator,
        address forgeEffectRegistry,
        address hookRegistry,
        address treasury,
        address erc6551Registry,
        address erc6551Implementation,
        address svgRenderer
    ) ERC721("Solo Ascend Hero", "SAH") Ownable(admin) {
        if (heroClassRegistry == address(0)) revert InvalidAddress();
        if (forgeCoordinator == address(0)) revert InvalidAddress();
        if (forgeEffectRegistry == address(0)) revert InvalidAddress();
        if (hookRegistry == address(0)) revert InvalidAddress();
        if (treasury == address(0)) revert InvalidAddress();
        if (erc6551Registry == address(0)) revert InvalidAddress();
        if (erc6551Implementation == address(0)) revert InvalidAddress();
        if (svgRenderer == address(0)) revert InvalidAddress();

        HERO_CLASS_REGISTRY = IHeroClassRegistry(heroClassRegistry);
        FORGE_COORDINATOR = IForgeCoordinator(forgeCoordinator);
        FORGE_EFFECT_REGISTRY = IForgeEffectRegistry(forgeEffectRegistry);
        TREASURY = ITreasury(payable(treasury));
        ERC6551_REGISTRY = erc6551Registry;
        ERC6551_IMPLEMENTATION = erc6551Implementation;
        HOOK_REGISTRY = IHookRegistry(hookRegistry);
        _svgRenderer = ISVGRenderer(svgRenderer);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ISoloAscendHero
    function mint() external payable override nonReentrant returns (uint256 tokenId) {
        if (0 < _hasMinted[msg.sender]) revert AlreadyMinted();
        if (msg.value < GameConstants.MINT_PRICE) {
            revert InsufficientPayment(GameConstants.MINT_PRICE, msg.value);
        }
        if (GameConstants.MAX_SUPPLY < _nextTokenId) revert InsufficientTreasuryFunds(); // Reusing error for max supply

        // Execute before hero minting hook
        _executeHook(IHookRegistry.HookPhase.BEFORE_HERO_MINTING, abi.encode(msg.sender));

        tokenId = _nextTokenId;
        unchecked {
            ++_nextTokenId;
        }
        _hasMinted[msg.sender] = tokenId;

        // Generate random class
        GameConstants.HeroClass classId = HERO_CLASS_REGISTRY.getRandomClass(_generateRandomSeed(tokenId));

        // Initialize hero data
        _heroes[tokenId] = GameConstants.Hero({
            classId: classId,
            stage: GameConstants.HeroStage.FORGING,
            totalForges: 0,
            mintTime: uint64(block.timestamp),
            lastForgeTime: 0,
            attributes: HERO_CLASS_REGISTRY.getClassBaseAttributes(classId),
            tokenBoundAccount: address(0) // Will be set after mint
        });

        _mint(msg.sender, tokenId);

        // Create ERC-6551 account (skip if mock registry)
        if (ERC6551_REGISTRY != address(0)) {
            address tbAccount = _createTBAccount(tokenId);
            _heroes[tokenId].tokenBoundAccount = tbAccount;
            _accountToHeroId[tbAccount] = tokenId;
        }

        // Send fee to treasury
        (bool success, ) = address(TREASURY).call{value: GameConstants.TREASURY_FEE}("");
        if (!success) revert InsufficientTreasuryFunds();

        // Generate and save trait snapshot to ensure stable rendering
        _generateTraitSnapshot(tokenId, classId);

        GameConstants.HeroClassData memory classData = HERO_CLASS_REGISTRY.getHeroClassData(classId);
        // Execute after hero minted hook
        _executeHook(
            IHookRegistry.HookPhase.AFTER_HERO_MINTED,
            abi.encode(tokenId, classId, msg.sender, _heroes[tokenId].tokenBoundAccount)
        );

        emit HeroMinted(msg.sender, tokenId, classData.name);
    }

    /// @inheritdoc ISoloAscendHero
    function performDailyForge(
        uint256 tokenId,
        uint256 oracleId,
        uint32 gasLimit
    ) external payable override validHero(tokenId) onlyTokenOwner(tokenId) nonReentrant {
        GameConstants.Hero storage hero = _heroes[tokenId];

        // Validate forge preconditions
        _validateForgeEligibility(hero, tokenId);
        _validateForgePayment(tokenId, oracleId, gasLimit);

        _executeForgeRequest(tokenId, oracleId, gasLimit, hero);
    }

    /// @inheritdoc ISoloAscendHero
    function increaseHeroAttributeFromCoordinator(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external onlyForgeCoordinator {
        if (!_exists(heroId)) revert InvalidHeroId(heroId);

        GameConstants.Hero storage hero = _heroes[heroId];

        uint16 attributeValue = uint16(value);

        if (isPercentage) {
            _applyAttributePercentageModification(hero.attributes, attribute, attributeValue);
        } else {
            _applyAttributeModification(hero.attributes, attribute, attributeValue);
        }

        // Execute hero attribute updated hook
        _executeHook(IHookRegistry.HookPhase.HERO_ATTRIBUTE_UPDATED, abi.encode(heroId, hero.attributes));

        emit AttributesUpdated(heroId, hero.attributes);
    }

    /// @inheritdoc ISoloAscendHero
    function increaseHeroAllAttributesFromCoordinator(
        uint256 heroId,
        uint32 value,
        bool isPercentage
    ) external onlyForgeCoordinator {
        if (!_exists(heroId)) revert InvalidHeroId(heroId);

        GameConstants.Hero storage hero = _heroes[heroId];

        uint16 attributeValue = uint16(value);
        for (uint8 i = 0; i < 16; ) {
            GameConstants.HeroAttribute attribute = GameConstants.HeroAttribute(i);
            if (isPercentage) {
                _applyAttributePercentageModification(hero.attributes, attribute, attributeValue);
            } else {
                _applyAttributeModification(hero.attributes, attribute, attributeValue);
            }
            unchecked {
                ++i;
            }
        }
        // Execute hero attribute updated hook
        _executeHook(IHookRegistry.HookPhase.HERO_ATTRIBUTE_UPDATED, abi.encode(heroId, hero.attributes));

        emit AttributesUpdated(heroId, hero.attributes);
    }

    /// @inheritdoc ISoloAscendHero
    function decreaseHeroAttributeFromCoordinator(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external onlyForgeCoordinator {
        if (!_exists(heroId)) revert InvalidHeroId(heroId);

        GameConstants.Hero storage hero = _heroes[heroId];

        uint16 attributeValue = uint16(value);

        if (isPercentage) {
            _applyAttributePercentageDecrease(hero.attributes, attribute, attributeValue);
        } else {
            _applyAttributeDecrease(hero.attributes, attribute, attributeValue);
        }

        // Execute hero attribute updated hook
        _executeHook(IHookRegistry.HookPhase.HERO_ATTRIBUTE_UPDATED, abi.encode(heroId, hero.attributes));

        emit AttributesUpdated(heroId, hero.attributes);
    }

    /// @inheritdoc ISoloAscendHero
    function updateHeroStageFromCoordinator(
        uint256 heroId,
        GameConstants.HeroStage newStage
    ) external onlyForgeCoordinator {
        if (!_exists(heroId)) revert InvalidHeroId(heroId);

        GameConstants.Hero storage hero = _heroes[heroId];

        if (newStage != hero.stage) {
            hero.stage = newStage;
            emit HeroStageChanged(heroId, newStage);
        }

        // Execute hero stage changed hook
        _executeHook(IHookRegistry.HookPhase.HERO_STAGE_CHANGED, abi.encode(heroId, newStage));
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                        */
    /*.•°:°.°+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ISoloAscendHero
    function setSVGRenderer(address renderer) external onlyOwner {
        _svgRenderer = ISVGRenderer(renderer);
    }

    /// @inheritdoc ISoloAscendHero
    function setHeroName(uint256 tokenId, string calldata name) external validHero(tokenId) onlyTokenOwner(tokenId) {
        bytes memory nameBytes = bytes(name);
        if (nameBytes.length == 0 || nameBytes.length > 32) {
            revert InvalidHeroName();
        }

        _customHeroNames[tokenId] = name;
        emit HeroNameSet(tokenId, msg.sender, name);
    }

    /// @inheritdoc ISoloAscendHero
    function revokeCustomName(uint256 tokenId) external validHero(tokenId) onlyOwner {
        string memory oldName = _customHeroNames[tokenId];
        if (bytes(oldName).length == 0) return; // No custom name to revoke

        delete _customHeroNames[tokenId];
        emit HeroNameRevoked(tokenId, msg.sender, oldName);
    }

    /// @inheritdoc ISoloAscendHero
    function withdrawRevenue(address to, uint256 amount) external onlyOwner nonReentrant {
        if (to == address(0)) revert InvalidInput();
        if (amount == 0) revert InvalidInput();

        uint256 balance = address(this).balance;
        if (balance < amount) revert InsufficientTreasuryFunds();

        (bool success, ) = to.call{value: amount}("");
        if (!success) revert TransferFailed();

        emit RevenueWithdrawn(to, amount);
    }

    /// @inheritdoc ISoloAscendHero
    function withdrawAllRevenue(address to) external onlyOwner nonReentrant {
        if (to == address(0)) revert InvalidInput();

        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientTreasuryFunds();

        (bool success, ) = to.call{value: balance}("");
        if (!success) revert TransferFailed();

        emit RevenueWithdrawn(to, balance);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ISoloAscendHero
    function getHeroName(uint256 tokenId) external view override validHero(tokenId) returns (string memory name) {
        string memory customName = _customHeroNames[tokenId];
        if (bytes(customName).length > 0) {
            return customName;
        }
        return string(abi.encodePacked("Solo Ascend Hero #", tokenId.toString()));
    }

    /// @notice Get token URI with on-chain metadata
    /// @param tokenId Token ID
    /// @return Token URI as data URL
    function tokenURI(uint256 tokenId) public view override validHero(tokenId) returns (string memory) {
        string memory customName = _customHeroNames[tokenId];
        return _svgRenderer.getTokenURI(_heroes[tokenId], tokenId, customName);
    }

    /// @inheritdoc ISoloAscendHero
    function getHero(
        uint256 tokenId
    ) external view override validHero(tokenId) returns (GameConstants.Hero memory hero) {
        return _heroes[tokenId];
    }

    /// @inheritdoc ISoloAscendHero
    function totalSupply() external view override returns (uint256) {
        unchecked {
            return _nextTokenId - 1;
        }
    }

    /// @inheritdoc ISoloAscendHero
    function isForgeAvailable(
        uint256 tokenId
    ) external view override validHero(tokenId) returns (bool available, uint256 timeLeft) {
        ForgeAvailabilityCheck memory check = _performForgeAvailabilityCheck(tokenId);
        return (check.available, check.timeLeft);
    }

    /// @inheritdoc ISoloAscendHero
    function getTokenBoundAccount(uint256 tokenId) external view override validHero(tokenId) returns (address account) {
        // Check if account is already stored
        address storedAccount = _heroes[tokenId].tokenBoundAccount;
        if (storedAccount != address(0)) {
            return storedAccount;
        }

        // Compute the account address using the same parameters as creation
        IERC6551Registry registry = IERC6551Registry(ERC6551_REGISTRY);
        bytes32 salt = _getTBASalt(tokenId);

        return registry.account(ERC6551_IMPLEMENTATION, salt, block.chainid, address(this), tokenId);
    }

    /// @inheritdoc ISoloAscendHero
    function getHeroIdByAccount(address account) external view override returns (uint256 heroId) {
        return _accountToHeroId[account];
    }

    /// @inheritdoc ISoloAscendHero
    function getSVGRenderer() external view override returns (address renderer) {
        return address(_svgRenderer);
    }

    /// @inheritdoc ISoloAscendHero
    function hasMinted(address account) external view override returns (uint256) {
        return _hasMinted[account];
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                     INTERNAL FUNCTIONS                     */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Perform comprehensive forge availability check
    /// @param tokenId Token ID
    /// @return check Availability check results
    function _performForgeAvailabilityCheck(
        uint256 tokenId
    ) internal view returns (ForgeAvailabilityCheck memory check) {
        GameConstants.Hero storage hero = _heroes[tokenId];
        // Check hero stage first (fastest check)
        if (!_canHeroStageForge(hero)) {
            return ForgeAvailabilityCheck(false, 0);
        }

        // Check cooldown last (most expensive check)
        return _checkCooldownAvailability(hero);
    }

    /// @notice Check cooldown availability
    /// @param hero Hero storage reference
    /// @return check Availability check results
    function _checkCooldownAvailability(
        GameConstants.Hero storage hero
    ) internal view returns (ForgeAvailabilityCheck memory check) {
        (bool inCooldown, uint256 cooldownTime) = _checkForgeCooldown(hero);
        if (inCooldown) {
            return ForgeAvailabilityCheck(false, cooldownTime);
        }
        return ForgeAvailabilityCheck(true, 0);
    }

    /// @notice Check if hero stage allows forging
    /// @param hero Hero data
    /// @return canForge Whether hero stage allows forging
    function _canHeroStageForge(GameConstants.Hero storage hero) internal view returns (bool canForge) {
        return hero.stage != GameConstants.HeroStage.COMPLETED;
    }

    /// @notice Check forge cooldown and calculate time until ready
    /// @param hero Hero data
    /// @return inCooldown Whether hero is in cooldown
    /// @return timeUntilReady Time until cooldown ends
    function _checkForgeCooldown(
        GameConstants.Hero storage hero
    ) internal view returns (bool inCooldown, uint256 timeUntilReady) {
        if (hero.lastForgeTime == 0) {
            return (false, 0); // First forge, no cooldown
        }

        uint256 nextForgeTime = hero.lastForgeTime + GameConstants.MIN_FORGE_INTERVAL;
        inCooldown = block.timestamp < nextForgeTime;
        timeUntilReady = inCooldown ? nextForgeTime - block.timestamp : 0;
    }

    /// @notice Validates that a hero is eligible for forging
    /// @param hero Hero storage reference
    /// @param tokenId Hero token ID
    function _validateForgeEligibility(GameConstants.Hero storage hero, uint256 tokenId) internal view {
        _validateHeroStage(hero);
        _validateForgeCooldown(hero);
        _validateNoPendingForge(tokenId);
    }

    /// @notice Validate hero is in correct stage for forging
    /// @param hero Hero storage reference
    function _validateHeroStage(GameConstants.Hero storage hero) internal view {
        if (hero.stage != GameConstants.HeroStage.FORGING && hero.stage != GameConstants.HeroStage.SOLO_LEVELING) {
            revert InvalidStage(hero.stage);
        }
    }

    /// @notice Validate forge cooldown period has passed
    /// @param hero Hero storage reference
    function _validateForgeCooldown(GameConstants.Hero storage hero) internal view {
        if (hero.lastForgeTime > 0 && block.timestamp < hero.lastForgeTime + GameConstants.MIN_FORGE_INTERVAL) {
            revert ForgeNotReady(hero.lastForgeTime + GameConstants.MIN_FORGE_INTERVAL - block.timestamp);
        }
    }

    /// @notice Validate no pending forge request exists
    /// @param tokenId Hero token ID
    function _validateNoPendingForge(uint256 tokenId) internal view {
        if (FORGE_COORDINATOR.hasPendingForge(tokenId)) {
            revert OracleRequestFailed();
        }
    }

    /// @notice Validates forge payment
    /// @param tokenId Hero token ID
    /// @param oracleId Oracle ID to use
    /// @param gasLimit Gas limit for the request
    function _validateForgePayment(uint256 tokenId, uint256 oracleId, uint32 gasLimit) internal view {
        uint256 fee = FORGE_COORDINATOR.calculateForgeCost(tokenId, oracleId, gasLimit);
        if (msg.value < fee) revert InsufficientPayment(fee, msg.value);
    }

    /// @notice Executes the forge request with rollback on failure
    /// @param tokenId Hero token ID
    /// @param oracleId Oracle ID to use
    /// @param gasLimit Gas limit for the request
    /// @param hero Hero storage reference
    function _executeForgeRequest(
        uint256 tokenId,
        uint256 oracleId,
        uint32 gasLimit,
        GameConstants.Hero storage hero
    ) internal {
        FORGE_COORDINATOR.initiateForgeAndRequestAuto{value: msg.value}(tokenId, msg.sender, oracleId, gasLimit);
        // Update forge tracking
        unchecked {
            ++hero.totalForges;
        }
        hero.lastForgeTime = uint64(block.timestamp);
    }

    /// @notice Internal helper function to apply attribute modifications
    /// @param attributes The attributes storage to modify
    /// @param attribute The hero attribute to modify
    /// @param value The value to add to the attribute
    function _applyAttributeModification(
        GameConstants.HeroAttributes storage attributes,
        GameConstants.HeroAttribute attribute,
        uint16 value
    ) internal {
        // Use type-safe enum for attribute modification
        if (attribute == GameConstants.HeroAttribute.HP) {
            attributes.hp += value;
        } else if (attribute == GameConstants.HeroAttribute.HP_REGEN) {
            attributes.hpRegen += value;
        } else if (attribute == GameConstants.HeroAttribute.AD) {
            attributes.ad += value;
        } else if (attribute == GameConstants.HeroAttribute.AP) {
            attributes.ap += value;
        } else if (attribute == GameConstants.HeroAttribute.ATTACK_SPEED) {
            attributes.attackSpeed += value;
        } else if (attribute == GameConstants.HeroAttribute.CRIT) {
            attributes.crit += value;
        } else if (attribute == GameConstants.HeroAttribute.ARMOR) {
            attributes.armor += value;
        } else if (attribute == GameConstants.HeroAttribute.MR) {
            attributes.mr += value;
        } else if (attribute == GameConstants.HeroAttribute.CDR) {
            attributes.cdr += value;
        } else if (attribute == GameConstants.HeroAttribute.MOVE_SPEED) {
            attributes.moveSpeed += value;
        } else if (attribute == GameConstants.HeroAttribute.LIFESTEAL) {
            attributes.lifesteal += value;
        } else if (attribute == GameConstants.HeroAttribute.TENACITY) {
            attributes.tenacity += value;
        } else if (attribute == GameConstants.HeroAttribute.PENETRATION) {
            attributes.penetration += value;
        } else if (attribute == GameConstants.HeroAttribute.MANA) {
            attributes.mana += value;
        } else if (attribute == GameConstants.HeroAttribute.MANA_REGEN) {
            attributes.manaRegen += value;
        } else if (attribute == GameConstants.HeroAttribute.INTELLIGENCE) {
            attributes.intelligence += value;
        }
    }

    /// @notice Internal helper function to apply percentage-based attribute modifications
    /// @param attributes The attributes storage to modify
    /// @param attribute The hero attribute to modify
    /// @param percentage The percentage value to add (in basis points, e.g., 500 = 5%)
    function _applyAttributePercentageModification(
        GameConstants.HeroAttributes storage attributes,
        GameConstants.HeroAttribute attribute,
        uint16 percentage
    ) internal {
        // Apply percentage increase to the specified attribute
        if (attribute == GameConstants.HeroAttribute.HP) {
            attributes.hp += (attributes.hp * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.HP_REGEN) {
            attributes.hpRegen += (attributes.hpRegen * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.AD) {
            attributes.ad += (attributes.ad * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.AP) {
            attributes.ap += (attributes.ap * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.ATTACK_SPEED) {
            attributes.attackSpeed += (attributes.attackSpeed * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.CRIT) {
            attributes.crit += (attributes.crit * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.ARMOR) {
            attributes.armor += (attributes.armor * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.MR) {
            attributes.mr += (attributes.mr * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.CDR) {
            attributes.cdr += (attributes.cdr * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.MOVE_SPEED) {
            attributes.moveSpeed += (attributes.moveSpeed * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.LIFESTEAL) {
            attributes.lifesteal += (attributes.lifesteal * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.TENACITY) {
            attributes.tenacity += (attributes.tenacity * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.PENETRATION) {
            attributes.penetration += (attributes.penetration * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.MANA) {
            attributes.mana += (attributes.mana * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.MANA_REGEN) {
            attributes.manaRegen += (attributes.manaRegen * percentage) / 10_000;
        } else if (attribute == GameConstants.HeroAttribute.INTELLIGENCE) {
            attributes.intelligence += (attributes.intelligence * percentage) / 10_000;
        }
    }

    /// @notice Internal helper function to apply attribute decreases with underflow protection
    /// @param attributes The attributes storage to modify
    /// @param attribute The hero attribute to modify
    /// @param value The value to subtract from the attribute
    function _applyAttributeDecrease(
        GameConstants.HeroAttributes storage attributes,
        GameConstants.HeroAttribute attribute,
        uint16 value
    ) internal {
        // Use type-safe enum for attribute modification with underflow protection
        if (attribute == GameConstants.HeroAttribute.HP) {
            attributes.hp = attributes.hp > value ? attributes.hp - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.HP_REGEN) {
            attributes.hpRegen = attributes.hpRegen > value ? attributes.hpRegen - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.AD) {
            attributes.ad = attributes.ad > value ? attributes.ad - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.AP) {
            attributes.ap = attributes.ap > value ? attributes.ap - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.ATTACK_SPEED) {
            attributes.attackSpeed = attributes.attackSpeed > value ? attributes.attackSpeed - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.CRIT) {
            attributes.crit = attributes.crit > value ? attributes.crit - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.ARMOR) {
            attributes.armor = attributes.armor > value ? attributes.armor - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.MR) {
            attributes.mr = attributes.mr > value ? attributes.mr - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.CDR) {
            attributes.cdr = attributes.cdr > value ? attributes.cdr - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.MOVE_SPEED) {
            attributes.moveSpeed = attributes.moveSpeed > value ? attributes.moveSpeed - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.LIFESTEAL) {
            attributes.lifesteal = attributes.lifesteal > value ? attributes.lifesteal - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.TENACITY) {
            attributes.tenacity = attributes.tenacity > value ? attributes.tenacity - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.PENETRATION) {
            attributes.penetration = attributes.penetration > value ? attributes.penetration - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.MANA) {
            attributes.mana = attributes.mana > value ? attributes.mana - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.MANA_REGEN) {
            attributes.manaRegen = attributes.manaRegen > value ? attributes.manaRegen - value : 0;
        } else if (attribute == GameConstants.HeroAttribute.INTELLIGENCE) {
            attributes.intelligence = attributes.intelligence > value ? attributes.intelligence - value : 0;
        }
    }

    /// @notice Internal helper function to apply percentage-based attribute decreases
    /// @param attributes The attributes storage to modify
    /// @param attribute The hero attribute to modify
    /// @param percentage The percentage value to decrease (in basis points, e.g., 500 = 5%)
    function _applyAttributePercentageDecrease(
        GameConstants.HeroAttributes storage attributes,
        GameConstants.HeroAttribute attribute,
        uint16 percentage
    ) internal {
        // Apply percentage decrease to the specified attribute with underflow protection
        if (attribute == GameConstants.HeroAttribute.HP) {
            uint16 decrease = uint16((uint32(attributes.hp) * percentage) / 10_000);
            attributes.hp = attributes.hp > decrease ? attributes.hp - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.HP_REGEN) {
            uint16 decrease = uint16((uint32(attributes.hpRegen) * percentage) / 10_000);
            attributes.hpRegen = attributes.hpRegen > decrease ? attributes.hpRegen - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.AD) {
            uint16 decrease = uint16((uint32(attributes.ad) * percentage) / 10_000);
            attributes.ad = attributes.ad > decrease ? attributes.ad - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.AP) {
            uint16 decrease = uint16((uint32(attributes.ap) * percentage) / 10_000);
            attributes.ap = attributes.ap > decrease ? attributes.ap - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.ATTACK_SPEED) {
            uint16 decrease = uint16((uint32(attributes.attackSpeed) * percentage) / 10_000);
            attributes.attackSpeed = attributes.attackSpeed > decrease ? attributes.attackSpeed - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.CRIT) {
            uint16 decrease = uint16((uint32(attributes.crit) * percentage) / 10_000);
            attributes.crit = attributes.crit > decrease ? attributes.crit - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.ARMOR) {
            uint16 decrease = uint16((uint32(attributes.armor) * percentage) / 10_000);
            attributes.armor = attributes.armor > decrease ? attributes.armor - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.MR) {
            uint16 decrease = uint16((uint32(attributes.mr) * percentage) / 10_000);
            attributes.mr = attributes.mr > decrease ? attributes.mr - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.CDR) {
            uint16 decrease = uint16((uint32(attributes.cdr) * percentage) / 10_000);
            attributes.cdr = attributes.cdr > decrease ? attributes.cdr - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.MOVE_SPEED) {
            uint16 decrease = uint16((uint32(attributes.moveSpeed) * percentage) / 10_000);
            attributes.moveSpeed = attributes.moveSpeed > decrease ? attributes.moveSpeed - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.LIFESTEAL) {
            uint16 decrease = uint16((uint32(attributes.lifesteal) * percentage) / 10_000);
            attributes.lifesteal = attributes.lifesteal > decrease ? attributes.lifesteal - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.TENACITY) {
            uint16 decrease = uint16((uint32(attributes.tenacity) * percentage) / 10_000);
            attributes.tenacity = attributes.tenacity > decrease ? attributes.tenacity - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.PENETRATION) {
            uint16 decrease = uint16((uint32(attributes.penetration) * percentage) / 10_000);
            attributes.penetration = attributes.penetration > decrease ? attributes.penetration - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.MANA) {
            uint16 decrease = uint16((uint32(attributes.mana) * percentage) / 10_000);
            attributes.mana = attributes.mana > decrease ? attributes.mana - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.MANA_REGEN) {
            uint16 decrease = uint16((uint32(attributes.manaRegen) * percentage) / 10_000);
            attributes.manaRegen = attributes.manaRegen > decrease ? attributes.manaRegen - decrease : 0;
        } else if (attribute == GameConstants.HeroAttribute.INTELLIGENCE) {
            uint16 decrease = uint16((uint32(attributes.intelligence) * percentage) / 10_000);
            attributes.intelligence = attributes.intelligence > decrease ? attributes.intelligence - decrease : 0;
        }
    }

    /// @notice Generate random seed for various operations
    /// @param seed Base seed value
    /// @return randomSeed Generated random seed
    function _generateRandomSeed(uint256 seed) internal view returns (uint256 randomSeed) {
        return uint256(keccak256(abi.encode(seed, block.timestamp, block.prevrandao, msg.sender)));
    }

    /// @notice Create ERC-6551 token bound account
    /// @param tokenId Token ID
    /// @return account Token bound account address
    function _createTBAccount(uint256 tokenId) internal returns (address account) {
        // Use ERC-6551 registry to create token bound account
        IERC6551Registry registry = IERC6551Registry(ERC6551_REGISTRY);

        // Create account with deterministic salt based on token ID
        bytes32 salt = _getTBASalt(tokenId);

        // Create the token bound account
        account = registry.createAccount(
            ERC6551_IMPLEMENTATION, // Account implementation contract
            salt, // Deterministic salt
            block.chainid, // Current chain ID
            address(this), // This NFT contract
            tokenId // Token ID
        );

        return account;
    }

    /// @notice Token bound account salt
    /// @param tokenId Token ID
    /// @return salt Salt for TBA
    function _getTBASalt(uint256 tokenId) internal pure returns (bytes32 salt) {
        salt = keccak256(abi.encodePacked("SoloAscendHero", tokenId));
    }

    // (cleaned) Deprecated forge-processing helpers removed; Coordinator handles fulfillment and effect execution

    /// @notice Execute hook for a specific phase
    /// @param phase Hook execution phase
    /// @param data Encoded data to pass to hooks
    function _executeHook(IHookRegistry.HookPhase phase, bytes memory data) internal {
        if (address(HOOK_REGISTRY) == address(0)) return;
        if (HOOK_REGISTRY.hasHooks(phase)) {
            // solhint-disable-next-line no-empty-blocks
            try HOOK_REGISTRY.executeHooks(phase, data) {
                // Hook executed successfully
                // solhint-disable-next-line no-empty-blocks
            } catch {
                // Hook execution failed, continue without reverting
                // This ensures hooks don't break the main hero operations
            }
        }
    }

    /// @notice Generate and save trait snapshot for a newly minted hero
    /// @dev This ensures stable trait rendering even when new traits are added
    /// @param tokenId Token ID to generate snapshot for
    /// @param classId Hero class for trait generation
    function _generateTraitSnapshot(uint256 tokenId, GameConstants.HeroClass classId) internal {
        ISVGRenderer(_svgRenderer).generateAndSaveTraits(tokenId, classId);
    }

    /// @notice Check if token exists
    /// @param tokenId Token ID to check
    /// @return exists Whether token exists
    function _exists(uint256 tokenId) internal view returns (bool exists) {
        return tokenId > 0 && tokenId < _nextTokenId;
    }
}
