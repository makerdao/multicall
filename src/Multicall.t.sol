pragma solidity ^0.4.25;

import "ds-test/test.sol";
import "./Multicall.sol";
import "./BytesLib.sol";

contract Store {
    uint256 internal val;
    function set(uint256 _val) public { val = _val; }
    function get() public view returns (uint256) { return val; }
    function getAnd10() public view returns (uint256, uint256) { return (val, 10); }
    function getAdd(uint256 _val) public view returns (uint256) { return val + _val; }
}

contract Utils {
    function toBytesUint(uint256 x) returns (bytes b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function toBytesAddress(address x) returns (bytes b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}

// We inherit from Multicall rather than deploy an instance because solidity
// can't return dynamically sized byte arrays from external contracts
contract MulticallTest is DSTest, Multicall, Utils {
    using BytesLib for bytes;

    Store public storeA;
    Store public storeB;

    function setUp() public {
        storeA = new Store();
        storeB = new Store();
    }

    function test_store_basic_sanity() public {
        assertEq(storeA.get(), 0);
        storeA.set(100);
        assertEq(storeA.get(), 100);
        storeA.set(0);
        assertEq(storeA.get(), 0);
    }

    function test_single_call_single_return_no_args() public {
        storeA.set(123);
        bytes memory _data = toBytesUint(1) // total number of return vals
            .concat(toBytesAddress(storeA)) // target address
            .concat(toBytesUint(1))         // number return vals for the next call
            .concat(toBytesUint(64))        // location of calldata
            .concat(toBytesUint(4))         // length of call data
            .concat(abi.encodeWithSignature("get()")); // method selector
        bytes memory _result    = aggregate(_data);
        bytes memory _finalWord = _result.slice(32, 32);
        uint256 _returnVal;
        assembly { _returnVal := mload(add(0x20, _finalWord)) }
        assertEq(_returnVal, 123);
    }

    function test_multi_call_single_return_no_args() public {
        storeA.set(123);
        storeB.set(321);
        bytes memory _data = toBytesUint(2)
            .concat(toBytesAddress(storeA))
            .concat(toBytesUint(1))
            .concat(toBytesUint(64))
            .concat(toBytesUint(4))
            .concat(abi.encodeWithSignature("get()"))
            .concat(toBytesAddress(storeB))
            .concat(toBytesUint(1))
            .concat(toBytesUint(64))
            .concat(toBytesUint(4))
            .concat(abi.encodeWithSignature("get()"));

        bytes memory _result     = aggregate(_data);
        bytes memory _secondWord = _result.slice(32, 32);
        bytes memory _finalWord  = _result.slice(64, 32);

        uint256 _returnValA;
        uint256 _returnValB;
        assembly {
            _returnValA := mload(add(0x20, _secondWord))
            _returnValB := mload(add(0x20, _finalWord))
        }
        assertEq(_returnValA, 123);
        assertEq(_returnValB, 321);
    }

    function test_single_call_single_return_single_arg() public {
        storeA.set(123);
        bytes memory _data = toBytesUint(1)
            .concat(toBytesAddress(storeA))
            .concat(toBytesUint(1))
            .concat(toBytesUint(64))
            .concat(toBytesUint(36))
            .concat(abi.encodeWithSignature("getAdd(uint256)", 1));

        bytes memory _result    = aggregate(_data);
        bytes memory _finalWord = _result.slice(32, 32);
        uint256 _returnVal;
        assembly { _returnVal := mload(add(0x20, _finalWord)) }
        assertEq(_returnVal, 124);
    }

    function test_multi_call_single_return_single_arg() public {
        storeA.set(123);
        storeB.set(321);
        bytes memory _data = toBytesUint(2)
            .concat(toBytesAddress(storeA))
            .concat(toBytesUint(1))
            .concat(toBytesUint(64))
            .concat(toBytesUint(36))
            .concat(abi.encodeWithSignature("getAdd(uint256)", 1))
            .concat(toBytesAddress(storeB))
            .concat(toBytesUint(1))
            .concat(toBytesUint(64))
            .concat(toBytesUint(36))
            .concat(abi.encodeWithSignature("getAdd(uint256)", 1));

        bytes memory _result     = aggregate(_data);
        bytes memory _secondWord = _result.slice(32, 32);
        bytes memory _finalWord  = _result.slice(64, 32);

        uint256 _returnValA;
        uint256 _returnValB;
        assembly {
            _returnValA := mload(add(0x20, _secondWord))
            _returnValB := mload(add(0x20, _finalWord))
        }
        assertEq(_returnValA, 124);
        assertEq(_returnValB, 322);
    }

    function test_single_call_multi_return_no_args() public {
        storeA.set(123);
        bytes memory _data = toBytesUint(2)
            .concat(toBytesAddress(storeA))
            .concat(toBytesUint(2))
            .concat(toBytesUint(64))
            .concat(toBytesUint(4))
            .concat(abi.encodeWithSignature("getAnd10()"));

        bytes memory _result     = aggregate(_data);
        bytes memory _secondWord = _result.slice(32, 32);
        bytes memory _finalWord  = _result.slice(64, 32);

        uint256 _returnValA1;
        uint256 _returnValA2;
        assembly {
            _returnValA1 := mload(add(0x20, _secondWord))
            _returnValA2 := mload(add(0x20, _finalWord))
        }
        assertEq(_returnValA1, 123);
        assertEq(_returnValA2, 10);
    }
}
