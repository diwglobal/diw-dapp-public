/* global artifacts */

const Deployer = require("solidity-utils/helpers/Deployer");

const LogicV1 = artifacts.require("./LogicV1.sol");

module.exports = async (defaultDeployer, network) => {
  const deployer = Deployer({ truffleDeployer: defaultDeployer, network });

  await deployer.deploy({ contract: LogicV1, name: "LogicV1" });
};
