// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithValue {
    event ValueReceived(uint256 value, string note);
    
    function emitValue(string memory note) external payable {
        emit ValueReceived(msg.value, note);
    }
}