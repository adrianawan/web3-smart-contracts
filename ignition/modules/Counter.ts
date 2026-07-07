import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CounterModule", (m) => {
  // Account pertama yang digunakan untuk deploy
  const deployer = m.getAccount(0);

  // Deploy Counter dan set deployer sebagai owner
  const counter = m.contract("Counter", [deployer]);

  return { counter };
});