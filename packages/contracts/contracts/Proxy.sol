pragma solidity 0.4.24;

import "./UpgradeableContractProxy.sol";
import "./Hashes.sol";
import "openzeppelin-solidity/contracts/ownership/rbac/RBAC.sol";


contract Proxy is UpgradeableContractProxy, RBAC {
  using Hashes for Hashes.Map;

  struct User {
    uint256 payedAmount;
    Hashes.Map hashes;
  }

  mapping(address => User) internal users;
  address internal diwToken;

  constructor(address _diwToken, address _newImplementation) public {
    diwToken = _diwToken;
    _currentImplementation = _newImplementation;
  }
}
