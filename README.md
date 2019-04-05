# Multicall

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
| Network | Contract        | Address |
| ------- | --------------- | ------- |
| Mainnet | Multicall       | [0x466fbff54d2123c36e9cfaf90298ba436250c043](https://etherscan.io/address/0x466fbff54d2123c36e9cfaf90298ba436250c043#code) |
| Mainnet | MulticallHelper | [0x36e75e2c9e6a123a36c4ac88765a5dd1d6d0c350](https://etherscan.io/address/0x36e75e2c9e6a123a36c4ac88765a5dd1d6d0c350#code) |
| Kovan   | Multicall       | [0xc49ab4d7de648a97592ed3d18720e00356b4a806](https://kovan.etherscan.io/address/0xc49ab4d7de648a97592ed3d18720e00356b4a806#code) |
| Kovan   | MulticallHelper | [0x4e37eebb78e130316bc5e4cef80a8a2d8dcfb084](https://kovan.etherscan.io/address/0x4e37eebb78e130316bc5e4cef80a8a2d8dcfb084#code) |
| Rinkeby | Multicall       | [0x67482a4499dbef2a65862d751a7ef2b4a0785475](https://rinkeby.etherscan.io/address/0x67482a4499dbef2a65862d751a7ef2b4a0785475#code) |
| Rinkeby | MulticallHelper | [0x12a3f008055dc55fe9197ba13d4f10101a71b591](https://rinkeby.etherscan.io/address/0x12a3f008055dc55fe9197ba13d4f10101a71b591#code) |
