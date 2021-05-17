const ethers = require("ethers");
const { argv } = require("yargs");

const { Chains, ContractABIs } = require("../constants");

async function deploy_core(network) {
  if (Chains[network]["account"] == undefined) {
    throw new Error(
      "Deployment account is undefined, please define in env variables, see constants.js for: " +
        network
    );
  }

  const provider = new ethers.providers.JsonRpcProvider(
    Chains[network]["rpc"],
    {
      chainId: Chains[network]["chainId"],
      name: Chains[network]["name"],
    }
  );
  let deployerWallet = new ethers.Wallet(Chains[network]["account"], provider);

  console.log("Attempting to deploy from account: " + deployerWallet.address);

  // deploy peppers
  const Multicall = new ethers.ContractFactory(
    ContractABIs.Multicall.abi,
    ContractABIs.Multicall.bytecode,
    deployerWallet
  );

  const multicall = await Multicall.deploy();
  await multicall.deployed();

  console.log("Multicall address:              ", multicall.address);
}

deploy_core(argv.network);
