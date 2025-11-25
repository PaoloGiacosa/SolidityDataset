// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallGas {
    function execute(address target, bytes memory data, uint gasLimit) external {
        target.delegatecall{gas: gasLimit}(data);
    }
}