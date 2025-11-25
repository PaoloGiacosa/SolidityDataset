// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithMultipleParams {
    event UserData(address user, uint256 amount, string message);
    
    function emitUserData(address user, uint256 amount, string memory message) external {
        emit UserData(user, amount, message);
    }
}