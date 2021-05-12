var RingBNB = artifacts.require("./contracts/New333.sol");

var account = '0x7a687ff7978280eDFc18beA97a5bAdabee2a0a8a';

module.exports = function(deployer) {
  deployer.deploy(RingBNB,account, account, account);
};