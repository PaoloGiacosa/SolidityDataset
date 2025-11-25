// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallStorageSlot {
    bytes32 private constant IMPLEMENTATION_SLOT = keccak256("implementation");
    
    function execute() external {
        address target;
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            target := sload(slot)
        }
        target.delegatecall(msg.data);
    }
}