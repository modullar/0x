pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Exchange.sol";

contract TestExchange{
  function testCreateBid(){
    Exchange exchange = new Exchange(0x3b11c3517b601b4cf6caf2112ca0acff1d25f36a, 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36a, 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36b);
    address expected = 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36b;
    Assert.equal(exchange.getRelayer(), expected, "Relayer should be set");
  }
}
