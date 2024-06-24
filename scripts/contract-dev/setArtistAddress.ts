import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

// Artwork ID and new artist address
const artworkId = 1;
// const newArtistAddress = "0x0000000000000000000000000000000000000000";
const newArtistAddress = "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0";


async function main() {
    // Connect to Ethereum network
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call setArtistAddress function
    const tx = await contract.setArtistAddress(artworkId, newArtistAddress);
    console.log("Transaction Hash:", tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed. Artist address updated.");

    // Verify the new artist address
    const updatedArtistAddress = await contract.getArtistAddress(artworkId);
    console.log("Updated Artist Address for Artwork ID", artworkId, ":", updatedArtistAddress);
}

main().catch(error => {
    console.error("Error:", error);
});
