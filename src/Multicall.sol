pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;

/// @title Multicall2 - Aggregate results from multiple read-only function calls. Allow failures
/// @author Michael Elliot <mike@makerdao.com>
/// @author Joshua Levine <joshua@makerdao.com>
/// @author Nick Johnson <arachnid@notdot.net>
/// @author Bryan Stitt <bryan@satoshiandkin.com>

contract Multicall2 {
    struct Call {
        address target;
        bytes callData;
    }

    struct Result {
        bool success;
        bytes ret;
    }

    // public functions
    function try_block_and_aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData) {
        blockNumber = block.number;
        blockHash = blockhash(blockNumber);
        returnData = try_aggregate(calls);
    }
    function try_aggregate(Call[] memory calls) public returns (Result[] memory returnData) {
        returnData = new Result[](calls.length);

        for(uint256 i = 0; i < calls.length; i++) {
            // we use low level calls to intionally allow calling arbitrary functions.
            // solium-disable-next-line security/no-low-level-calls
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);

            // TODO? optionally require(success, "Multicall2 aggregate: call failed");

            returnData[i] = Result(success, ret);
        }
    }

    // old aggregate method. requires all calls to succeed
    function aggregate(Call[] memory calls) public returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        returnData = new bytes[](calls.length);
        for(uint256 i = 0; i < calls.length; i++) {
            // we use low level calls to intionally allow calling arbitrary functions.
            // solium-disable-next-line security/no-low-level-calls
            (bool success, bytes memory ret) = calls[i].target.call(calls[i].callData);
            require(success, "Multicall2 aggregate: call failed");
            returnData[i] = ret;
        }
    }

    // Helper functions
    function getBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number);
    }
    function getBlockNumber() public view returns (uint256 blockNumber) {
        blockNumber = block.number;
    }
    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }
    function getCurrentBlockDifficulty() public view returns (uint256 difficulty) {
        difficulty = block.difficulty;
    }
    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }
    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }
    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }
    function getLastBlockHash() public view returns (bytes32 blockHash) {
        blockHash = blockhash(block.number - 1);
    }
}
