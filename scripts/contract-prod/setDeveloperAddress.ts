import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

// New developer address
const newDeveloperAddress = "0x6586102aDa64aB59C00546f8c2aE10E8AeEbf125";
// const newDeveloperAddress = "0x0000000000000000000000000000000000000000";

async function main() {
    // Connect to Ethereum network
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call setDeveloperAddress function
    const tx = await contract.setDeveloperAddress(newDeveloperAddress);
    console.log("Transaction Hash:", tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed. Developer address updated.");

    // Verify the new developer address
    const updatedDeveloperAddress = await contract.getDeveloperAddress();
    console.log("Updated Developer Address:", updatedDeveloperAddress);
}

main().catch(error => {
    console.error("Error:", error);
});
