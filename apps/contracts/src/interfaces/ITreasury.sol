// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title ITreasury
/// @notice Interface for the Treasury contract that manages ETH and token rewards
/// @author Solo Ascend Team
interface ITreasury {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       CUSTOM ERRORS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Error thrown when caller is not authorized
    error Unauthorized();
    /// @notice Error thrown when reward percentage is invalid
    error InvalidRewardPercentage(uint256 percentage);
    /// @notice Error thrown when treasury has insufficient balance
    error InsufficientTreasuryBalance(uint256 requested, uint256 available);
    /// @notice Error thrown when contract is paused
    error ContractPaused();
    /// @notice Error thrown when input parameter is invalid
    error InvalidInput();
    /// @notice Error thrown when transfer fails
    error TransferFailed();

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Emitted when ETH is deposited
    /// @param from Address that deposited ETH
    /// @param amount Amount of ETH deposited
    event EthDeposited(address indexed from, uint256 indexed amount);

    /// @notice Emitted when a token is deposited
    /// @param token Address of the deposited token
    /// @param from Address that deposited the token
    /// @param amount Amount of the token deposited
    event TokenDeposited(address indexed token, address indexed from, uint256 indexed amount);

    /// @notice Emitted when a reward is distributed
    /// @param token Address of the reward token
    /// @param recipient Address that received the reward
    /// @param amount Amount of the reward distributed
    /// @param percentage Percentage of the total reward distributed
    event RewardDistributed(
        address indexed token,
        address indexed recipient,
        uint256 indexed amount,
        uint256 percentage
    );

    /// @notice Emitted when the reward token is updated
    /// @param oldToken Address of the old reward token
    /// @param newToken Address of the new reward token
    event RewardTokenUpdated(address indexed oldToken, address indexed newToken);

    /// @notice Emitted when the maximum reward BPS is updated
    /// @param oldBps Old maximum reward BPS
    /// @param newBps New maximum reward BPS
    event MaxRewardBpsUpdated(uint256 indexed oldBps, uint256 indexed newBps);

    /// @notice Emitted when a distributor is authorized
    /// @param distributor Address of the distributor
    /// @param authorized Whether the distributor is authorized
    event DistributorAuthorized(address indexed distributor, bool indexed authorized);

    /// @notice Emitted when the contract is paused
    /// @param paused Whether the contract is paused
    event EmergencyPaused(bool indexed paused);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         FUNCTIONS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Deposit a token into the treasury
    /// @param token Address of the token to deposit
    /// @param amount Amount of the token to deposit
    function depositToken(address token, uint256 amount) external;

    /// @notice Distribute a reward to a recipient
    /// @param recipient Address of the recipient
    /// @param rewardBps Reward percentage in basis points (e.g., 100 = 1%)
    /// @return amount Amount distributed
    function distributeReward(address recipient, uint256 rewardBps) external returns (uint256 amount);

    /// @notice Distribute a fixed reward to a recipient
    /// @param recipient Address of the recipient
    /// @param amount Amount of the reward to distribute
    function distributeFixedReward(address recipient, uint256 amount) external;

    /// @notice Set the reward token
    /// @param newRewardToken Address of the new reward token
    function setRewardToken(address newRewardToken) external;

    /// @notice Set the maximum reward BPS
    /// @param newMaxRewardBps New maximum reward BPS
    function setMaxRewardBps(uint256 newMaxRewardBps) external;

    /// @notice Authorize/deauthorize a distributor
    /// @param distributor Address of the distributor
    /// @param authorized Whether to authorize or deauthorize
    function setAuthorizedDistributor(address distributor, bool authorized) external;

    /// @notice Set the emergency pause state
    /// @param paused Whether to pause or unpause
    function setEmergencyPause(bool paused) external;

    /// @notice Get the current reward token balance
    /// @return balance Current balance of the reward token
    function getRewardBalance() external view returns (uint256 balance);

    /// @notice Calculate the reward amount for a given percentage
    /// @param rewardBps Reward percentage in basis points (e.g., 100 = 1%)
    /// @return amount Calculated reward amount
    function calculateReward(uint256 rewardBps) external view returns (uint256 amount);

    /// @notice Get the treasury statistics
    /// @return ethBalance Current ETH balance
    /// @return tokenBalance Current reward token balance
    /// @return ethDistributed Total ETH distributed
    /// @return tokenDistributed Total reward token distributed
    function getTreasuryStats()
        external
        view
        returns (uint256 ethBalance, uint256 tokenBalance, uint256 ethDistributed, uint256 tokenDistributed);

    /// @notice Get the current reward token
    /// @return token Current reward token
    function getRewardToken() external view returns (address token);

    /// @notice Get the maximum reward BPS
    /// @return bps Maximum reward BPS
    function getMaxRewardBps() external view returns (uint256 bps);

    /// @notice Get the total ETH deposited
    /// @return amount Total ETH deposited
    function getTotalEthDeposited() external view returns (uint256 amount);

    /// @notice Get the total rewards distributed for a given token
    /// @param token Address of the token
    /// @return amount Total rewards distributed for the token
    function getTotalRewardsDistributed(address token) external view returns (uint256 amount);

    /// @notice Check if a distributor is authorized
    /// @param distributor Address of the distributor
    /// @return authorized Whether the distributor is authorized
    function isAuthorizedDistributor(address distributor) external view returns (bool authorized);
}
