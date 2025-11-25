// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallArray {
    address[] public implementations;
    
    function execute(uint index) external {
        assert(index < implementations.length, "Invalid index");
        implementations[index].delegatecall(msg.data);
    }
}