pragma solidity ^0.4.18;
contract Exchange {

  address public maker;
  address public taker;
  address public relayer;


  struct Bid {
    address maker;
    address taker;
    address relayer;
    string status;
  }

  Bid[] public bids;


  uint256 storedData;



  function Exchange(address makerAddress, address takerAddress, address relayerAddress ) public {
    maker = makerAddress;
    taker = takerAddress;
    relayer = relayerAddress;
  }

  function getRelayer() public returns (address){
    return relayer;
  }

  function createBid() public returns (bool){
    if(msg.sender == maker){
      Bid memory bid = Bid({maker: msg.sender, taker: msg.sender, relayer: msg.sender, status: 'created'});
      bids.push(bid);
      return true;
    }
    return false;
  }

  function PostBid() public returns (bool) {
    return true;
  }

  function InterceptBid() public returns (bool) {
    return true;

  }

  function closeDeal() public returns(bool) {
    return true;

  }

  function set(uint256 data) public {
    storedData = data;
  }

  function get() public constant returns (uint256){
    return storedData;
  }
}
