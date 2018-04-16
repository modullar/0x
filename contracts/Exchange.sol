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

  function getMaker() public returns (address){
    return maker;
  }

  function getTaker() public returns (address){
    return taker;
  }

  function getBid(uint n) public returns(address, address, address, string, bytes32){
    return(bids[n].maker, bids[n].taker, bids[n].relayer, bids[n].status, stringToBytes32(bids[n].status));
  }

  function bidsCount() public returns (uint256) {
    return bids.length;
  }

  function createBid() public returns (bool){
    // To be able to test
    doCreateBid(msg.sender);
  }

  function doCreateBid(address _sender)public returns (bool){
    if(_sender == maker){
      Bid memory bid = Bid({maker: _sender, taker: _sender, relayer: _sender, status: 'created'});
      bids.push(bid);
      return true;
    }
    return false;
  }

  function PostBid(uint n) public returns (bool) {
    doPostBid(msg.sender, n);
  }

  function doPostBid(address _sender, uint n) returns (bool){
    var (m, t, r, s, b) = getBid(n);
    if(_sender == relayer && compareStrings(s, 'created')){
      bids[n].status = 'posted';
      bids[n].relayer = relayer;
      return true;
    }
    return false;
  }

  function InterceptBid(uint n) public returns (bool) {
    doInterceptBid(msg.sender, n);
  }

  function doInterceptBid(address _sender, uint n) returns (bool){
    var (m, t, r, s, b) = getBid(n);
    if(_sender == taker && compareStrings(s, 'posted')){
      bids[n].status = 'intercepted';
      bids[n].taker = taker;
      return true;
    }
    return false;
  }

  function compareStrings(string a, string b) view returns (bool){
    return keccak256(a) == keccak256(b);
  }

  function stringToBytes32(string memory source) returns (bytes32 result) {
      bytes memory tempEmptyStringTest = bytes(source);
      if (tempEmptyStringTest.length == 0) {
          return 0x0;
      }
      assembly {
          result := mload(add(source, 32))
      }
  }


}
