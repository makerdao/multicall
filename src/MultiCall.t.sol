pragma solidity ^0.4.24;

import "ds-test/test.sol";

import "./MultiCall.sol";

contract MultiCallTest is DSTest {
    MultiCall multicall;

    function setUp() public {
        multicall = new MultiCall();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
