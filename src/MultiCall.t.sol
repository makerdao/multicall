pragma solidity ^0.4.24;

import "ds-test/test.sol";

import "./MultiCall.sol";

contract Store {
    uint256 internal val;
    function set(uint256 _val) public { val = _val; }
    function get() public view returns (uint256) { return val; }
}

contract MultiCallTest is DSTest {
    MultiCall multicall;
    Store         store;

    function setUp() public {
        multicall = new MultiCall();
        store     = new Store();
    }

    function test_store_basic_sanity() public {
        assertEq(store.get(), 0);
        store.set(100);
        assertEq(store.get(), 100);
        store.set(0);
        assertEq(store.get(), 0);
    }

    function test_single_call() public {
        store.set(123);

        bytes4  sig = bytes4(keccak256("get()"));
        uint256 ret = multicall.multiCallTest(store, sig);
        assertEq(ret, 123);
    }
}
