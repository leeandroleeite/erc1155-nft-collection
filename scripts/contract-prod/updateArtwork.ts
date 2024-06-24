import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

// Artwork ID, new artist address, and new curator address
const artworkId = 14;
const newArtistAddress = "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0";
const newCuratorAddress = "0x53aebA3b107774a8380341c7429Bf352127fA1A3";

// const newArtistAddress = "0x0000000000000000000000000000000000000001";
// const newCuratorAddress = "0x0000000000000000000000000000000000000001";

async function main() {
    // Connect to Ethereum network
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call updateArtwork function
    const tx = await contract.updateArtwork(artworkId, newArtistAddress, newCuratorAddress);
    console.log("Transaction Hash:", tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed. Artwork updated.");

    // Verify the updated artwork details
    const updatedArtwork = await contract.getArtwork(artworkId);
    console.log("Updated Artwork Details for Artwork ID", artworkId, ":", updatedArtwork);
}

main().catch(error => {
    console.error("Error:", error);
});
