// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.27;

/// @notice Onchain inference ("Oni").
/// @author nani.eth (nani.ooo)
/// @dev V0: ETH & ERC20 sends.
contract Oni {
    function checkCall(
        address user,
        address target, 
        uint256 value, 
        bytes calldata data
    ) public view returns (bool safe, string memory reason) {
        unchecked {
            if (user == address(0)) return (false, "Invalid user.");
            if (target == address(0)) return (false, "Invalid target.");
            if (value != 0) if (value > (user.balance * 50 / 100)) {
                return (false, "Call exceeds 50% of user ETH balance.");
            } else {
                if (target.code.length == 0) return (false, "Invalid target.");
                if (bytes4(data) != IERC20.transfer.selector) return (false, "Invalid function call.");
                (address to, uint256 amount) = abi.decode(data[4:], (address, uint256));
                if (to == address(0)) return (false, "Invalid receiver.");
                if (amount == 0) return (false, "Invalid amount.");
                if (amount > (IERC20(target).balanceOf(user) * 50 / 100)) {
                    return (false, "Call exceeds 50% of user ETH balance.");
                } 
            }
        }
    }
}

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external view returns (bool);
}
