import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("VotingModule", (m) => {
  const deployer = m.getAccount(0);

  const voting = m.contract("Voting", [deployer]);

  return { voting };
});