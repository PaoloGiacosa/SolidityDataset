// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// Contract 1: Delegatecall base con msg.data
contract SimpleDelegatecall {
    address public target;
    
    constructor(address _target) {
        target = _target;
    }
    
    fallback() external payable {
        target.delegatecall(msg.data);
    }
}
