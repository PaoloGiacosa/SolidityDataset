// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithBytes {
    event DataReceived(bytes data);
    
    function emitData(bytes memory data) external {
        emit DataReceived(data);
    }
}