pragma solidity ^0.4.24;

import "ds-test/test.sol";

import "./Multicall.sol";

contract MulticallTest is DSTest {
    Multicall multicall;

    function setUp() public {
        multicall = new Multicall();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
