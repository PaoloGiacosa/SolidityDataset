
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DynamicDelegatecall {
    function execute(address target, string memory signature, bytes memory params) external {
        bytes memory data = abi.encodePacked(bytes4(keccak256(bytes(signature))), params);
        target.delegatecall(data);
    }
    
    function executeRaw(address target) external {
        assembly {
            let ptr := mload(0x40)
            let dataSize := sub(calldatasize(), 4)
            calldatacopy(ptr, 4, dataSize)
            let result := delegatecall(gas(), target, ptr, dataSize, 0, 0)
            if iszero(result) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }
    
    function executeWithSelector(address target, bytes4 selector) external {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, selector)
            let dataSize := sub(calldatasize(), 36)
            calldatacopy(add(ptr, 4), 36, dataSize)
            let result := delegatecall(gas(), target, ptr, add(dataSize, 4), 0, 0)
            if iszero(result) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }
    
    function multiDelegatecall(address[] memory targets, bytes[] memory datas) external {
        require(targets.length == datas.length, "Length mismatch");
        
        for (uint i = 0; i < targets.length; i++) {
            assembly {
                let data := mload(add(datas, add(32, mul(i, 32))))
                let length := mload(data)
                let result := delegatecall(gas(), mload(add(targets, add(32, mul(i, 32)))), add(data, 32), length, 0, 0)
                if iszero(result) {
                    returndatacopy(0, 0, returndatasize())
                    revert(0, returndatasize())
                }
            }
        }
    }
    
    function executeFromCalldata() external {
        assembly {
            let target := calldataload(4)
            let dataOffset := calldataload(36)
            let dataLength := calldataload(68)
            
            let ptr := mload(0x40)
            calldatacopy(ptr, dataOffset, dataLength)
            
            let result := delegatecall(gas(), target, ptr, dataLength, 0, 0)
            if iszero(result) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }
}
