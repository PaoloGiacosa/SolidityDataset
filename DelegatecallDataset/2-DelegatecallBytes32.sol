// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallBytes32 {
    bytes32 public targetHash;
    
    function execute(address target, bytes32 dataHash) external {
        bytes memory data = abi.encode(dataHash);
        target.delegatecall(data);
    }
}