# ERC1155 Smart Contract Development for Multi-Artist NFT Collection

ERC-1155 Smart Contract for an NFT Collection using IPFS

## Objective

Design and implement an ERC1155 smart contract on the Polygon blockchain to manage a diverse collection of 32 unique artworks with differentiated pricing, direct customer minting capabilities, and royalties for artists on the secondary market. Integrate the smart contract into our existing Wix website to allow users to mint NFTs using cryptocurrency wallets or credit cards via a service like Moonpay.

## Project Scope

### 1. Front Page Integration
- **Description:** Integrate the existing Wix front page with the smart contract and payment systems. Ensure smooth processes for transaction handling, user authentication, and NFT delivery.
- **Wix Website:** [Conscious Planet Collection](https://www.consciousplanetcollection.com/)

### 2. NFT Minting
- **User Wallet Integration:** Allow users to connect their cryptocurrency wallets (e.g., MetaMask, Trust Wallet) to the platform.
- **Credit Card Integration via Moonpay:** Implement Moonpay or a similar service to enable users to mint NFTs using their credit cards.

#### Minting Process:
1. Users select the NFTs they wish to mint.
2. Users choose their payment method (wallet or credit card).
3. Transaction confirmation and processing.
4. NFT delivery to the user's wallet.

### 3. ERC1155 Smart Contract Deployment
- **Blockchain:** Polygon Network

#### ERC1155 Smart Contract Requirements
1. **Artwork Details:**
   - Total Artworks: 32 (each with 100 copies).
   - Each artwork has a unique URI linking to its metadata. [IPFS Metadata](https://ipfs.io/ipfs/QmamHkp2beGfgyJwhwp87jEUJA4Eicoo9HRx4aUtBbC2XE/)

2. **Minting Details:**
   - Artworks will have different minting prices.
   - Implement functions for paying all stakeholders.
3. **Pricing Structure:**
   - Different minting prices among artworks (refer to spreadsheet).
   - Minting price = artwork price + carbon credit price.
     - Carbon credit price goes to the carbon credit wallet.
     - Artwork price distribution:
       - 80% to the artist’s wallet.
       - 10% to the developer.
       - 5% to the curator.
       - 5% to the contract owner.
4. **Minting Access:**
   - Enable public minting.
   - Public function for users to mint specified quantities of an artwork.
5. **Royalties:**
   - Artist Royalties: Set at 10% for secondary market sales.
6. **Smart Contract Functions:**
   - Update minting price (owner only).
   - Update artist address (owner only).
   - Retrieve metadata URI for each artwork.
   - Update stakeholder addresses.
7. **Security Features:**
   - Adherence to the ERC1155 standard for interoperability and security.
   - Safeguards against common vulnerabilities such as reentrancy, overflow/underflow, and unauthorized actions.

## Deliverables
- Solidity smart contract code.
- Deployment guide.
- Documentation detailing functionalities and code logic.

By supporting these projects, the collection will finance the removal of 2,113 tons of CO2 and the planting of 200 trees in the Amazon. These statistics demonstrate the tangible environmental benefits of purchasing artworks from the Conscious Planet collection.
