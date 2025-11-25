// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithBytes32 {
    event HashStored(bytes32 hash);
    
    function emitHash(bytes32 hash) external {
        emit HashStored(hash);
    }
}