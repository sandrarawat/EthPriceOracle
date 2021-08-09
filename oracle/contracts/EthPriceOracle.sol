// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./CallerContractInterface.sol";
contract EthPriceOracle is AccessControl {

    using SafeMath for uint256;
  uint private randNonce = 0;
  uint private modulus = 1000;
      uint private numOracles = 0;
    uint private THRESHOLD = 0;
  mapping(uint256=>bool) pendingRequests;
  event GetLatestEthPriceEvent(address callerAddress, uint id);
  event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
  function getLatestEthPrice() public returns (uint256) {
    randNonce++;
    uint id = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
    pendingRequests[id] = true;
    emit GetLatestEthPriceEvent(msg.sender, id);
    return id;
  }
  function setLatestEthPrice(uint256 _ethPrice, address _callerAddress,   uint256 _id) public {
    require(pendingRequests[_id], "This request is not in my pending list.");
    delete pendingRequests[_id];
    CallerContracInterface callerContractInstance;
    callerContractInstance = CallerContracInterface(_callerAddress);
    callerContractInstance.callback(_ethPrice,_id);
    emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);

  }
}
