// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract CalldataManipulator {
    event CalldataExtracted(
        bytes4 selector,
        bytes32 firstParam,
        bytes extractedData,
        uint256 calldataSize
    );
    
    event RawCalldataProcessed(
        bytes fullCalldata,
        bytes32[] extractedWords,
        address[] extractedAddresses
    );
    
    event CustomDataLoaded(
        bytes32 dataAtOffset,
        bytes slicedData,
        uint256 offset,
        uint256 length
    );
    
    function extractCalldataAtOffset(uint256 offset) external {
        bytes32 data;
        
        assembly {
            data := calldataload(offset)
        }
        
        emit CustomDataLoaded(data, "", offset, 32);
    }
    function copyCalldataSlice(uint256 offset, uint256 length) external {
        bytes memory copiedData = new bytes(length);
        
        assembly {
            calldatacopy(add(copiedData, 32), offset, length)
        }
        
        bytes32 firstWord;
        assembly {
            firstWord := calldataload(offset)
        }
        
        emit CustomDataLoaded(firstWord, copiedData, offset, length);
    }
    
    function processFullCalldata() external {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
        bytes memory fullData = new bytes(size);
        assembly {
            calldatacopy(add(fullData, 32), 0, size)
        }
        
        bytes4 selector;
        assembly {
            selector := calldataload(0)
        }
        bytes32 firstParam;
        assembly {
            firstParam := calldataload(4)
        }
        
        emit CalldataExtracted(selector, firstParam, fullData, size);
    }
    
    function extractMultipleWords(uint256 startOffset, uint256 wordCount) external {
        bytes32[] memory words = new bytes32[](wordCount);
        
        assembly {
            let offset := startOffset
            for { let i := 0 } lt(i, wordCount) { i := add(i, 1) } {
                let word := calldataload(offset)
                mstore(add(add(words, 32), mul(i, 32)), word)
                offset := add(offset, 32)
            }
        }
        
        uint256 totalSize = wordCount * 32;
        bytes memory rawData = new bytes(totalSize);
        assembly {
            calldatacopy(add(rawData, 32), startOffset, totalSize)
        }
        
        address[] memory emptyAddresses;
        emit RawCalldataProcessed(rawData, words, emptyAddresses);
    }
    
    
    function manipulateAndEmit(uint256 modifyOffset, bytes32 newValue) external {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
 
        bytes memory modifiedData = new bytes(size);
        assembly {
            calldatacopy(add(modifiedData, 32), 0, size)
        }
        
        assembly {
            mstore(add(add(modifiedData, 32), modifyOffset), newValue)
        }
        
        bytes4 selector;
        bytes32 originalAtOffset;
        assembly {
            selector := calldataload(0)
            originalAtOffset := calldataload(modifyOffset)
        }
        
        emit CalldataExtracted(selector, originalAtOffset, modifiedData, size);
    }
    
    function extractDynamicParams() external {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
        bytes memory fullCalldata = new bytes(size);
        assembly {
            calldatacopy(add(fullCalldata, 32), 0, size)
        }
        

        bytes32[] memory extractedWords = new bytes32[](5);
        
        assembly {
            for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
                let offset := add(4, mul(i, 32))
                let word := calldataload(offset)
                mstore(add(add(extractedWords, 32), mul(i, 32)), word)
            }
        }
        
        address[] memory emptyAddresses;
        emit RawCalldataProcessed(fullCalldata, extractedWords, emptyAddresses);
    }
    
    function loopThroughCalldata(uint256 step) external {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
        uint256 iterations = size / step;
        bytes32[] memory chunks = new bytes32[](iterations);
        
        assembly {
            let offset := 0
            for { let i := 0 } lt(i, iterations) { i := add(i, 1) } {
                let chunk := calldataload(offset)
                mstore(add(add(chunks, 32), mul(i, 32)), chunk)
                offset := add(offset, step)
            }
        }
        
        bytes memory fullData = new bytes(size);
        assembly {
            calldatacopy(add(fullData, 32), 0, size)
        }
        
        address[] memory emptyAddresses;
        emit RawCalldataProcessed(fullData, chunks, emptyAddresses);
    }
    fallback() external payable {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
        bytes memory data = new bytes(size);
        assembly {
            calldatacopy(add(data, 32), 0, size)
        }
        
        bytes4 selector;
        bytes32 firstParam;
        assembly {
            selector := calldataload(0)
            firstParam := calldataload(4)
        }
        
        emit CalldataExtracted(selector, firstParam, data, size);
    }
    
    receive() external payable {
        emit CalldataExtracted(bytes4(0), bytes32(0), "", 0);
    }
}