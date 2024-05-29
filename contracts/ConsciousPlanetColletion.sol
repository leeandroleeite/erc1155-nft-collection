// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ConsciousPlanetCollection
 * @dev ERC-1155 contract for managing a collection of artworks
 * @notice Developed by: Leandro Leite
 * @notice Contact: leeandro.leeite@gmail.com
 * @notice Twitter: @landitzz
 * @notice GitHub: https://github.com/leeandroleeite
 */

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
    address private _projectOwner;
    uint256 private _carbonCreditPrice;
    address private _carbonCreditWallet;
    uint256 private _artistShare;
    uint256 private _curatorShare;
    uint256 private _projectOwnerShare;
    uint256 private _developerShare;
    uint256 private _artistRoyalty;
    uint256 private _totalCopies = 100;
    address private _developerAddress = 0x6586102aDa64aB59C00546f8c2aE10E8AeEbf125; 

    // Mapping from token ID to Artwork struct
    mapping(uint256 => Artwork) private artworks;

    // Struct to store information about each artwork
    struct Artwork {
        address artist;
        address curator;
        uint256 remainingCopies;
    }

    // Event emitted when a new artwork is initialized
    event ArtworkInitialized(
        uint256 indexed id,
        address indexed artist,
        address indexed curator,
        uint256 remainingCopies
    );

    /**
     * @dev Constructor to initialize the contract with basic details.
     * @param contractName The name of the contract.
     * @param uri The base URI for the ERC1155 tokens.
     * @param mintPrice The price to mint each token.
     * @param projectOwner The address of the project owner.
     * @param carbonCreditWallet The address to receive carbon credits.
     * @param carbonCreditPrice The price of carbon credits.
     * @param artistShare The share of minting fee for the artist.
     * @param curatorShare The share of minting fee for the curator.
     * @param projectOwnerShare The share of minting fee for the project owner.
     * @param developerShare The share of minting fee for the developer.
     * @param artistRoyalty The royalty percentage for the artist.
     */
    constructor(
        string memory contractName, 
        string memory uri, 
        uint256 mintPrice, 
        address projectOwner, 
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
        _projectOwner = projectOwner;
        _carbonCreditWallet = carbonCreditWallet;
        _carbonCreditPrice = carbonCreditPrice;
        _artistShare = artistShare;
        _curatorShare = curatorShare;
        _projectOwnerShare = projectOwnerShare;
        _developerShare = developerShare;
        _artistRoyalty = artistRoyalty;
    }    

    /**
     * @dev Internal function to initialize a single artwork.
     * @param id The ID of the artwork.
     * @param artist The address of the artist.
     * @param curator The address of the curator.
     */
    function initializeArtwork(uint256 id, address artist, address curator) internal onlyOwner {
        require(artworks[id].artist == address(0), "Artwork already initialized");
        artworks[id] = Artwork(artist, curator, _totalCopies);
        emit ArtworkInitialized(id, artist, curator, _totalCopies);
    }

    /**
     * @dev Function to initialize multiple artworks.
     * @param ids The IDs of the artworks.
     * @param artist The addresses of the artists.
     * @param curator The addresses of the curators.
     */
    function initializeArtworks(uint256[] calldata ids, address[] calldata artist, address[] calldata curator) external onlyOwner {
        require(ids.length == artist.length && artist.length == curator.length, "Input arrays must have the same length");

        for (uint256 i = 0; i < ids.length; i++) {
            initializeArtwork(ids[i], artist[i], curator[i]);
        }
    }
   
    /**
     * @dev Function to mint new tokens.
     * @param id The ID of the artwork to mint.
     * @param amount The number of tokens to mint.
     * @param data Additional data with no specified format.
     */
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
        payable(_projectOwner).transfer(projectOwnerPayment);

        _mint(msg.sender, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    /**
     * @dev Function to get the name of the contract.
     * @return The name of the contract.
     */
    function name() external view returns (string memory) {
        return _contractName;
    }

    /**
     * @dev Function to set a new URI for all token types.
     * @param newuri The new URI.
     */
    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    /**
     * @dev Function to get the royalty information.
     * @param id The ID of the token.
     * @param value The sale value of the token.
     * @return The address to receive the royalty and the royalty amount.
     */
    function royaltyInfo(uint256 id, uint256 value) external view returns (address, uint256) {
        return (artworks[id].artist, value * (_artistRoyalty / 100));
    }

    /**
     * @dev Override function to update token balances.
     * @param from The address transferring the tokens.
     * @param to The address receiving the tokens.
     * @param ids The IDs of the tokens being transferred.
     * @param values The amounts of the tokens being transferred.
     */
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    /**
     * @dev Function to get the current mint price.
     * @return The current mint price.
     */
    function getMintPrice() external view returns (uint256) {
        return _mintPrice;
    }

    /**
     * @dev Function to set a new mint price.
     * @param newPrice The new mint price.
     */
    function setMintPrice(uint256 newPrice) external onlyOwner {
        _mintPrice = newPrice;
    }

    /**
     * @dev Function to get the developer's address.
     * @return The developer's address.
     */
    function getDeveloperAddress() external onlyOwner view returns (address) {
        return _developerAddress;
    }

    /**
     * @dev Function to set a new developer address.
     * @param newDeveloperAddress The new developer address.
     */
    function setDeveloperAddress(address newDeveloperAddress) external onlyOwner {
        _developerAddress = newDeveloperAddress;
    }

    /**
     * @dev Function to get the carbon credit wallet address.
     * @return The carbon credit wallet address.
     */
    function getCarbonCreditWallet() external onlyOwner view returns (address) {
        return _carbonCreditWallet;
    }

    /**
     * @dev Function to set a new carbon credit wallet address.
     * @param newWallet The new carbon credit wallet address.
     */
    function setCarbonCreditWallet(address newWallet) external onlyOwner {
        _carbonCreditWallet = newWallet;
    }

    /**
     * @dev Function to get the current carbon credit price.
     * @return The current carbon credit price.
     */
    function getCarbonCreditPrice() external onlyOwner view returns (uint256) {
        return _carbonCreditPrice;
    }

    /**
     * @dev Function to set a new carbon credit price.
     * @param newCarbonCreditPrice The new carbon credit price.
     */
    function setCarbonCreditPrice(uint256 newCarbonCreditPrice) external onlyOwner {
        _carbonCreditPrice = newCarbonCreditPrice;
    }

    /**
     * @dev Function to get the remaining copies of a specific artwork.
     * @param id The ID of the artwork.
     * @return The remaining copies of the artwork.
     */
    function getRemainingCopies(uint256 id) external onlyOwner view returns (uint256) {
        return artworks[id].remainingCopies;
    }

    /**
     * @dev Function to get the artist address of a specific artwork.
     * @param id The ID of the artwork.
     * @return The address of the artist.
     */
    function getArtistAddress(uint256 id) external onlyOwner view returns (address) {
        return artworks[id].artist;
    }

    /**
     * @dev Function to set a new artist address for a specific artwork.
     * @param id The ID of the artwork.
     * @param newArtistAddress The new artist address.
     */
    function setArtistAddress(uint256 id, address newArtistAddress) external onlyOwner {
        artworks[id].artist = newArtistAddress;
    }

    /**
     * @dev Function to get all information of a specific artwork.
     * @param id The ID of the artwork.
     * @return The artist address, curator address, and remaining copies of the artwork.
     */
    function getArtwork(uint256 id) external view returns (address, address, uint256) {
        Artwork storage artwork = artworks[id];
        return (artwork.artist, artwork.curator, artwork.remainingCopies);
    }
}
