// @ts-ignore
const hre = require("hardhat");



// 0x16De3943bb2aD61cA1c79cAf672c995fa3Ee0cBC

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