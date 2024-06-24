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

    const fromAddress = "0x19505B89fBfF7496b13E751a067CaC904d7EeFdE";


    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Example: Mint Tokens
    const to = fromAddress;
    const tokenId = 14; // ID of the token you want to mint
    // const recipientAddress = fromAddress;
    const amount = 1; // Amount of tokens to mint
    const payment = (0.02 * amount).toString()
    const mintPriceInMatic = ethers.parseEther(payment); // Convert 0.02 Matic to Wei
    // const data = "0x"; // Optional data, usually empty for minting
    const data = "0x0000000000000000000000000000000000000000"; // Optional data, usually empty for minting
    const referral = "0x0000000000000000000000000000000000000000";
    // const referral = ethers.ZeroAddress;

    // Check if the wallet has sufficient balance for the minting
    const balance = await provider.getBalance(to);
    if (balance<=(mintPriceInMatic)) {
        throw new Error("Insufficient balance for minting");
    }


// Send transaction to mint tokens
const overrides = {
    value: mintPriceInMatic
};

const tx = await contract.mintTo(to, tokenId, amount, data, referral, overrides);
await tx.wait();
console.log(`Minted ${amount} tokens of ID ${tokenId} for address ${fromAddress}`);
}

main().catch(error => {
    console.error("Error:", error);
});
