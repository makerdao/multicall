pragma solidity ^0.4.25;

/// @title Multicall Helper Functions
/// @notice These helper functions are provided in a separate contract because the main multicall contract can't call into itself
/// @author Michael Elliot - <mike@makerdao.com>
/// @author Joshua Levine - <joshua@makerdao.com>

contract MulticallHelper {
    function ethBalanceOf(address addr) public view returns (uint256) {
        return addr.balance;
    }
}
