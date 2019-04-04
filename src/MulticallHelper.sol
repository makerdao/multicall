pragma solidity ^0.4.25;

/// @title Multicall Helper Functions
/// @notice These helper functions are provided in a separate contract because the main multicall contract can't call into itself
/// @author Michael Elliot - <mike@makerdao.com>
/// @author Joshua Levine - <joshua@makerdao.com>

contract MulticallHelper {
    function getEthBalance(address addr) public view returns (uint256 balance) {
        return addr.balance;
    }
    function getBlockHash(uint256 blockNumber) public view returns (bytes32 blockHash) {
        return blockhash(blockNumber);
    }
    function getLastBlockHash() public view returns (bytes32 blockHash, uint256 blockNumber) {
        return (blockhash(block.number - 1), block.number - 1);
    }
}
