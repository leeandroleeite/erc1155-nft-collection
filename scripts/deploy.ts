import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const ERC1155Token = await ethers.getContractFactory("ERC1155Token");

  // Specify the URI for the token metadata
  const uri = "https://ipfs.io/ipfs/QmamHkp2beGfgyJwhwp87jEUJA4Eicoo9HRx4aUtBbC2XE/{id}.json";

  // Deploy the contract with the specified URI
  const erc1155 = await ERC1155Token.deploy(uri);

  // Wait for the deployment to be mined
  await erc1155.waitForDeployment();

  // Log the contract address
  console.log("ERC1155 deployed to:", await erc1155.getAddress());
}

// Execute the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
