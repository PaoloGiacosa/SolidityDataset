// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithBool {
    event StatusChanged(bool status, string reason);
    
    function emitStatus(bool status, string memory reason) external {
        emit StatusChanged(status, reason);
    }
}