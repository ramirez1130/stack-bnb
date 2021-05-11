var RingBNB = artifacts.require("./contracts/New333.sol");

var account = '0xc5cB6FeA4eF82A63Cb2092e26b30f57c0538823f';

module.exports = function(deployer) {
  deployer.deploy(RingBNB,account, account, account);
};