// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract ComplexEventLogger {
    event ComplexLog(
        address indexed sender,
        bytes32 indexed category,
        uint256 timestamp,
        bytes data,
        string[] tags,
        uint256 value
    );
    
    function logComplex(
        bytes32 category,
        bytes memory data,
        string[] memory tags
    ) external payable {
        emit ComplexLog(
            msg.sender,
            category,
            block.timestamp,
            data,
            tags,
            msg.value
        );
    }
    
    function logBatch(
        bytes32[] memory categories,
        bytes[] memory dataArray,
        string[][] memory tagsArray
    ) external {
        for(uint i = 0; i < categories.length; i++) {
            emit ComplexLog(
                msg.sender,
                categories[i],
                block.timestamp,
                dataArray[i],
                tagsArray[i],
                0
            );
        }
    }
}