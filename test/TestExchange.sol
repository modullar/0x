pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Exchange.sol";

contract TestExchange{


  address relayer;
  address maker;
  address taker;

  Exchange exchange;

  function beforeEach() {
    maker = 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36a;
    taker = 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36b;
    relayer = 0x3b11c3517b601b4cf6caf2112ca0acff1d25f36c;
    exchange = new Exchange(maker, taker, relayer);
  }

  function testInitExchange(){
    Assert.equal(exchange.getRelayer(), relayer, "Relayer should be set");
    Assert.equal(exchange.getTaker(), taker, "Relayer should be set");
    Assert.equal(exchange.getMaker(), maker, "Relayer should be set");
  }

  function testCreateBid(){
    Assert.equal(exchange.doCreateBid(maker), true, "Maker could create a bid");
    Assert.equal(exchange.bidsCount(), 1, "A new bid will be created");
    var (m, t, r, s, b) = (exchange.getBid(0));
    Assert.equal(m, maker, "the right maker should be set");
    Assert.equal(r, maker, "the bid still has no relayer");
    Assert.equal(t, maker, "the bid still has no taker");
    Assert.equal(b, bytes32('created'), "the right status should be set");
    Assert.equal(exchange.doCreateBid(taker), false, "Taker could not create a bid");
  }

  function testPostBid(){
    exchange.doCreateBid(maker);
    Assert.equal(exchange.doPostBid(maker, 0), false, "Bid cannot be posted by maker");
    Assert.equal(exchange.doPostBid(relayer, 0), true, "Bid will be posted by the relayer");
    var (m, t, r, s, b) = (exchange.getBid(0));
    Assert.equal(b, bytes32('posted'), "Bid will be posted by the relayer");
    Assert.equal(r, relayer, "Assign relayer to the posted bid");
  }

  function testInterceptBid(){
    exchange.doCreateBid(maker);
    Assert.equal(exchange.doInterceptBid(taker, 0), false, "Cannot intercept unposted Bid");
    exchange.doPostBid(relayer, 0);
    Assert.equal(exchange.doInterceptBid(taker, 0), true, "Bid is intercepted");
    var (m, t, r, s, b) = (exchange.getBid(0));
    Assert.equal(b, bytes32('intercepted'), "Intercepted status is changed");
    Assert.equal(t, taker , "taker was assigned");
  }
}
