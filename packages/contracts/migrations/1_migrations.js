/* global artifacts */

const Deployer = require("solidity-utils/helpers/Deployer");

const Migrations = artifacts.require("./Migrations.sol");

module.exports = async (defaultDeployer, network) => {
  const deployer = Deployer({ truffleDeployer: defaultDeployer, network });

  await deployer.deploy({ contract: Migrations });
};
