// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

contract ERC1155Token is ERC1155, Ownable, ERC1155Supply {

    string private _contractName;
    
    address private _contractOwner;
    uint256 private _mintPrice; 
    uint256 private _totalCopies = 100;
    uint256 private _carbonCreditPrice;
    address private _carbonCreditWallet;
    address private _developerAddress; 

    mapping(uint256 => Artwork) private artworks;

    struct Artwork {
        address artist;
        address curator;
        uint256 curatorShare;
        uint256 contractOwnerShare;
        uint256 remainingCopies;
    }

    constructor(string memory contractName, string memory uri, uint256 mintPrice, address developerAddress, address carbonCreditWallet, uint256 carbonCreditPrice) ERC1155(uri) Ownable(msg.sender) {
        _contractName = contractName;
        _mintPrice = mintPrice;
        _developerAddress = developerAddress;
        _carbonCreditWallet = carbonCreditWallet;
        _carbonCreditPrice = carbonCreditPrice;

        initializeArtwork(1, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(2, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(3, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(4, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(5, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(6, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(7, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(8, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(9, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(10, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(11, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
        initializeArtwork(12, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0, 10);
    }    

    function initializeArtwork(uint256 id, address artist, address curator, uint256 curatorShare, uint256 contractOwnerShare) private onlyOwner {
        require(artworks[id].artist == address(0), "Artwork already initialized");
        artworks[id] = Artwork(artist, curator, curatorShare, contractOwnerShare, _totalCopies);
    }
   
    function mint(uint256 id, uint256 amount, bytes memory data) public payable {
        uint256 totalPayment = _mintPrice * amount;

        require(msg.value >= totalPayment, "Insufficient payment");

        uint artworkPrice = totalPayment - _carbonCreditPrice;

        uint256 artistPayment = artworkPrice * 80 / 100;
        uint256 developerPayment = artworkPrice * 5 / 100;
        uint256 curatorPayment = artworkPrice * artworks[id].curatorShare / 100;
        uint256 contractOwnerPayment = artworkPrice * artworks[id].contractOwnerShare / 100;

        payable(artworks[id].artist).transfer(artistPayment);
        payable(artworks[id].curator).transfer(curatorPayment);
        payable(_developerAddress).transfer(developerPayment);
        payable(_contractOwner).transfer(contractOwnerPayment);
        payable(_carbonCreditWallet).transfer(msg.value - artistPayment - developerPayment - curatorPayment - contractOwnerPayment);

        _mint(msg.sender, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function name() public view returns (string memory) {
        return _contractName;
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    function getMintPrice() public view returns (uint256) {
        return _mintPrice;
    }

    function updateMintPrice(uint256 newPrice) public onlyOwner {
        _mintPrice = newPrice;
    }

    function setDeveloperAddress(address newDeveloperAddress) public onlyOwner {
        _developerAddress = newDeveloperAddress;
    }

    function getDeveloperAddress() public view returns (address) {
        return _developerAddress;
    }

    function updateCarbonCreditWallet(address newWallet) public onlyOwner {
        _carbonCreditWallet = newWallet;
    }

    function updateCarbonCreditPrice(uint256 newCarbonCreditPrice) public onlyOwner {
        _carbonCreditPrice = newCarbonCreditPrice;
    }

    function artistAddress(uint256 id, address newArtistAddress) public onlyOwner {
        artworks[id].artist = newArtistAddress;
    }
}
