import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deployer } = await getNamedAccounts();
  const { deploy } = deployments;

  await deploy("ClearanceCard001", {
    from: deployer,
    args: [],
    log: true,
    deterministicDeployment: false,
  });
};

deploy.tags = ["clearance-card-001"];
export default deploy;
