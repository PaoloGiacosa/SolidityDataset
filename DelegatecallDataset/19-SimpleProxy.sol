// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract SimpleProxy {
    address public implementation;
    
    constructor(address _implementation) {
        implementation = _implementation;
    }
    
    fallback() external payable {
        implementation.delegatecall(msg.data);
    }
}