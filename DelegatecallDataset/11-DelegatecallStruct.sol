// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallStruct {
    bytes32 private constant IMPLEMENTATION_SLOT = keccak256("implementation");
    
    struct Call {
        address target;
        bytes data;
    }
    
    function execute(Call memory call) external {
        call.target.delegatecall(call.data);
    }

    function execute() external {
        address target;
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            target := sload(slot)
        }
        target.delegatecall(msg.data);
    }
}