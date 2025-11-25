// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DelegatecallNested {
    function executeOuter(address outer, address inner, bytes memory data) external {
        bytes memory outerData = abi.encodeWithSignature("execute(address,bytes)", inner, data);
        outer.delegatecall(outerData);
    }
}