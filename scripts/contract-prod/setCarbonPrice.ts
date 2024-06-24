import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";

// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

const newCarbonCreditPrice = ethers.parseEther("0.001"); // For example, 1 ETH


async function main() {
    // Connect to Ethereum network
    // const provider = ethers.getDefaultProvider("matic-amoy");
    const provider = new ethers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Call setCarbonCreditPrice function
    const tx = await contract.setCarbonCreditPrice(newCarbonCreditPrice);
    console.log("Transaction Hash:", tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();
    console.log("Transaction confirmed.");

    // Verify the new carbon credit price
    const updatedCarbonCreditPrice = await contract.getCarbonCreditPrice();
    console.log("Updated Carbon Credit Price:", ethers.formatEther(updatedCarbonCreditPrice));
    }

main().catch(error => {
    console.error("Error:", error);
});
