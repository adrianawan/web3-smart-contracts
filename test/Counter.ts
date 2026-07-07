import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";

describe("Counter", async function () {
  const { viem } = await network.create();

  const publicClient = await viem.getPublicClient();
  const [owner] = await viem.getWalletClients();

  it("Should emit the Increment event when calling the inc() function", async function () {
    const counter = await viem.deployContract("Counter", [
      owner.account.address,
    ]);

    await viem.assertions.emitWithArgs(
      counter.write.inc(),
      counter,
      "Increment",
      [1n],
    );
  });

  it("The sum of the Increment events should match the current value", async function () {
    const counter = await viem.deployContract("Counter", [
      owner.account.address,
    ]);

    const deploymentBlockNumber = await publicClient.getBlockNumber();

    for (let i = 1n; i <= 10n; i++) {
      await counter.write.incBy([i]);
    }

    const events = await publicClient.getContractEvents({
      address: counter.address,
      abi: counter.abi,
      eventName: "Increment",
      fromBlock: deploymentBlockNumber,
      strict: true,
    });

    let total = 0n;

    for (const event of events) {
      total += event.args.by;
    }

    assert.equal(
      total,
      await counter.read.getCount(),
    );
  });
});