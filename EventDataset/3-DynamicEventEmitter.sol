// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract DynamicEventEmitter {
    event GenericEvent(
        bytes32 indexed eventType,
        address indexed actor,
        uint256 indexed numericId,
        bytes data,
        string textData,
        uint256[] numbers,
        address[] addresses,
        bytes32 metadata
    );
    
    mapping(bytes32 => uint256) public eventCounts;
    
    function emitGeneric(
        bytes32 eventType,
        bytes memory data,
        string memory textData,
        uint256[] memory numbers,
        address[] memory addresses,
        bytes32 metadata
    ) external {
        uint256 eventId = eventCounts[eventType]++;
        
        emit GenericEvent(
            eventType,
            msg.sender,
            eventId,
            data,
            textData,
            numbers,
            addresses,
            metadata
        );
    }
    
    function emitWithRawCalldata() external {
        bytes32 eventType = keccak256("RAW_CALLDATA");
        uint256 eventId = eventCounts[eventType]++;
        
        uint256[] memory empty;
        address[] memory emptyAddr;
        
        emit GenericEvent(
            eventType,
            msg.sender,
            eventId,
            msg.data,
            "",
            empty,
            emptyAddr,
            bytes32(0)
        );
    }
    
    function emitBatchGeneric(
        bytes32[] memory eventTypes,
        bytes[] memory dataArray,
        string[] memory textDataArray
    ) external {
        for(uint i = 0; i < eventTypes.length; i++) {
            uint256 eventId = eventCounts[eventTypes[i]]++;
            uint256[] memory empty;
            address[] memory emptyAddr;
            
            emit GenericEvent(
                eventTypes[i],
                msg.sender,
                eventId,
                dataArray[i],
                textDataArray[i],
                empty,
                emptyAddr,
                bytes32(0)
            );
        }
    }
}