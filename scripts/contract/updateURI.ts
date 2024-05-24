import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ERC1155Token.sol/ERC1155Token.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

const newUri = "";

async function main() {
    // Connect to Ethereum network
    const provider = ethers.getDefaultProvider("matic-amoy");
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call updateUri function
    const tx = await contract.updateUri(newUri);
    await tx.wait();
    console.log("URI updated successfully.");
}

main().catch(error => {
    console.error("Error:", error);
});
