// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventStorageLogger {
    event DataStored(uint256 indexed id, bytes32 hash, bytes data);
    event DataUpdated(uint256 indexed id, bytes32 oldHash, bytes32 newHash);
    event DataDeleted(uint256 indexed id, bytes32 hash);
    
    uint256 private counter;
    mapping(uint256 => bytes32) public dataHashes;
    
    function storeData(bytes memory data) external returns (uint256) {
        uint256 id = counter++;
        bytes32 hash = keccak256(data);
        dataHashes[id] = hash;
        emit DataStored(id, hash, data);
        return id;
    }
    
    function updateData(uint256 id, bytes memory newData) external {
        bytes32 oldHash = dataHashes[id];
        bytes32 newHash = keccak256(newData);
        dataHashes[id] = newHash;
        emit DataUpdated(id, oldHash, newHash);
    }
    
    function deleteData(uint256 id) external {
        bytes32 hash = dataHashes[id];
        delete dataHashes[id];
        emit DataDeleted(id, hash);
    }
}