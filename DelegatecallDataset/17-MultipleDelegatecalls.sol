// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract MultipleDelegatecalls {
    function executeBatch(address[] memory targets, bytes[] memory calls) external {
        for(uint i = 0; i < targets.length; i++) {
            targets[i].delegatecall(calls[i]);
        }
    }
}