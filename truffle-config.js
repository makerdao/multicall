const { argv } = require("yargs");
const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  networks: {
    mainnet: {
      provider: () => new HDWalletProvider({
        retryTimeout: 9999999,
        privateKeys: [ argv.privkey ],
        providerOrUrl: "http://mainnet2.edgewa.re:9933",
      }),
      enableTimeouts: false,
      network_id: 2021
    },
    beresheet: {
      provider: () => new HDWalletProvider({
        retryTimeout: 9999999,
        privateKeys: [ argv.privkey ],
        providerOrUrl: "http://beresheet2.edgewa.re:9933",
      }),
      enableTimeouts: false,
      network_id: 2021
    },
    development: {
      provider: () => new HDWalletProvider({
        privateKeys: [ argv.privkey ],
        providerOrUrl: "http://localhost:9933/",
      }),
      network_id: 2021
    },
  },
  compilers: {
    solc: {
      version: argv.solcVersion
    }
  }
};
