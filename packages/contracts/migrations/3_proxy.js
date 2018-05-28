/* global artifacts */

const Deployer = require("solidity-utils/helpers/Deployer");

const Proxy_ = artifacts.require("./Proxy.sol");

module.exports = async (defaultDeployer, network) => {
  const deployer = Deployer({ truffleDeployer: defaultDeployer, network });
  const addresses = deployer.getAddresses();
  const diwTokenAddress =
    network === "mainnet"
      ? "0xa253be28580ae23548a4182d95bf8201c28369a8"
      : "0x2c7c996ccdf520ba06a3bdc1d7d9fcd937a7fae9";

  await deployer.deploy(
    { contract: Proxy_, name: "Proxy" },
    diwTokenAddress,
    addresses.LogicV1
  );
};
