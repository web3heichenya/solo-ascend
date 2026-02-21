// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title VRFV2PlusClient
/// @notice VRF v2.5 Client library
/// @author Chainlink Labs
library VRFV2PlusClient {
    /// @notice Extra arguments for the request
    bytes4 public constant EXTRA_ARGS_V1_TAG = bytes4(keccak256("VRF ExtraArgsV1"));
    /// @notice Extra arguments for the request

    struct ExtraArgsV1 {
        bool nativePayment;
    }

    /// @notice Convert extra arguments to bytes
    /// @param extraArgs The extra arguments
    /// @return bts The bytes of the extra arguments
    function _argsToBytes(ExtraArgsV1 memory extraArgs) internal pure returns (bytes memory bts) {
        return abi.encodeWithSelector(EXTRA_ARGS_V1_TAG, extraArgs);
    }
}
