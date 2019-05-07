pragma solidity >=0.4.25;

import "ds-test/test.sol";
import "./Multicall.sol";

contract Store {
    uint256 internal val;
    function set(uint256 _val) public { val = _val; }
    function setAndGetValue(uint256 _val) public returns (uint256) { val = _val; return _val; }
    function get() public view returns (uint256) { return val; }
    function getAnd10() public view returns (uint256, uint256) { return (val, 10); }
    function getAdd(uint256 _val) public view returns (uint256) { return val + _val; }
}

contract Utils {
    function toBytesUint(uint256 x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }

    function toBytesAddress(address x) public pure returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
}

// We inherit from Multicall rather than deploy an instance because solidity
// can't return dynamically sized byte arrays from external contracts
contract MulticallTest is DSTest, Multicall, Utils {
    Store public storeA;
    Store public storeB;

    function getWordAsUint(bytes memory data, uint init) internal pure returns (uint ret) {
        bytes memory word = new bytes(32);
        for (uint i = init; i < init + 32; i++) {
            word[i - init] = data[i];
        }

        assembly {
            ret := mload(add(0x20, word))
        }
    }

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

        bytes memory _data = abi.encodePacked(
            uint(1),                                // total number of return vals
            abi.encode(
                uint(address(storeA)),              // target address
                uint(1)                             // number return vals for the next call
            ),
            uint(64),                               // location of calldata
            uint(4),                                // length of call data
            bytes4(keccak256("get()"))              // method selector
        );

        bytes memory _result = aggregate(_data);
        uint _returnVal = getWordAsUint(_result, 32);
        assertEq(_returnVal, 123);
    }

    function test_multi_call_single_return_no_args() public {
        storeA.set(123);
        storeB.set(321);

        bytes memory _data = abi.encodePacked(
            uint(2),
            abi.encode(
                uint(address(storeA)),
                uint(1)
            ),
            uint(64),
            uint(4),
            bytes4(keccak256("get()")),
            abi.encode(
                uint(address(storeB)),
                uint(1)
            ),
            uint(64),
            uint(4),
            bytes4(keccak256("get()"))
        );

        bytes memory _result = aggregate(_data);
        uint _returnValA = getWordAsUint(_result, 32);
        uint _returnValB = getWordAsUint(_result, 64);
        assertEq(_returnValA, 123);
        assertEq(_returnValB, 321);
    }

    function test_single_call_single_return_single_arg() public {
        storeA.set(123);

        bytes memory _data = abi.encodePacked(
            uint(1),
            abi.encode(
                uint(address(storeA)),
                uint(1)
            ),
            uint(64),
            uint(36),
            bytes4(keccak256("getAdd(uint256)")),
            uint(1)
        );

        bytes memory _result = aggregate(_data);
        uint _returnVal = getWordAsUint(_result, 32);
        assertEq(_returnVal, 124);
    }

    function test_multi_call_single_return_single_arg() public {
        storeA.set(123);
        storeB.set(321);

        bytes memory _data = abi.encodePacked(
            uint(2),
            abi.encode(
                uint(address(storeA)),
                uint(1)
            ),
            uint(64),
            uint(36),
            bytes4(keccak256("getAdd(uint256)")),
            uint(1),
            abi.encode(
                uint(address(storeB)),
                uint(1)
            ),
            uint(64),
            uint(36),
            bytes4(keccak256("getAdd(uint256)")),
            uint(1)
        );

        bytes memory _result = aggregate(_data);
        uint _returnValA = getWordAsUint(_result, 32);
        uint _returnValB = getWordAsUint(_result, 64);
        assertEq(_returnValA, 124);
        assertEq(_returnValB, 322);
    }

    function test_single_call_multi_return_no_args() public {
        storeA.set(123);

        bytes memory _data = abi.encodePacked(
            uint(2),
            abi.encode(
                uint(address(storeA)),
                uint(2)
            ),
            uint(64),
            uint(4),
            bytes4(keccak256("getAnd10()"))
        );

        bytes memory _result = aggregate(_data);
        uint _returnValA = getWordAsUint(_result, 32);
        uint _returnValB = getWordAsUint(_result, 64);
        assertEq(_returnValA, 123);
        assertEq(_returnValB, 10);
    }

    function test_single_call_dynamic_value() public {
        bytes memory _data = abi.encodePacked(
            uint(1),
            abi.encode(
                uint(address(storeA)),
                uint(1)
            ),
            uint(64),
            uint(36),
            bytes4(keccak256("setAndGetValue(uint256)")),
            uint(25)
        );

        bytes memory _result = aggregate(_data);
        uint _returnVal = getWordAsUint(_result, 32);
        assertEq(_returnVal, 25);
    }
}
