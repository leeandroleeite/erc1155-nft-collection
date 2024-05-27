// test/ERC1155Token.test.ts

import { ethers } from 'hardhat';
import { Contract, ContractFactory, BigNumberish } from 'ethers';
import { expect } from 'chai';


describe('ERC1155Token', function () {
  let ERC1155Token: Contract;
  let owner: any;
  let addr1: any;
  let addr2: any;
  const contractName = 'Test ConsciousPlanetColletion';
  const uri = 'https://example.com/token/{id}.json';
  const mintPrice = ethers.parseEther('0.02');
  const totalCopies = 100;
  const carbonCreditPrice = ethers.parseEther('0.001');
  const artist = '0x8a6cB8C2336D67E6d1102AD668702Bc9FD39D861';
  const curator = '0xD8867884a15895d9B077a9747842FEA1B573C9dF';
  const projectOwnerAddress = '0x0Bd0F2Dafc27F7CBF9349c4939e83FE5B0345cDE';
  const curatorShare = 5;
  const projectOwnerShare = 10;
  const developerAddress = '0x967D8384750A72B06631156416FD9d59c5F334f5';
  const carbonCreditWallet = '0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0';

    beforeEach(async function () {
        const ERC1155TokenFactory = await ethers.getContractFactory('ERC1155Token');
        [owner, addr1, addr2] = await ethers.getSigners();
        ERC1155Token = await ERC1155TokenFactory.deploy(contractName, uri, mintPrice, projectOwnerAddress, developerAddress, carbonCreditWallet, carbonCreditPrice);
        await ERC1155Token.waitForDeployment();
    });

    it('Should deploy ERC1155Token contract and initialize artwork', async function () {

        const artworkId = 1;
        const artwork = await ERC1155Token.getArtwork(artworkId);

        expect(artwork).to.have.lengthOf(5);
        expect(artwork[0]).to.equal(artist);
        expect(artwork[1]).to.equal(curator);
        expect(artwork[2]).to.equal(curatorShare);
        expect(artwork[3]).to.equal(projectOwnerShare);
        expect(artwork[4]).to.equal(100);

    });
  
    it('Should return correct contract name', async function () {
        expect(await ERC1155Token.name()).to.equal(contractName);
    });

    it('Should mint tokens with correct payments and distribution', async function () {
        // Define parameters for minting
        const tokenId = 1; // ID of the artwork
        const amount = 1; // Amount of tokens to mint
        const data = '0x'; // Example data if required
    
        // Get initial balances
        const initialBalance = await ethers.provider.getBalance(owner.address);
        const artistInitialBalance = await ethers.provider.getBalance(artist);
        const curatorInitialBalance = await ethers.provider.getBalance(curator);
        const developerInitialBalance = await ethers.provider.getBalance(developerAddress);
        const projectOwnerInitialBalance = await ethers.provider.getBalance(projectOwnerAddress);
        // const carbonCreditWalletInitialBalance = await ethers.provider.getBalance(carbonCreditWallet);
    
        // Calculate total payment
        const totalPayment = BigInt(mintPrice) * BigInt(amount);

        // Calculate artworkPrice
        const artworkPrice = mintPrice - carbonCreditPrice;

        // Calculate stakeholders payment
        const artistPayment = artworkPrice * BigInt(Math.round(0.8 * 10**18));
        const curatorPayment = artworkPrice * BigInt(Math.round(0.05 * 10**18));
        const developerPayment = artworkPrice * BigInt(Math.round(0.05 * 10**18));
        const projectOwnerPayment = artworkPrice * BigInt(Math.round(0.1 * 10**18));


    
        // Send payment to contract
        await ERC1155Token.mint(tokenId, amount, data, { value: totalPayment });
    
        // Get final balances after minting
        const finalBalance = await ethers.provider.getBalance(owner.address);
        const artistFinalBalance = await ethers.provider.getBalance(artist);
        const curatorFinalBalance = await ethers.provider.getBalance(curator);
        const developerFinalBalance = await ethers.provider.getBalance(developerAddress);
        const projectOwnerFinalBalance = await ethers.provider.getBalance(projectOwnerAddress);
        // const carbonCreditWalletFinalBalance = await ethers.provider.getBalance(carbonCreditWallet);
    
        // // Assertions
        // expect(finalBalance).to.equal(initialBalance - totalPayment, 'Incorrect balance after minting');
        expect(artistFinalBalance).to.equal(artistInitialBalance + artistPayment, 'Incorrect artist balance after minting');
        expect(curatorFinalBalance).to.equal(curatorInitialBalance + curatorPayment, 'Incorrect curator balance after minting');
        expect(developerFinalBalance).to.equal(developerInitialBalance + developerPayment, 'Incorrect developer balance after minting');
        expect(projectOwnerFinalBalance).to.equal(projectOwnerInitialBalance + projectOwnerPayment, 'Incorrect contract owner balance after minting');
        // expect(carbonCreditWalletFinalBalance).to.equal(carbonCreditWalletInitialBalance.add(totalPayment.sub(artistPayment).sub(curatorPayment).sub(developerPayment).sub(contractOwnerPayment)), 'Incorrect carbon credit wallet balance after minting');
    
        // Check remaining copies
        const remainingCopies = await ERC1155Token.getRemainingCopies(tokenId);
        expect(remainingCopies).to.equal(totalCopies - amount, 'Incorrect remaining copies after minting');
    });
    

    it('Should return correct mint price', async function () {
        expect(await ERC1155Token.getMintPrice()).to.equal(mintPrice);
    });

    it('Should update mint price', async function () {
        await ERC1155Token.setMintPrice(ethers.parseEther('2'));
        expect(await ERC1155Token.getMintPrice()).to.equal(ethers.parseEther('2'));
    });    

    it('Should return correct developerAddress', async function () {
        expect(await ERC1155Token.getDeveloperAddress()).to.equal(developerAddress);
    });

    it('Should update developer address', async function () {
        await ERC1155Token.setDeveloperAddress(addr1.address);
        expect(await ERC1155Token.getDeveloperAddress()).to.equal(addr1.address);
    });

    it('Should return carbon credit wallet', async function () {
        expect(await ERC1155Token.getCarbonCreditWallet()).to.equal(carbonCreditWallet);
    });

    it('Should update carbon credit wallet', async function () {
        await ERC1155Token.setCarbonCreditWallet(addr1.address);
        expect(await ERC1155Token.getCarbonCreditWallet()).to.equal(addr1.address);
    });

    it('Should update URI', async function () {
        const newURI = 'https://example.com/new/{id}.json';
        await ERC1155Token.setURI(newURI);
        expect(await ERC1155Token.uri(1)).to.equal(newURI);
    });

    it('Should update artist address', async function () {
        await ERC1155Token.setArtistAddress(1, addr1.address);
        expect(await ERC1155Token.getArtistAddress(1)).to.deep.equal(addr1.address);
    });

});
