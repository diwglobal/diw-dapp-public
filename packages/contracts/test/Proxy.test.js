/* global web3 before assert */

const { getBytes32FromMultihash } = require("utils/lib/multihash");

const SimpleToken = artifacts.require("SimpleToken");
const LogicV1 = artifacts.require("LogicV1");
const Proxy_ = artifacts.require("Proxy");

contract("Proxy", function(accounts) {
  const multiHash = "QmUZFz7KTbKuKEcWsobNHMtXAkTqPWjKvi9RB9dhYfJ42z";
  const { digest, hashFunction, size } = getBytes32FromMultihash(multiHash);
  const key = digest;
  const [owner] = accounts;
  let token;
  let logicV1;
  let proxy;
  let proxyLogic;

  before(async function() {
    token = await SimpleToken.new();
    logicV1 = await LogicV1.new();
    proxy = await Proxy_.new(token.address, logicV1.address);
    proxyLogic = LogicV1.at(proxy.address);
  });

  it("updateHash", async function() {
    const payment = web3.toWei("50", "ether");

    await token.approve(proxyLogic.address, payment);
    const allowance = await token.allowance(owner, proxyLogic.address);
    assert.equal(payment, allowance);

    await proxyLogic.pay(payment);
    const payed = await proxyLogic.payed(owner);
    assert.equal(payment, payed);

    await proxyLogic.updateHash(key, digest, hashFunction, size);
    const hash = await proxyLogic.getHash(owner, key);
    const hashes = await proxyLogic.getHashes(owner);
    assert.equal(hash["0"], digest);
    assert.equal(hash["1"], hashFunction);
    assert.equal(hash["2"], size);
    assert.equal(hashes.length, 1);
  });

  it("removeHash", async function() {
    const payment = web3.toWei("50", "ether");

    await token.approve(proxyLogic.address, payment);
    await proxyLogic.pay(payment);
    await proxyLogic.updateHash(key, digest, hashFunction, size);

    await proxyLogic.removeHash(key);
    const hash = await proxyLogic.getHash(owner, key);
    const hashes = await proxyLogic.getHashes(owner);
    assert.equal(
      hash["0"],
      "0x0000000000000000000000000000000000000000000000000000000000000000"
    );
    assert.equal(hash["1"], 0);
    assert.equal(hash["2"], 0);
    assert.equal(hashes.length, 0);
  });
});
