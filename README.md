# Multicall <img width="100" align="right" alt="Multicall" src="https://user-images.githubusercontent.com/304108/55666937-320cb180-5888-11e9-907b-48ba66150523.png" />

Multicall aggregates results from multiple contract constant function calls.

This reduces the number of separate JSON RPC requests that need to be sent
(especially useful if using remote nodes like Infura), while also providing the
guarantee that all values returned are from the same block (like an atomic read)
and returning the block number the values are from (giving them important
context so that results from old blocks can be ignored if they're from an
out-of-date node).

For use in front-end dapps, this smart contract is intended to be used with
[Multicall.js](https://github.com/makerdao/multicall.js).

### Contract Addresses
| Chain   | Address |
| ------- | ------- |
| Beresheet | 0x4e30a26DF49321346079124Cb92a62b6DBE4D8Bb |
| Rinkeby | 0x609C552688c73E428d6930a727F8a0c2d7966E14 |

### Compile
- `yarn compile`
### Deploying

- `yarn deploy:rinkeby`
- `yarn deploy:beresheet`

### License
Multicall is MIT licensed.