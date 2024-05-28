// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract ConsciousPlanetColletion is ERC1155, Ownable, ERC1155Supply {

    string private  _contractName;
    uint256 private _mintPrice; 
    uint256 private _carbonCreditPrice;
    address private _projectOwnerAddress;
    address private _carbonCreditWallet;
    uint256 private _artistShare;
    uint256 private _curatorShare;
    uint256 private _projectOwnerShare;
    uint256 private _developerShare;
    uint256 private _artistRoyalty;

    uint256 private _totalCopies = 100;
    address private _developerAddress = 0x6586102aDa64aB59C00546f8c2aE10E8AeEbf125; 

    mapping(uint256 => Artwork) private artworks;

    struct Artwork {
        address artist;
        address curator;
        uint256 remainingCopies;
    }

    event ArtworkInitialized(
        uint256 indexed id,
        address indexed artist,
        address indexed curator,
        uint256 remainingCopies
    );

    constructor(
        string memory contractName, 
        string memory uri, 
        uint256 mintPrice, 
        address projectOwnerAddress, 
        address carbonCreditWallet, 
        uint256 carbonCreditPrice,
        uint256 artistShare,
        uint256 curatorShare,
        uint256 projectOwnerShare,
        uint256 developerShare,
        uint256 artistRoyalty
        ) 
        
        ERC1155(uri) Ownable(msg.sender) {
        _contractName = contractName;
        _mintPrice = mintPrice;
        _carbonCreditWallet = carbonCreditWallet;
        _carbonCreditPrice = carbonCreditPrice;
        _projectOwnerAddress = projectOwnerAddress;
        _artistShare = artistShare;
        _curatorShare = curatorShare;
        _projectOwnerShare = projectOwnerShare;
        _developerShare = developerShare;
        _artistRoyalty = artistRoyalty;
    }    

    function initializeArtwork(uint256 id, address artist, address curator) internal onlyOwner {
        require(artworks[id].artist == address(0), "Artwork already initialized");
        artworks[id] = Artwork(artist, curator, _totalCopies);
        emit ArtworkInitialized(id, artist, curator, _totalCopies);
    }

    function initializeArtworks(uint256[] calldata ids, address[] calldata artist, address[] calldata curator) external onlyOwner {
        require(ids.length == artist.length && artist.length == curator.length, "Input arrays must have the same length");

        for (uint256 i = 0; i < ids.length; i++) {
            initializeArtwork(ids[i], artist[i], curator[i]);
        }
    }
   
    function mint(uint256 id, uint256 amount, bytes memory data) external payable {
        uint256 totalPayment = _mintPrice * amount;

        require(msg.value >= totalPayment, "Insufficient payment");

        uint artworkPrice = totalPayment - _carbonCreditPrice;

        uint256 artistPayment = artworkPrice * _artistShare / 100;
        uint256 developerPayment = artworkPrice * _developerShare / 100;
        uint256 curatorPayment = artworkPrice * _curatorShare / 100;
        uint256 projectOwnerPayment = artworkPrice * _projectOwnerShare / 100;

        payable(artworks[id].artist).transfer(artistPayment);
        payable(_developerAddress).transfer(developerPayment);
        payable(artworks[id].curator).transfer(curatorPayment);
        payable(_projectOwnerAddress).transfer(projectOwnerPayment);

        _mint(msg.sender, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function name() external view returns (string memory) {
        return _contractName;
    }

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    function royaltyInfo(uint256 id, uint256 value) external view returns (address, uint256) {
        return (artworks[id].artist, value * (_artistRoyalty / 100));
    }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    function getMintPrice() external view returns (uint256) {
        return _mintPrice;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        _mintPrice = newPrice;
    }

    function getDeveloperAddress() external onlyOwner view returns (address) {
        return _developerAddress;
    }

    function setDeveloperAddress(address newDeveloperAddress) external onlyOwner {
        _developerAddress = newDeveloperAddress;
    }

    function getCarbonCreditWallet() external onlyOwner view returns (address) {
        return _carbonCreditWallet;
    }

    function setCarbonCreditWallet(address newWallet) external onlyOwner {
        _carbonCreditWallet = newWallet;
    }

    function getCarbonCreditPrice() external onlyOwner view returns (uint256) {
        return _carbonCreditPrice;
    }

    function setCarbonCreditPrice(uint256 newCarbonCreditPrice) external onlyOwner {
        _carbonCreditPrice = newCarbonCreditPrice;
    }

    function getRemainingCopies(uint256 id) external onlyOwner view returns (uint256) {
        return artworks[id].remainingCopies;
    }

    function getArtistAddress(uint256 id) external onlyOwner view returns (address) {
        return artworks[id].artist;
    }

    function setArtistAddress(uint256 id, address newArtistAddress) external onlyOwner {
        artworks[id].artist = newArtistAddress;
    }

    function getArtwork(uint256 id) external view returns (address, address, uint256) {
        Artwork storage artwork = artworks[id];
        return (artwork.artist, artwork.curator, artwork.remainingCopies);
    }
}
