// SPDX-License-Identifier: MIT

/* solhint-disable no-console, gas-small-strings, gas-struct-packing, code-complexity */

pragma solidity ^0.8.23;

/// @title DeployConfig
/// @author Solo Ascend Team
/// @notice Configuration settings for different networks
/// @dev Import this in deployment scripts to get network-specific settings
library DeployConfig {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                    NETWORK CONFIGURATIONS                   */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Chainlink VRF configuration
    /// @dev Separated for easier management and support of multiple oracle providers
    struct ChainlinkVRFConfig {
        bool enabled;
        address coordinator;
        address wrapper; // VRF v2.5 Wrapper for Direct Funding
        bytes32 keyHash;
        uint64 subscriptionId;
    }

    /// @notice Configuration structure for network-specific settings
    /// @dev Contains all parameters needed for deployment on a specific network
    struct NetworkConfig {
        string name;
        uint256 chainId;
        address admin;
        address erc6551Registry;
        address erc6551Implementation;
        ChainlinkVRFConfig chainlinkVRF;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      MAINNET CONFIGS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get configuration for Ethereum Mainnet
    /// @return NetworkConfig Configuration for Ethereum Mainnet
    function _getMainnetConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Ethereum Mainnet",
                chainId: 1,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0xD7f86b4b8Cae7D942340FF628F82735b7a20893a,
                    wrapper: 0x02aae1A04f9828517b3007f83f6181900CaD910c, // TODO: set VRF v2.5 wrapper for direct funding
                    keyHash: 0x8077df514608a09f83e4e8d300645594e5d7234665448ba83f51a50f842bd3d9,
                    subscriptionId: 0 // unused in direct funding
                })
            });
    }

    /// @notice Get configuration for Polygon Mainnet
    /// @return NetworkConfig Configuration for Polygon Mainnet
    function _getPolygonConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Polygon Mainnet",
                chainId: 137,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0xec0Ed46f36576541C75739E915ADbCb3DE24bD77,
                    wrapper: 0xc8F13422c49909F4Ec24BF65EDFBEbe410BB9D7c,
                    keyHash: 0x0ffbbd0c1c18c0263dd778dadd1d64240d7bc338d95fec1cf0473928ca7eaf9e,
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for Arbitrum One
    /// @return NetworkConfig Configuration for Arbitrum One
    function _getArbitrumConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Arbitrum One",
                chainId: 42_161,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true, // Use pseudo-random for lower costs
                    coordinator: 0x3C0Ca683b403E37668AE3DC4FB62F4B29B6f7a3e,
                    wrapper: 0x14632CD5c12eC5875D41350B55e825c54406BaaB,
                    keyHash: 0x9e9e46732b32662b9adc6f3abdf6c5e926a666d174a4d6b8e39c4cca76a38897,
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for Optimism
    /// @return NetworkConfig Configuration for Optimism
    function _getOptimismConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Optimism",
                chainId: 10,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true, // Use pseudo-random for lower costs
                    coordinator: 0x5FE58960F730153eb5A84a47C51BD4E58302E1c8,
                    wrapper: 0x6A39cE9604FAD060B32bc35BE2e0D3825B2b8D4B,
                    keyHash: 0xa16a2316f92fa0abfd0029eea74e947d0613728e934d9794cd78bc02e2f69de4,
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for Base Mainnet
    /// @return NetworkConfig Configuration for Base Mainnet
    function _getBaseConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Base Mainnet",
                chainId: 8453,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x41C8f39463A868d3A88af00cd0fe7102F30E44eC,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0xd5D517aBE5cF79B7e95eC98dB0f0277788aFF634, // TODO: Add VRF v2.5 coordinator for Base
                    wrapper: 0xb0407dbe851f8318bd31404A49e658143C982F23,
                    keyHash: 0x00b81b5a830cb0a4009fbd8904de511e28631e62ce5ad231373d3cdad373ccab, // TODO: Add keyHash for Base
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for BSC/BNB Chain Mainnet
    /// @return NetworkConfig Configuration for BSC Mainnet
    function _getBSCConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "BSC Mainnet",
                chainId: 56,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // TODO: Set actual admin
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358, // Same as Ethereum
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0xd691f04bc0C9a24Edb78af9E005Cf85768F694C9, // TODO: Add VRF v2.5 coordinator for BSC
                    wrapper: 0x471506e6ADED0b9811D05B8cAc8Db25eE839Ac94,
                    keyHash: 0x130dba50ad435d4ecc214aad0d5820474137bd68e7e77724144f27c3c377d3d4, // TODO: Add keyHash for BSC
                    subscriptionId: 0
                })
            });
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      TESTNET CONFIGS                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get configuration for Sepolia testnet
    /// @return NetworkConfig Configuration for Sepolia testnet
    function _getSepoliaConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Sepolia Testnet",
                chainId: 11_155_111,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // Default test address
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
                    wrapper: 0x195f15F2d49d693cE265b4fB0fdDbE15b1850Cc1,
                    keyHash: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for Polygon Amoy testnet
    /// @return NetworkConfig Configuration for Polygon Amoy testnet
    function _getPolygonAmoyConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Polygon Amoy Testnet",
                chainId: 80_002,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // Default test address
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0x343300b5d84D444B2ADc9116FEF1bED02BE49Cf2,
                    wrapper: 0x6e6c366a1cd1F92ba87Fd6f96F743B0e6c967Bf0,
                    keyHash: 0x816bedba8a50b294e5cbd47842baf240c2385f2eaf719edbd4f250a137a8c899,
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for Base Sepolia testnet
    /// @return NetworkConfig Configuration for Base Sepolia testnet
    function _getBaseSepoliaConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Base Sepolia Testnet",
                chainId: 84_532,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // Default test address
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x41C8f39463A868d3A88af00cd0fe7102F30E44eC,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0x5C210eF41CD1a72de73bF76eC39637bB0d3d7BEE, // TODO: Add VRF v2.5 coordinator for Base Sepolia
                    wrapper: 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed,
                    keyHash: 0x9e1344a1247c8a1785d0a4681a27152bffdb43666ae5bf7d14d24a5efd44bf71, // TODO: Add keyHash for Base Sepolia
                    subscriptionId: 0
                })
            });
    }

    /// @notice Get configuration for BSC Testnet
    /// @return NetworkConfig Configuration for BSC Testnet
    function _getBSCTestnetConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "BSC Testnet",
                chainId: 97,
                admin: 0xB7225d7Ad41E3973f8e18207075F0E72840B6cF6, // Default test address
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: true,
                    coordinator: 0xDA3b641D438362C440Ac5458c57e00a712b66700, // TODO: Add VRF v2.5 coordinator for BSC Testnet
                    wrapper: 0x471506e6ADED0b9811D05B8cAc8Db25eE839Ac94,
                    keyHash: 0x8596b430971ac45bdf6088665b9ad8e8630c9d5049ab54b14dff711bee7c0e26, // TODO: Add keyHash for BSC Testnet
                    subscriptionId: 0
                })
            });
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      LOCAL/DEV CONFIGS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get configuration for local Anvil development
    /// @return NetworkConfig Configuration for local development
    function _getLocalConfig() internal pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                name: "Local Anvil",
                chainId: 31_337,
                admin: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, // Default Anvil address
                erc6551Registry: 0x000000006551c19487814612e58FE06813775758,
                erc6551Implementation: 0x2D25602551487C3f3354dD80D76D54383A243358,
                chainlinkVRF: ChainlinkVRFConfig({
                    enabled: false, // Use pseudo-random for local testing
                    coordinator: address(0),
                    wrapper: address(0),
                    keyHash: bytes32(0),
                    subscriptionId: 0
                })
            });
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      HELPER FUNCTIONS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Get network configuration by chain ID
    /// @param chainId The chain ID to get configuration for
    /// @return NetworkConfig Configuration for the specified chain ID
    function getConfigByChainId(uint256 chainId) public pure returns (NetworkConfig memory) {
        // Mainnets
        if (chainId == 1) return _getMainnetConfig();
        if (chainId == 137) return _getPolygonConfig();
        if (chainId == 42_161) return _getArbitrumConfig();
        if (chainId == 10) return _getOptimismConfig();
        if (chainId == 8453) return _getBaseConfig();
        if (chainId == 56) return _getBSCConfig();

        // Testnets
        if (chainId == 11_155_111) return _getSepoliaConfig();
        if (chainId == 80_002) return _getPolygonAmoyConfig();
        if (chainId == 84_532) return _getBaseSepoliaConfig();
        if (chainId == 97) return _getBSCTestnetConfig();

        // Default to local config for unknown networks (including 31337)
        return _getLocalConfig();
    }

    /// @notice Get configuration for the current network
    /// @return NetworkConfig Configuration for the current network (block.chainid)
    function getCurrentNetworkConfig() public view returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                      VALIDATION                             */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @notice Validate a network configuration
    /// @param config The configuration to validate
    /// @return isValid True if configuration is valid
    /// @return error Error message if configuration is invalid
    function validateConfig(NetworkConfig memory config) public pure returns (bool isValid, string memory error) {
        if (config.admin == address(0)) {
            return (false, "Admin address not set");
        }

        if (config.erc6551Registry == address(0)) {
            return (false, "ERC6551 registry not set");
        }

        if (config.erc6551Implementation == address(0)) {
            return (false, "ERC6551 implementation not set");
        }

        if (config.chainlinkVRF.enabled) {
            if (config.chainlinkVRF.coordinator == address(0)) {
                return (false, "VRF coordinator required when chainlinkVRF is enabled");
            }
            if (config.chainlinkVRF.wrapper == address(0)) {
                return (false, "VRF wrapper required when chainlinkVRF is enabled");
            }
            if (config.chainlinkVRF.keyHash == bytes32(0)) {
                return (false, "VRF keyHash required when chainlinkVRF is enabled");
            }
        }

        return (true, "");
    }
}
