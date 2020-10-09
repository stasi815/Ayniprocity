pragma solidity >=0.4.25 <0.6.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Token.sol";

contract TestToken {
  function testInitialBalanceUsingDeployedContract() {
    Token meta = Token(DeployedAddresses.Token());

    uint256 expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 Token initially");
  }

  function testInitialBalanceWithNewToken() {
    Token meta = new Token();

    uint256 expected = 10000;

    Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 Token initially");
  }
}