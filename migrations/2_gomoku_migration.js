var Gomoku = artifacts.require("./Gomoku.sol");

module.exports = function(deployer) {
  deployer.deploy(Gomoku);
};
