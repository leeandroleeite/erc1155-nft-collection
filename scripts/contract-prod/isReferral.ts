import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

const newPrice = ethers.parseEther("0.002"); // 0.002 MATIC;

async function main() {
    // Connect to Ethereum network
    // const provider = ethers.getDefaultProvider("matic-amoy");
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Example referrals to register
    const referrals = [
        `${process.env.REFERRAL_ADDRESS}`
    ];

    // Register each referral
    for (const referral of referrals) {
        console.log(`Checking referral: ${referral}`);
        const tx = await contract.isReferralRegistered(referral);
        console.log("Is Referral Registered:", tx);
    }
}

main().catch(error => {
    console.error("Error:", error);
});
