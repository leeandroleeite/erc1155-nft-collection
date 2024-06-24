import { ethers } from "ethers";
import contractArtifact from "../../artifacts/contracts/ConsciousPlanetCollection.sol/ConsciousPlanetCollection.json";
// ERC-1155 contract address
const contractAddress = `${process.env.CONTRACT_ADDRESS}`;
// Provider URL
const providerUrl = `https://polygon-mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`;
// Private key of the account you want to use
const privateKey = `${process.env.PRIVATE_KEY}`;

async function main() {
    // Connect to Ethereum network
    // const provider = ethers.getDefaultProvider("matic-amoy");
    const provider = new ethers.JsonRpcProvider(providerUrl);

    const wallet = new ethers.Wallet(privateKey, provider);

    // ERC-1155 contract ABI
    const abi = contractArtifact.abi;

    // Instantiate ERC-1155 contract
    const contract = new ethers.Contract(contractAddress, abi, wallet);

    // Example data for initialization
    const ids = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
        31, 32
    ];

    const artists = [
      "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0",
      "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0",
      "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0",
      "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0", "0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0",
      "0xfd9174897026FFE282a526Fd364a139e750B4f19", "0xEa5a65D8973B96FaA9404F472dBDfc67b8bb620C", "0x99aeAbFF6b7E610509B2862A566aE663E84b7aD5",
      "0x4D2CE12595b20269d89B85b6f61385ceA25d2B06", "0x11A2fCf0a5F5D3675D94208F5979D8f98825Cb99", "0x4BcEe74F8c2520e5a151d6262D81EC9A20152847",
      "0xa9fc46A0bfACf1b9cA610B67f58F974fdE87D174", "0x7354112F9EAE0d7a4334E48005BbB0719ED9318e", "0xa9fc46A0bfACf1b9cA610B67f58F974fdE87D174",
      "0x99aeAbFF6b7E610509B2862A566aE663E84b7aD5", "0xEa5a65D8973B96FaA9404F472dBDfc67b8bb620C", "0x3fA2eB8a9227d24E1AB60d6Ea7EDaAa50672A12e",
      "0xb3FdEb6350E7a786d100563e536Ba1ffD04fF14F", "0x3a698bf51eA2A9071B5C3A263D2cc3259125c225", "0xc509ecaA3D2123855dcc9B1aeD6b2b8a015aabc2",
      "0xa0E49a6Dd136378c9bB5f1AD970C472678a69C84", "0xc011Abc3ffFd32231F4806c5B1120E01a7dcb9a9", "0xaBaA5C99C52d69D80bFc18Fc1229170b80698ED4",
      "0x3fA2eB8a9227d24E1AB60d6Ea7EDaAa50672A12e", "0xE3effeD865344291FB71EFF3C13F8Eeb4F4C3242"
    ];

    const curators = [
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x5Ab3eFD4a5396735487f2a5Cd688C2D07A005Bb8", "0x5Ab3eFD4a5396735487f2a5Cd688C2D07A005Bb8",
      "0x5Ab3eFD4a5396735487f2a5Cd688C2D07A005Bb8", "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x5Ab3eFD4a5396735487f2a5Cd688C2D07A005Bb8",
      "0x53aebA3b107774a8380341c7429Bf352127fA1A3", "0x53aebA3b107774a8380341c7429Bf352127fA1A3"
    ];
      
    // Check if input arrays have the same length
    if (ids.length !== artists.length || artists.length !== curators.length) {
        throw new Error("Input arrays must have the same length");
    }

    // Call initializeArtworks function
    const tx = await contract.initializeArtworks(ids, artists, curators);
    console.log("Transaction Hash:", tx.hash);

    await tx.wait();
    console.log(`Initialized artworks with IDs: ${ids.join(', ')}`);
}

main().catch(error => {
    console.error("Error:", error);
});
