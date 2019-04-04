pragma solidity ^0.4.24;

/// @title Multicall - Aggregate multiple constant function call results into one
/// @author Michael Elliot - <mike@makerdao.com>
/// @author Joshua Levine - <joshua@makerdao.com>

contract MultiCall {
    function aggregate(bytes memory data) public view returns (bytes memory) {
        uint256 malloc;
        assembly { malloc := add(mul(mload(add(data, 0x20)), 0x20), 0x20) }
        bytes memory results = new bytes(malloc);
        uint256 _block = block.number;
        assembly {
            mstore(add(results, 0x20), _block)
            let ptr := mload(0x40)
            let cur := 0x40
            let inc := 2
            let len := mload(data)
            for { } lt(cur, len) { } {
                let _target     := mload(add(data, cur))
                let _retLen     := mul(mload(add(data, add(cur, 0x20))), 0x20)
                let _dataLength := mload(add(data, add(cur, 0x60)))
                let _data       := add(data, add(cur, 0x80))
                if eq(call(gas, _target, 0, _data, _dataLength, ptr, _retLen), 0)
                    { revert(0, 0) }
                for { let offset := 0 } lt(offset, _retLen) { offset := add(offset, 0x20) }
                    { mstore(add(results, add(mul(inc, 0x20), offset)), mload(add(ptr, offset))) }
                inc := add(inc, mload(add(data, add(cur, 0x20))))
                cur := add(cur, add(0x80, _dataLength))
            }
        }
        return results;
    }
}
