pragma solidity 0.4.24;


library Hashes {
  struct Hash {
    uint256 keyIndex;
    bytes32 digest;
    uint8 hashFunction;
    uint8 size;
  }

  struct Map {
    mapping(bytes32 => Hash) data;
    bytes32[] keys;
  }

  function insert(Map storage self, bytes32 key, bytes32 digest, uint8 hashFunction, uint8 size) internal returns (bool) {
    Hash storage hash = self.data[key];
    hash.digest = digest;
    hash.hashFunction = hashFunction;
    hash.size = size;

    // if keyIndex already exists, dont change keyIndex
    if (hash.keyIndex > 0) return true;

    hash.keyIndex = ++self.keys.length;
    self.keys[hash.keyIndex - 1] = key;

    return true;
  }

  function remove(Map storage self, bytes32 key) internal returns (bool) {
    Hash storage hash = self.data[key];

    // if keyIndex doesnt exist, nothing to do
    if (hash.keyIndex == 0) return true;

    if (hash.keyIndex <= self.keys.length) {
      self.data[self.keys[self.keys.length - 1]].keyIndex = hash.keyIndex;
      self.keys[hash.keyIndex - 1] = self.keys[self.keys.length - 1];
      self.keys.length -= 1;
      delete self.data[key];
    }

    return true;
  }

  function contains(Map storage self, bytes32 key) internal view returns (bool) {
    return self.data[key].keyIndex > 0;
  }

  function size(Map storage self) internal view returns (uint256) {
    return self.keys.length;
  }

  function getKeys(Map storage self) internal view returns (bytes32[]) {
    return self.keys;
  }

  function getHashByIndex(Map storage self, uint256 keyIndex) internal view returns (Hash) {
    return self.data[self.keys[keyIndex]];
  }

  function getHashByKey(Map storage self, bytes32 key) internal view returns (Hash) {
    return self.data[key];
  }
}
