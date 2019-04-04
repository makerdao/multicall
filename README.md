# Multicall

This smart contract aggregates results from multiple constant function calls.
This reduces the number of separate JSON RPC requests that need to be sent over
the network (especially useful if using remote nodes like Infura), while also
providing the guarantee that all values returned are from the same block (like
an atomic read) and returning the block number the values are from (giving them
important context so that results from old blocks can be ignored if they're from
an out-of-date node).

For use in front-end dapps, this smart contract is intended to be used with
[Multicall.js](https://github.com/makerdao/multicall.js).
