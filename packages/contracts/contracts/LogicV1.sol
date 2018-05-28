pragma solidity 0.4.24;

import "./Proxy.sol";
import "./Hashes.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract LogicV1 is Proxy {
  using SafeERC20 for ERC20;
  using SafeMath for uint256;

  constructor() public
  Proxy(address(0), address(0))
  {}

  modifier hasPayed() {
    require(users[msg.sender].payedAmount >= 50 ether);
    _;
  }

  function pay(uint256 amount) external {
    // ERC20 token = ERC20(diwToken);

    // token.safeTransferFrom(msg.sender, this, amount);

    users[msg.sender].payedAmount = users[msg.sender].payedAmount.add(amount);
  }

  function payed(address user) external view returns (uint256) {
    return users[user].payedAmount;
  }

  function updateHash(bytes32 key, bytes32 digest, uint8 hashFunction, uint8 size) external hasPayed {
    users[msg.sender].hashes.insert(
      key,
      digest,
      hashFunction,
      size
    );
  }

  function removeHash(bytes32 key) external {
    users[msg.sender].hashes.remove(key);
  }

  function getHash(address user, bytes32 key) external view returns (bytes32 digest, uint8 hashFunction, uint8 size) {
    Hashes.Hash memory hash = users[user].hashes.getHashByKey(key);

    return (
      hash.digest,
      hash.hashFunction,
      hash.size
    );
  }

  function getHashes(address user) external view returns (bytes32[]) {
    return users[user].hashes.getKeys();
  }
}