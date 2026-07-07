import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MyTokenModule", (m) => {
  const deployer = m.getAccount(0);

  const myToken = m.contract("MyToken", [deployer]);

  return { myToken };
});