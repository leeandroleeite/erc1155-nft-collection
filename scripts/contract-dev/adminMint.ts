import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";
// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-amoy.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

async function main() {
    // Connect to Ethereum network
    // const provider = ethers.getDefaultProvider("matic-amoy");
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    const fromAddress = wallet.address;


    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Example: Admin Mint Tokens
    const tokenId = 14; // ID of the token you want to mint
    const recipientAddress = ethers.ZeroAddress; // Replace with the recipient address or use address(0) to mint to the owner
    console.log(recipientAddress);
    const amount = 1; // Amount of tokens to mint
    const data = "0x"; // Optional data, usually empty for minting

    try {
        console.log(`Minting ${amount} tokens of ID ${tokenId} to address ${recipientAddress}`);
        const tx = await contract.adminMint(recipientAddress, tokenId, amount, data);
        await tx.wait();
        console.log(`Minted ${amount} tokens of ID ${tokenId} to address ${recipientAddress}`);
    } catch (error) {
        console.error("Error:", error);
    }
}
main().catch(error => {
    console.error("Error:", error);
});
