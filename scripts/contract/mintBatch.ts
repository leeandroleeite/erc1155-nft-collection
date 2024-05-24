import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ERC1155Token.sol/ERC1155Token.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

async function main() {
    // Connect to Ethereum network
    const provider = ethers.getDefaultProvider("matic-amoy");
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Example: Mint Tokens
   // Example: Mint Tokens in Batch
   const tokenIds = [1, 2]; // IDs of the tokens you want to mint
   const recipientAddress =`${process.env.RECIPIENT_ADDRESS}`;
   ; // Address you want to mint tokens for
   const amounts = [10, 20]; // Amounts of tokens to mint for each token ID
   const data = "0x"; // Optional data, usually empty for minting
   const tx = await contract.mintBatch(recipientAddress, tokenIds, amounts, data);
   await tx.wait();
   console.log(`Minted tokens in batch for address ${recipientAddress}`);
}

main().catch(error => {
    console.error("Error:", error);
});
