// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallSelector {
    address public implementation;
    
    function execute(bytes4 selector, bytes memory params) external {
        bytes memory data = abi.encodePacked(selector, params);
        implementation.delegatecall(data);
    }
}