// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract CalldataDelegatecallBridge {
    event CalldataExtracted(
        bytes32 value1,
        bytes32 value2,
        address target,
        bytes calldataUsed
    );
    
    event DelegatecallExecuted(
        address target,
        bytes32 param1,
        bytes32 param2,
        bool success,
        bytes returnData
    );
    
    event BatchDelegatecallExecuted(
        uint256 callCount,
        address[] targets,
        bool[] results
    );
    
    // Estrae 2 valori dalla calldata e li passa in delegatecall
    function extractAndDelegate(address target, uint256 offset1, uint256 offset2) external {
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            // Carica il primo valore dall'offset1
            value1 := calldataload(offset1)
            // Carica il secondo valore dall'offset2
            value2 := calldataload(offset2)
        }
        
        // Crea i dati per la delegatecall con i 2 valori estratti
        bytes memory delegateData = abi.encode(value1, value2);
        
        (bool success, bytes memory returnData) = target.delegatecall(delegateData);
        
        emit CalldataExtracted(value1, value2, target, delegateData);
        emit DelegatecallExecuted(target, value1, value2, success, returnData);
    }
    
    // Estrae 2 valori consecutivi e fa delegatecall
    function extractConsecutiveAndDelegate(address target, uint256 startOffset) external {
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            value1 := calldataload(startOffset)
            value2 := calldataload(add(startOffset, 32))
        }
        
        bytes memory delegateData = abi.encodePacked(value1, value2);
        
        (bool success, bytes memory returnData) = target.delegatecall(delegateData);
        
        emit DelegatecallExecuted(target, value1, value2, success, returnData);
    }
    
    // Estrae 2 valori e li usa come target e data per delegatecall
    function extractTargetAndData(uint256 targetOffset, uint256 dataOffset) external {
        address target;
        bytes32 data;
        
        assembly {
            // Il primo valore è interpretato come address
            target := calldataload(targetOffset)
            // Il secondo valore è interpretato come data
            data := calldataload(dataOffset)
        }
        
        bytes memory delegateData = abi.encode(data);
        
        (bool success, bytes memory returnData) = target.delegatecall(delegateData);
        
        emit DelegatecallExecuted(target, bytes32(uint256(uint160(target))), data, success, returnData);
    }
    
    // Copia una sezione di calldata e la usa per delegatecall
    function copyAndDelegate(address target, uint256 offset, uint256 length) external {
        bytes memory copiedData = new bytes(length);
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            // Copia i dati dalla calldata
            calldatacopy(add(copiedData, 32), offset, length)
            // Estrae anche i primi 2 valori per l'evento
            value1 := calldataload(offset)
            value2 := calldataload(add(offset, 32))
        }
        
        (bool success, bytes memory returnData) = target.delegatecall(copiedData);
        
        emit CalldataExtracted(value1, value2, target, copiedData);
        emit DelegatecallExecuted(target, value1, value2, success, returnData);
    }
    
    // Estrae 2 valori da offset multipli e fa delegatecall a target diversi
    function extractAndDelegateMultiple(
        address[] memory targets,
        uint256[] memory offsets1,
        uint256[] memory offsets2
    ) external {
        bool[] memory results = new bool[](targets.length);
        
        for(uint i = 0; i < targets.length; i++) {
            bytes32 value1;
            bytes32 value2;
            
            assembly {
                value1 := calldataload(mload(add(add(offsets1, 32), mul(i, 32))))
                value2 := calldataload(mload(add(add(offsets2, 32), mul(i, 32))))
            }
            
            bytes memory delegateData = abi.encode(value1, value2);
            (bool success, ) = targets[i].delegatecall(delegateData);
            results[i] = success;
            
            emit DelegatecallExecuted(targets[i], value1, value2, success, "");
        }
        
        emit BatchDelegatecallExecuted(targets.length, targets, results);
    }
    
    // Usa i primi 2 parametri dopo il selector per delegatecall
    function delegateWithFirstTwoParams(address target) external {
        bytes32 param1;
        bytes32 param2;
        
        assembly {
            // Salta il selector (4 bytes) e leggi i primi 2 parametri
            param1 := calldataload(4)
            param2 := calldataload(36)
        }
        
        bytes memory delegateData = abi.encode(param1, param2);
        (bool success, bytes memory returnData) = target.delegatecall(delegateData);
        
        emit DelegatecallExecuted(target, param1, param2, success, returnData);
    }
    
    // Estrae 2 valori e crea una chiamata con selector custom
    function extractAndDelegateWithSelector(
        address target,
        bytes4 selector,
        uint256 offset1,
        uint256 offset2
    ) external {
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            value1 := calldataload(offset1)
            value2 := calldataload(offset2)
        }
        
        // Crea i dati con selector + parametri
        bytes memory delegateData = abi.encodePacked(selector, value1, value2);
        
        (bool success, bytes memory returnData) = target.delegatecall(delegateData);
        
        emit CalldataExtracted(value1, value2, target, delegateData);
        emit DelegatecallExecuted(target, value1, value2, success, returnData);
    }
    
    // Loop attraverso la calldata estraendo coppie di valori
    function loopExtractAndDelegate(address target, uint256 startOffset, uint256 pairCount) external {
        for(uint i = 0; i < pairCount; i++) {
            bytes32 value1;
            bytes32 value2;
            uint256 currentOffset = startOffset + (i * 64);
            
            assembly {
                value1 := calldataload(currentOffset)
                value2 := calldataload(add(currentOffset, 32))
            }
            
            bytes memory delegateData = abi.encode(value1, value2);
            (bool success, bytes memory returnData) = target.delegatecall(delegateData);
            
            emit DelegatecallExecuted(target, value1, value2, success, returnData);
        }
    }
    
    // Estrae l'intera calldata rimanente e la usa per delegatecall
    function delegateRemainingCalldata(address target, uint256 skipBytes) external {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        
        uint256 remainingSize = size - skipBytes;
        bytes memory remainingData = new bytes(remainingSize);
        
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            calldatacopy(add(remainingData, 32), skipBytes, remainingSize)
            value1 := calldataload(skipBytes)
            value2 := calldataload(add(skipBytes, 32))
        }
        
        (bool success, bytes memory returnData) = target.delegatecall(remainingData);
        
        emit CalldataExtracted(value1, value2, target, remainingData);
        emit DelegatecallExecuted(target, value1, value2, success, returnData);
    }
    
    // Fallback che estrae automaticamente 2 valori e fa delegatecall
    fallback() external payable {
        // Estrae il target dai primi 32 bytes dopo il selector
        address target;
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            target := calldataload(4)
            value1 := calldataload(36)
            value2 := calldataload(68)
        }
        
        bytes memory delegateData = abi.encode(value1, value2);
        target.delegatecall(delegateData);
        
        emit DelegatecallExecuted(target, value1, value2, true, "");
    }
    
    // Estrae 2 valori come address e li usa in una chain di delegatecall
    function chainDelegatecall(uint256 offset1, uint256 offset2) external {
        address target1;
        address target2;
        
        assembly {
            target1 := calldataload(offset1)
            target2 := calldataload(offset2)
        }
        
        // Prima delegatecall
        bytes memory data1 = abi.encode(target2);
        (bool success1, ) = target1.delegatecall(data1);
        
        // Seconda delegatecall
        bytes memory data2 = abi.encode(target1);
        (bool success2, ) = target2.delegatecall(data2);
        
        emit DelegatecallExecuted(
            target1,
            bytes32(uint256(uint160(target1))),
            bytes32(uint256(uint160(target2))),
            success1 && success2,
            ""
        );
    }
    
    // Estrae 2 valori e li passa sia come parametri che come raw data
    function dualDelegatecall(address target, uint256 offset1, uint256 offset2) external {
        bytes32 value1;
        bytes32 value2;
        
        assembly {
            value1 := calldataload(offset1)
            value2 := calldataload(offset2)
        }
        
        // Prima delegatecall con valori encoded
        bytes memory encodedData = abi.encode(value1, value2);
        (bool success1, bytes memory returnData1) = target.delegatecall(encodedData);
        
        // Seconda delegatecall con valori packed
        bytes memory packedData = abi.encodePacked(value1, value2);
        (bool success2, bytes memory returnData2) = target.delegatecall(packedData);
        
        emit DelegatecallExecuted(target, value1, value2, success1, returnData1);
        emit DelegatecallExecuted(target, value1, value2, success2, returnData2);
    }
}
