var RingBNB = artifacts.require("./contracts/New333.sol");

var account = '0x37A05CF3406e3F4a6367D6b565d7F682474BCdEe';

module.exports = function(deployer) {
  deployer.deploy(RingBNB,account, account, account);
};