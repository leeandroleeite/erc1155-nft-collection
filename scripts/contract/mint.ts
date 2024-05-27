import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetColletion.sol/ConsciousPlanetColletion.json";
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

    const fromAddress = wallet.address;


    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

// Example: Mint Tokens
const tokenId = 29; // ID of the token you want to mint
// const recipientAddress = fromAddress;
const amount = 2; // Amount of tokens to mint
const payment = (0.02 * amount).toString()
const mintPriceInMatic = ethers.parseEther(payment); // Convert 0.02 Matic to Wei
const data = "0x"; // Optional data, usually empty for minting

// Check if the wallet has sufficient balance for the minting
const balance = await provider.getBalance(fromAddress);
if (balance<=(mintPriceInMatic)) {
    throw new Error("Insufficient balance for minting");
}


// Send transaction to mint tokens
const overrides = {
    value: mintPriceInMatic,
    from: fromAddress
};

const tx = await contract.mint(tokenId, amount, data, overrides);
await tx.wait();
console.log(`Minted ${amount} tokens of ID ${tokenId} for address ${fromAddress}`);
}

main().catch(error => {
    console.error("Error:", error);
});
