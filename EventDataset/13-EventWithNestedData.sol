// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract EventWithNestedData {
    struct Transaction {
        address from;
        address to;
        uint256 amount;
        bytes data;
    }
    
    struct Batch {
        uint256 batchId;
        Transaction[] transactions;
        string metadata;
    }
    
    event BatchProcessed(
        uint256 indexed batchId,
        uint256 transactionCount,
        address indexed submitter,
        string metadata
    );
    
    event TransactionLogged(
        uint256 indexed batchId,
        uint256 indexed txIndex,
        address from,
        address to,
        uint256 amount,
        bytes data
    );
    
    function processBatch(Batch memory batch) external {
        emit BatchProcessed(
            batch.batchId,
            batch.transactions.length,
            msg.sender,
            batch.metadata
        );
        
        for(uint i = 0; i < batch.transactions.length; i++) {
            Transaction memory tx = batch.transactions[i];
            emit TransactionLogged(
                batch.batchId,
                i,
                tx.from,
                tx.to,
                tx.amount,
                tx.data
            );
        }
    }
    
    function processMultipleBatches(Batch[] memory batches) external {
        for(uint i = 0; i < batches.length; i++) {
            this.processBatch(batches[i]);
        }
    }
}