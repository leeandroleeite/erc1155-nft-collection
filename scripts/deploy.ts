import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const ERC1155Token = await ethers.getContractFactory("ConsciousPlanetColletion");

  const contractName = "ConsciousPlanetCollection"
  const uri = "https://ipfs.io/ipfs/QmamHkp2beGfgyJwhwp87jEUJA4Eicoo9HRx4aUtBbC2XE/{id}.json";
  const mintPrice = ethers.parseEther("0.02"); // Convert 0.02 Matic to Wei
  const projectOwner = '0x0Bd0F2Dafc27F7CBF9349c4939e83FE5B0345cDE'
  const developerAddress = "0x967D8384750A72B06631156416FD9d59c5F334f5";
  const carbonCreditWallet="0x02cC4687d44485FD6F08D971a973A857B053F966";
  const carbonCreditPrice=ethers.parseEther("0.001");
  const artistShare = 80;
  const curatorShare = 5;
  const projectOwnerShare = 10;
  const developerShare = 5;
  const artistRoyalty = 10;

  // Deploy the contract with the specified URI
  const erc1155 = await ERC1155Token.deploy(contractName, uri, mintPrice, projectOwner, carbonCreditWallet, carbonCreditPrice, artistShare, curatorShare, projectOwnerShare, developerShare, artistRoyalty);

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
