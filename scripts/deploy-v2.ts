// @ts-ignore
const hre = require("hardhat");


// 1. 0xbd3fd4aF1E3f12c90118773A6e03054005B14FDE

// @ts-ignore
async function main() {
  const MetaLinks = await hre.ethers.getContractFactory("MetaLinks");
  const metaLinks = await MetaLinks.deploy();

  await metaLinks.deployed();

  console.log("MetaLinks deployed to:", metaLinks.address);
}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});