// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {GameConstants} from "../libraries/GameConstants.sol";

/// @title ISoloAscendHero
/// @notice Interface for SoloAscendHero contract
/// @author Solo Ascend Team
interface ISoloAscendHero {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when the address is invalid
    error InvalidAddress();
    /// @notice Error thrown when attempting to mint an already minted hero
    error AlreadyMinted();
    /// @notice Error thrown when insufficient payment is provided
    error InsufficientPayment(uint256 required, uint256 provided);
    /// @notice Error thrown when hero ID is invalid
    error InvalidHeroId(uint256 tokenId);
    /// @notice Error thrown when forge is not ready yet
    error ForgeNotReady(uint256 timeLeft);
    /// @notice Error thrown when daily forge limit is exhausted
    error DailyForgeExhausted();
    /// @notice Error thrown when forge effect is invalid
    error InvalidForgeEffect();
    /// @notice Error thrown when forge has already been used
    error ForgeAlreadyUsed();
    /// @notice Error thrown when unauthorized access is attempted
    error UnauthorizedAccess();
    /// @notice Error thrown when hero is in invalid stage for operation
    error InvalidStage(GameConstants.HeroStage currentStage);
    /// @notice Error thrown when mythic supply is exhausted
    error MythicSupplyExhausted();
    /// @notice Error thrown when treasury has insufficient funds
    error InsufficientTreasuryFunds();
    /// @notice Error thrown when quality distribution is invalid
    error InvalidQualityDistribution();
    /// @notice Error thrown when oracle request fails
    error OracleRequestFailed();
    /// @notice Error thrown when input parameter is invalid
    error InvalidInput();
    /// @notice Error thrown when transfer fails
    error TransferFailed();
    /// @notice Error thrown when hero name is invalid (empty or too long)
    error InvalidHeroName();
    /// @notice Error thrown when attribute index is invalid
    error InvalidAttributeIndex();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when a new hero is minted
    /// @param owner The address that owns the hero
    /// @param tokenId The token ID of the hero
    /// @param className The class name of the hero
    event HeroMinted(address indexed owner, uint256 indexed tokenId, string className);

    /// @notice Emitted when a forge process is completed
    /// @param heroId The hero ID
    /// @param effectId The effect ID
    /// @param effectTypeId The effect type ID
    event ForgeCompleted(uint256 indexed heroId, uint256 indexed effectId, uint256 indexed effectTypeId);

    /// @notice Emitted when a hero's stage changes
    /// @param heroId The hero ID
    /// @param newStage The new stage of the hero
    event HeroStageChanged(uint256 indexed heroId, GameConstants.HeroStage newStage);

    /// @notice Emitted when hero attributes are updated
    /// @param heroId The hero ID
    /// @param newAttributes The new attributes of the hero
    event AttributesUpdated(uint256 indexed heroId, GameConstants.HeroAttributes newAttributes);

    /// @notice Emitted when a forge effect is used
    /// @param forgeId The forge ID
    /// @param heroId The hero ID
    event ForgeUsed(uint256 indexed forgeId, uint256 indexed heroId);

    /// @notice Emitted when tokens are deposited into the treasury
    /// @param token The token address
    /// @param amount The amount of tokens deposited
    event TreasuryDeposit(address indexed token, uint256 indexed amount);

    /// @notice Emitted when treasury rewards are distributed
    /// @param recipient The address that received the reward
    /// @param token The token address
    /// @param amount The amount of tokens received
    event TreasuryReward(address indexed recipient, address indexed token, uint256 indexed amount);

    /// @notice Emitted when a hero's custom name is set
    /// @param tokenId The token ID of the hero
    /// @param owner The address that owns the hero
    /// @param newName The new custom name of the hero
    event HeroNameSet(uint256 indexed tokenId, address indexed owner, string newName);

    /// @notice Emitted when a hero's custom name is revoked by admin
    /// @param tokenId The token ID of the hero
    /// @param admin The address that revoked the custom name
    /// @param oldName The old custom name of the hero
    event HeroNameRevoked(uint256 indexed tokenId, address indexed admin, string oldName);

    /// @notice Emitted when revenue is withdrawn from the contract
    /// @param to The address that received the revenue
    /// @param amount The amount of revenue withdrawn
    event RevenueWithdrawn(address indexed to, uint256 indexed amount);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STRUCTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Treasury reward configuration
    /// @param rewardToken Token address for rewards
    /// @param totalDeposits Total deposited amount
    /// @param maxRewardBps Maximum reward basis points
    /// @param isActive Whether rewards are active
    struct TreasuryConfig {
        address rewardToken;
        uint128 totalDeposits;
        uint16 maxRewardBps;
        bool isActive;
    }

    /// @notice Struct to hold forge availability check results.
    /// @param available Whether forge is available
    /// @param timeLeft Time until next forge (if not available)
    struct ForgeAvailabilityCheck {
        bool available;
        uint256 timeLeft;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Mint a new hero NFT
    /// @return tokenId The newly minted token ID
    function mint() external payable returns (uint256 tokenId);

    /// @notice Perform daily forge for a hero
    /// @param tokenId Hero token ID
    /// @param oracleId Oracle ID to use
    /// @param gasLimit Gas limit for the request
    function performDailyForge(uint256 tokenId, uint256 oracleId, uint32 gasLimit) external payable;

    // Deprecated: external oracle callback was removed. Oracles now callback the coordinator only.

    /// @notice Get token bound account address for a hero
    /// @param tokenId Token ID
    /// @return account Token bound account address (may not be deployed yet)
    function getTokenBoundAccount(uint256 tokenId) external view returns (address account);

    /// @notice Get hero ID by TBA account address
    /// @param account TBA account address
    /// @return heroId Hero ID (0 if not a TBA)
    function getHeroIdByAccount(address account) external view returns (uint256 heroId);

    /// @notice Get hero data
    /// @param tokenId Token ID
    /// @return hero Hero data structure
    function getHero(uint256 tokenId) external view returns (GameConstants.Hero memory hero);

    /// @notice Get total supply
    /// @return Current total supply
    function totalSupply() external view returns (uint256);

    /// @notice Check if an account has minted a hero
    /// @param account Account address
    /// @return hasMinted Token ID of the hero if minted, 0 otherwise
    function hasMinted(address account) external view returns (uint256);

    /// @notice Check if daily forge is available
    /// @param tokenId Token ID
    /// @return available Whether forge is available
    /// @return timeLeft Time until next forge (if not available)
    function isForgeAvailable(uint256 tokenId) external view returns (bool available, uint256 timeLeft);

    /// @notice Get the display name for a hero (custom name if set, otherwise default)
    /// @param tokenId Token ID of the hero
    /// @return name The display name of the hero
    function getHeroName(uint256 tokenId) external view returns (string memory name);

    /// @notice Get SVG renderer
    /// @return renderer SVG renderer address
    function getSVGRenderer() external view returns (address renderer);

    /// @notice Set custom name for a hero (only by token owner)
    /// @param tokenId Token ID of the hero
    /// @param name Custom name for the hero (max 32 characters, no empty string)
    function setHeroName(uint256 tokenId, string calldata name) external;

    /// @notice Apply forge item directly to hero (legacy interface with attributeIndex)
    /// @param heroId Hero token ID
    /// @param attribute Attribute index to modify (legacy interface)
    /// @param value Value to add to the attribute or new stage value
    /// @param isPercentage Whether this is a percentage-based increase
    function increaseHeroAttributeFromCoordinator(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external;

    /// @notice Increase all hero attributes from coordinator (called by ForgeCoordinator, for Amplify Effect)
    /// @param heroId Hero token ID
    /// @param value Value to add to all attributes
    /// @param isPercentage Whether value is percentage-based
    function increaseHeroAllAttributesFromCoordinator(uint256 heroId, uint32 value, bool isPercentage) external;

    /// @notice Decrease hero attribute from coordinator (called by ForgeCoordinator)
    /// @param heroId Hero token ID
    /// @param attribute Attribute index to modify (0-9 for normal, 100-109 for percentage)
    /// @param value Value to decrease from the attribute
    /// @param isPercentage Whether this is a percentage-based decrease
    function decreaseHeroAttributeFromCoordinator(
        uint256 heroId,
        GameConstants.HeroAttribute attribute,
        uint32 value,
        bool isPercentage
    ) external;

    /// @notice Update hero stage from coordinator (called by ForgeCoordinator)
    /// @param heroId Hero token ID
    /// @param newStage New hero stage
    function updateHeroStageFromCoordinator(uint256 heroId, GameConstants.HeroStage newStage) external;

    /// @notice Set SVG renderer
    /// @param renderer New renderer address
    function setSVGRenderer(address renderer) external;

    /// @notice Revoke custom name for a hero (only by admin)
    /// @param tokenId Token ID of the hero
    function revokeCustomName(uint256 tokenId) external;

    /// @notice Withdraw project revenue (ETH from mints minus treasury fee)
    /// @param to Address to send the ETH to
    /// @param amount Amount of ETH to withdraw
    function withdrawRevenue(address to, uint256 amount) external;

    /// @notice Withdraw all project revenue
    /// @param to Address to send the ETH to
    function withdrawAllRevenue(address to) external;
}
