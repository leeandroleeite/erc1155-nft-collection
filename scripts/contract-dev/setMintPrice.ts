import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

// New mint price (in wei)
const newMintPrice = ethers.parseEther("0.01"); // For example, 0.01 ETH

async function main() {
    // Connect to Ethereum network
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call setMintPrice function
    const tx = await contract.setMintPrice(newMintPrice);
    console.log("Transaction Hash:", tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed. Mint price updated.");

    // Verify the new mint price
    const updatedMintPrice = await contract.getMintPrice();
    console.log("Updated Mint Price:", ethers.formatEther(updatedMintPrice));
}

main().catch(error => {
    console.error("Error:", error);
});
