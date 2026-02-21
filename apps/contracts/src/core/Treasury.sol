// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {ITreasury} from "../interfaces/ITreasury.sol";

/// @title Treasury
/// @notice Manages ETH and token rewards for Solo Ascend game.
/// @author Solo Ascend Team
contract Treasury is ITreasury, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          STORAGE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Current reward token address (ETH = address(0)).
    address private _rewardToken;

    /// @notice Emergency pause state.
    bool private _isPaused;

    /// @notice Maximum reward basis points (configurable).
    uint256 private _maxRewardBps;

    /// @notice Total ETH deposited from hero mints.
    uint256 private _totalEthDeposited;

    /// @notice Total rewards distributed by token address.
    mapping(address => uint256) private _totalRewardsDistributed;

    /// @notice Authorized distributors (contracts that can distribute rewards).
    mapping(address => bool) private _authorizedDistributors;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         CONSTANTS                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Maximum reward basis points (1000 = 10%).
    uint256 private constant _MAX_REWARD_BPS = 1000;

    /// @notice Basis points denominator (10000 = 100%).
    uint256 private constant _BASIS_POINTS = 10_000;

    /// @notice Maximum configurable reward basis points (5000 = 50%).
    uint256 private constant _MAX_CONFIGURABLE_BPS = 5000;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MODIFIERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Throws if the caller is not an authorized distributor.
    function _checkAuthorizedDistributor() internal view {
        if (!_authorizedDistributors[msg.sender]) revert Unauthorized();
    }

    /// @notice Throws if the contract is paused.
    function _checkNotPaused() internal view {
        if (_isPaused) revert ContractPaused();
    }

    /// @notice Throws if the caller is not an authorized distributor.
    modifier onlyAuthorizedDistributor() {
        _checkAuthorizedDistributor();
        _;
    }

    /// @notice Throws if the contract is paused.
    modifier whenNotPaused() {
        _checkNotPaused();
        _;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        CONSTRUCTOR                          */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Initialize the Treasury contract.
    /// @param admin The address that will be granted owner privileges.
    constructor(address admin) Ownable(admin) {
        _rewardToken = address(0);
        _maxRewardBps = _MAX_REWARD_BPS;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                  PUBLIC UPDATE FUNCTIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ITreasury
    function depositToken(address token, uint256 amount) external override nonReentrant {
        if (token == address(0) || amount == 0) revert InvalidInput();

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        emit TokenDeposited(token, msg.sender, amount);
    }

    /// @inheritdoc ITreasury
    function distributeReward(
        address recipient,
        uint256 rewardBps
    ) external override onlyAuthorizedDistributor whenNotPaused nonReentrant returns (uint256 amount) {
        if (recipient == address(0)) revert InvalidInput();
        if (rewardBps == 0 || rewardBps > _maxRewardBps) revert InvalidRewardPercentage(rewardBps);

        address rewardToken = _rewardToken;

        if (rewardToken == address(0)) {
            uint256 availableEth = address(this).balance;
            amount = (availableEth * rewardBps) / _BASIS_POINTS;

            if (amount == 0) revert InsufficientTreasuryBalance(1, 0);

            unchecked {
                _totalRewardsDistributed[address(0)] += amount;
            }

            (bool success, ) = recipient.call{value: amount}("");
            if (!success) revert TransferFailed();
        } else {
            IERC20 token = IERC20(rewardToken);
            uint256 availableTokens = token.balanceOf(address(this));
            amount = (availableTokens * rewardBps) / _BASIS_POINTS;

            if (amount == 0) revert InsufficientTreasuryBalance(1, 0);

            unchecked {
                _totalRewardsDistributed[rewardToken] += amount;
            }

            token.safeTransfer(recipient, amount);
        }

        emit RewardDistributed(_rewardToken, recipient, amount, rewardBps);
    }

    /// @inheritdoc ITreasury
    function distributeFixedReward(
        address recipient,
        uint256 amount
    ) external override onlyAuthorizedDistributor whenNotPaused nonReentrant {
        if (recipient == address(0)) revert InvalidInput();
        if (amount == 0) revert InvalidInput();

        address rewardToken = _rewardToken;

        if (rewardToken == address(0)) {
            uint256 ethBalance = address(this).balance;
            if (ethBalance < amount) {
                revert InsufficientTreasuryBalance(amount, ethBalance);
            }

            unchecked {
                _totalRewardsDistributed[address(0)] += amount;
            }

            (bool success, ) = recipient.call{value: amount}("");
            if (!success) revert TransferFailed();
        } else {
            IERC20 token = IERC20(rewardToken);
            uint256 availableTokens = token.balanceOf(address(this));

            if (availableTokens < amount) {
                revert InsufficientTreasuryBalance(amount, availableTokens);
            }

            unchecked {
                _totalRewardsDistributed[rewardToken] += amount;
            }

            token.safeTransfer(recipient, amount);
        }

        uint256 totalBalance;
        unchecked {
            totalBalance = rewardToken == address(0)
                ? address(this).balance + amount
                : IERC20(rewardToken).balanceOf(address(this)) + amount;
        }
        uint256 percentage = totalBalance > 0 ? (amount * _BASIS_POINTS) / totalBalance : 0;

        emit RewardDistributed(rewardToken, recipient, amount, percentage);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    RECEIVE FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Receives ETH deposits and tracks total deposits.
    // solhint-disable-next-line no-complex-fallback, use-natspec
    receive() external payable {
        unchecked {
            _totalEthDeposited += msg.value;
        }
        emit EthDeposited(msg.sender, msg.value);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      ADMIN FUNCTIONS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ITreasury
    function setRewardToken(address newRewardToken) external override onlyOwner {
        address oldToken = _rewardToken;
        _rewardToken = newRewardToken;

        emit RewardTokenUpdated(oldToken, newRewardToken);
    }

    /// @inheritdoc ITreasury
    function setMaxRewardBps(uint256 newMaxRewardBps) external override onlyOwner {
        if (newMaxRewardBps > _MAX_CONFIGURABLE_BPS) revert InvalidRewardPercentage(newMaxRewardBps);

        uint256 oldBps = _maxRewardBps;
        _maxRewardBps = newMaxRewardBps;

        emit MaxRewardBpsUpdated(oldBps, newMaxRewardBps);
    }

    /// @inheritdoc ITreasury
    function setAuthorizedDistributor(address distributor, bool authorized) external override onlyOwner {
        if (distributor == address(0)) revert InvalidInput();

        _authorizedDistributors[distributor] = authorized;

        emit DistributorAuthorized(distributor, authorized);
    }

    /// @inheritdoc ITreasury
    function setEmergencyPause(bool paused) external override onlyOwner {
        _isPaused = paused;

        emit EmergencyPaused(paused);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                   PUBLIC READ FUNCTIONS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc ITreasury
    function getRewardBalance() external view override returns (uint256 balance) {
        address rewardToken = _rewardToken;
        return rewardToken == address(0) ? address(this).balance : IERC20(rewardToken).balanceOf(address(this));
    }

    /// @inheritdoc ITreasury
    function calculateReward(uint256 rewardBps) external view override returns (uint256 amount) {
        if (rewardBps > _maxRewardBps) revert InvalidRewardPercentage(rewardBps);

        uint256 balance = this.getRewardBalance();
        return (balance * rewardBps) / _BASIS_POINTS;
    }

    /// @inheritdoc ITreasury
    function getTreasuryStats()
        external
        view
        override
        returns (uint256 ethBalance, uint256 tokenBalance, uint256 ethDistributed, uint256 tokenDistributed)
    {
        ethBalance = address(this).balance;
        tokenBalance = _rewardToken != address(0) ? IERC20(_rewardToken).balanceOf(address(this)) : 0;
        ethDistributed = _totalRewardsDistributed[address(0)];
        tokenDistributed = _rewardToken != address(0) ? _totalRewardsDistributed[_rewardToken] : 0;
    }

    /// @inheritdoc ITreasury
    function isAuthorizedDistributor(address distributor) external view override returns (bool authorized) {
        return _authorizedDistributors[distributor];
    }

    /// @inheritdoc ITreasury
    function getRewardToken() external view override returns (address token) {
        return _rewardToken;
    }

    /// @inheritdoc ITreasury
    function getMaxRewardBps() external view override returns (uint256 bps) {
        return _maxRewardBps;
    }

    /// @inheritdoc ITreasury
    function getTotalEthDeposited() external view override returns (uint256 amount) {
        return _totalEthDeposited;
    }

    /// @inheritdoc ITreasury
    function getTotalRewardsDistributed(address token) external view override returns (uint256 amount) {
        return _totalRewardsDistributed[token];
    }
}
