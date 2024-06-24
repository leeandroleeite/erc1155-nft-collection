import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";
// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

async function main() {
    // Connect to Ethereum network
    // const provider = ethers.getDefaultProvider("matic-amoy");
    const provider = new ethers.JsonRpcProvider(providerUrl);

    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);
    
     // Example data for initializing parameters
     const mintPrice = ethers.parseEther("100"); // 0.02 MATIC
     const carbonCreditPrice = ethers.parseEther("10"); // 0.002 MATIC
     const carbonCreditAddress = `${process.env.CARBON_CREDITS_ADDRESS}`;
     const projectOwnerAddress = `${process.env.PROJECT_OWNER_ADDRESS}`;
     const artistShare = 75; // 75%
     const curatorShare = 5; // 10%
     const projectOwnerShare = 5; // 20%
     const developerAddress = `${process.env.DEVELOPER_ADDRESS}`;
     const developerShare = 5; // 5%
     const referralShare = 10; // 10%
     const artistRoyalty = 5; // 5%

        // Call initializeParameters function
    const tx = await contract.initializeParameters(
      mintPrice,
      carbonCreditPrice,
      carbonCreditAddress,
      projectOwnerAddress,
      artistShare,
      curatorShare,
      projectOwnerShare,
      developerAddress,
      developerShare,
      referralShare,
      artistRoyalty
    );     

    await tx.wait();

    console.log(`Initialized contract parameters successfully`);
    
     // Log the parameters
    console.log("Initializing contract with the following parameters:");
    console.log(`Mint Price: ${mintPrice.toString()}`);
    console.log(`Carbon Credit Price: ${carbonCreditPrice.toString()}`);
    console.log(`Carbon Credit Address: ${carbonCreditAddress}`);
    console.log(`Project Owner Address: ${projectOwnerAddress}`);
    console.log(`Artist Share: ${artistShare}%`);
    console.log(`Curator Share: ${curatorShare}%`);
    console.log(`Project Owner Share: ${projectOwnerShare}%`);
    console.log(`Developer Address: ${developerAddress}`);
    console.log(`Developer Share: ${developerShare}%`);
    console.log(`Referral Share: ${referralShare}%`);
    console.log(`Artist Royalty: ${artistRoyalty}%`);
}

main().catch(error => {
    console.error("Error:", error);
});
