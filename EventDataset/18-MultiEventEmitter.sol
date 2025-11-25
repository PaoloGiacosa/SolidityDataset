// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract MultiEventEmitter {
    event TypeA(string data);
    event TypeB(uint256 number);
    event TypeC(address addr);
    event TypeD(bytes raw);
    event TypeE(bool flag, string message);
    
    enum EventType { A, B, C, D, E }
    
    function emitByType(EventType eventType, bytes memory data) external {
        if(eventType == EventType.A) {
            emit TypeA(abi.decode(data, (string)));
        }
        if(eventType == EventType.B) {
            emit TypeB(abi.decode(data, (uint256)));
        }
        if(eventType == EventType.C) {
            emit TypeC(abi.decode(data, (address)));
        }
        if(eventType == EventType.D) {
            emit TypeD(data);
        }
        if(eventType == EventType.E) {
            (bool flag, string memory message) = abi.decode(data, (bool, string));
            emit TypeE(flag, message);
        }
    }
    
    function emitMultiple(EventType[] memory types, bytes[] memory dataArray) external {
        for(uint i = 0; i < types.length; i++) {
            this.emitByType(types[i], dataArray[i]);
        }
    }
}