module.exports = function(deployer) {
  return deployer.deploy(artifacts.require("Migrations"));
};
