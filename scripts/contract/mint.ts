import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ERC1155Token.sol/ERC1155Token.json"

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

async function main() {
    // Connect to Ethereum network
    const provider = new ethers.providers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi: ethers.ContractInterface = contractArtifact.abi

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet) as ethers.Contract;

    // Example: Mint Tokens
    const tokenId = 1; // ID of the token you want to mint
    const recipientAddress =`${process.env.RECIPIENT_ADDRESS}`;
    const amount = 1; // Amount of tokens to mint
    const data = "0x"; // Optional data, usually empty for minting
    const tx = await contract.mint(recipientAddress, tokenId, amount, data);
    await tx.wait();
    console.log(`Minted ${amount} tokens of ID ${tokenId} for address ${recipientAddress}`);
}

main().catch(error => {
    console.error("Error:", error);
});