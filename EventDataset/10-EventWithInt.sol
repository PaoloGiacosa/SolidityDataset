// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithInt {
    event NumberSigned(int256 value);
    
    function emitSignedNumber(int256 value) external {
        emit NumberSigned(value);
    }
}