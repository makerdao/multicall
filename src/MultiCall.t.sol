pragma solidity ^0.4.23;

import "ds-test/test.sol";
import "./MultiCall.sol";

contract Store {
    uint256 internal val;
    function set(uint256 _val) public { val = _val; }
    function get() public view returns (uint256) { return val; }
}

contract MultiCallTest is DSTest {
    MultiCall multicall;
    Store        storeA;
    Store        storeB;

    function setUp() public {
        multicall = new MultiCall();
        storeA    = new Store();
        storeB    = new Store();
    }

    function test_store_basic_sanity() public {
        assertEq(storeA.get(), 0);
        storeA.set(100);
        assertEq(storeA.get(), 100);
        storeA.set(0);
        assertEq(storeA.get(), 0);
    }
}
