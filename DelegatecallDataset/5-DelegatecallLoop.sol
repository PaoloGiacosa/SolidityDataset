// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallLoop {
    address public target;
    
    function executeMultiple(uint times) external {
        for(uint i = 0; i < times; i++) {
            target.delegatecall(msg.data);
        }
    }
}