// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ConsciousPlanetCollection
 * @dev ERC-1155 contract for managing a collection of artworks
 * @notice Developed by: Leandro Leite
 * @notice Twitter: @landitzz
 * @notice GitHub: https://github.com/leeandroleeite
 */

/**

 ██████╗ ██████╗ ███╗   ██╗███████╗ ██████╗██╗ ██████╗ ██╗   ██╗███████╗    ██████╗ ██╗      █████╗ ███╗   ██╗███████╗████████╗     ██████╗ ██████╗ ██╗     ██╗     ███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝██║██╔═══██╗██║   ██║██╔════╝    ██╔══██╗██║     ██╔══██╗████╗  ██║██╔════╝╚══██╔══╝    ██╔════╝██╔═══██╗██║     ██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██║     ██║   ██║██╔██╗ ██║███████╗██║     ██║██║   ██║██║   ██║███████╗    ██████╔╝██║     ███████║██╔██╗ ██║█████╗     ██║       ██║     ██║   ██║██║     ██║     █████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██║
██║     ██║   ██║██║╚██╗██║╚════██║██║     ██║██║   ██║██║   ██║╚════██║    ██╔═══╝ ██║     ██╔══██║██║╚██╗██║██╔══╝     ██║       ██║     ██║   ██║██║     ██║     ██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██║
╚██████╗╚██████╔╝██║ ╚████║███████║╚██████╗██║╚██████╔╝╚██████╔╝███████║    ██║     ███████╗██║  ██║██║ ╚████║███████╗   ██║       ╚██████╗╚██████╔╝███████╗███████╗███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
 ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝        ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
 
*/     

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";                               

/**
 * @dev This contract manages the collection of artworks using the ERC-1155 standard.
 */                                                                                                                                                                                                                
contract ConsciousPlanetCollection is ERC1155, Ownable, ERC1155Supply {

    // Private state variables
    string private  _contractName;
    uint256 private _mintPrice; 
    uint256 private _carbonCreditPrice;
    address private _carbonCreditAddress; 
    address private _projectOwnerAddress;
    uint256 private _projectOwnerShare;
    uint256 private _artistShare;
    uint256 private _curatorShare;
    address private _developerAddress;
    uint256 private _developerShare;
    uint256 private _referralShare;
    uint256 private _artistRoyalty;
    uint256 private _totalCopies = 100;

    // Events
    event ArtworkInitialized(
        uint256 indexed id,
        address indexed artist,
        address indexed curator,
        uint256 remainingCopies
    );
    event MintPriceUpdated(uint256 newPrice);
    event CarbonCreditPriceUpdated(uint256 newPrice);
    event DeveloperAddressUpdated(address newDeveloperAddress);
    event ReferralRegistered(address referral);
    event ReferralDeleted(address referral);

    // Structure to store artwork details
    struct Artwork {
        address artist;
        address curator;
        uint256 remainingCopies;
    }

    // Mapping to store artworks
    mapping(uint256 => Artwork) private artworks;

    // Mapping to store registered referrals
    mapping(address => bool) public registeredReferrals;

    /**
    * @dev Modifier to validate if the artwork exists
    * @param id The ID of the artwork
    */
    modifier validateArtwork(uint256 id) {
        require(artworks[id].artist != address(0), "Artwork not initialized");
        _;
    } 

   /**
     * @dev Constructor that initializes the contract with a name and URI.
     * @param contractName The name of the contract.
     * @param uri The URI for the ERC-1155 metadata.
     */
    constructor(
        string memory contractName, string memory uri) 
        ERC1155(uri) Ownable(msg.sender) {
            _contractName = contractName;
    }   


    /**
     * @dev Internal function to initialize an artwork
     * @param id The ID of the artwork
     * @param artist The address of the artist
     * @param curator The address of the curator
     */
    function initializeArtwork(uint256 id, address artist, address curator) internal onlyOwner {
        require(artworks[id].artist == address(0), "Artwork already initialized");
        artworks[id] = Artwork(artist, curator, _totalCopies);
        emit ArtworkInitialized(id, artist, curator, _totalCopies);
    }

    /**
     * @dev External function to initialize multiple artworks
     * @param ids The IDs of the artworks
     * @param artist The addresses of the artists
     * @param curator The addresses of the curators
     */
    function initializeArtworks(uint256[] calldata ids, address[] calldata artist, address[] calldata curator) external onlyOwner {
        require(ids.length == artist.length && artist.length == curator.length, "Input arrays must have the same length");

        for (uint256 i = 0; i < ids.length; i++) {
            initializeArtwork(ids[i], artist[i], curator[i]);
        }
    }

    /**
     * @dev External function to initialize contract parameters
     * @param mintPrice The price to mint an artwork
     * @param carbonCreditPrice The price of carbon credits
     * @param carbonCreditAddress The address for carbon credit payments
     * @param projectOwnerAddress The address of the project owner
     * @param artistShare The share percentage for the artist
     * @param curatorShare The share percentage for the curator
     * @param projectOwnerShare The share percentage for the project owner
     * @param developerAddress The address of the developer
     * @param developerShare The share percentage for the developer
     * @param referralShare The share percentage for referrals
     * @param artistRoyalty The royalty percentage for the artist
     */
    function initializeParameters(
        uint256 mintPrice, 
        uint256 carbonCreditPrice,
        address carbonCreditAddress,        
        address projectOwnerAddress, 
        uint256 artistShare,
        uint256 curatorShare,
        uint256 projectOwnerShare,
        address developerAddress,
        uint256 developerShare,
        uint256 referralShare,
        uint256 artistRoyalty
    ) external onlyOwner {
        _mintPrice = mintPrice;
        _carbonCreditPrice = carbonCreditPrice;
        _carbonCreditAddress = carbonCreditAddress;
        _projectOwnerAddress = projectOwnerAddress;
        _artistShare = artistShare;
        _curatorShare = curatorShare;
        _projectOwnerShare = projectOwnerShare;
        _developerAddress = developerAddress;
        _developerShare = developerShare;
        _referralShare = referralShare;
        _artistRoyalty = artistRoyalty;
    }

    /**
     * @dev External function to mint an artwork
     * @param id The ID of the artwork
     * @param amount The amount of artworks to mint
     * @param data Additional data
     * @param referral The address of the referral
     */
    function mint(uint256 id, uint256 amount, bytes memory data, address referral) external payable {
        _internalMint(msg.sender, id, amount, data, referral);
    }

    /**
     * @dev External function to mint an artwork to a specific address
     * @param to The address to mint to
     * @param id The ID of the artwork
     * @param amount The amount of artworks to mint
     * @param data Additional data
     * @param referral The address of the referral
     */
    function mintTo(address to, uint256 id, uint256 amount, bytes memory data, address referral) external payable {
        _internalMint(to, id, amount, data, referral);
    }

    /**
     * @dev External function for the owner to mint an artwork
     * @param to The address to mint to
     * @param id The ID of the artwork
     * @param amount The amount of artworks to mint
     * @param data Additional data
     */
    function adminMint(address to, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
        require(artworks[id].remainingCopies >= amount, "Not enough copies available");

        if (to == address(0)) {
            to = owner();
        }

        _mint(to, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    /**
     * @dev Function to get the contract name
     * @return The name of the contract
     */
    function name() external view returns (string memory) {
        return _contractName;
    }

    /**
    * @dev External function to get the URI
    * @param id The ID of the artwork to get the URI for
    * @return The URI of the specified artwork
    */
    function getURI(uint256 id) external view returns (string memory) {
        return uri(id);
    }

    /**
     * @dev External function to set a new URI
     * @param newuri The new URI to set
     */
    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    /**
     * @dev Function to get royalty information
     * @param id The ID of the artwork
     * @param value The value to calculate the royalty from
     * @return The address of the artist and the royalty amount
     */
    function royaltyInfo(uint256 id, uint256 value) external view returns (address, uint256 royaltyAmount) {
        royaltyAmount = value * (_artistRoyalty / 100);
        return (artworks[id].artist, royaltyAmount);
    }

    /**
     * @dev Function to check if an interface is supported
     * @param interfaceId The interface ID to check
     * @return True if the interface is supported, false otherwise
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev External function to register a referral
     * @param referral The address of the referral to register
     */
    function registerReferral(address referral) external onlyOwner {
        require(!registeredReferrals[referral], "Referral is already registered");
        registeredReferrals[referral] = true;
        emit ReferralRegistered(referral);
    }

    /**
     * @dev External function to delete a registered referral
     * @param referral The address of the referral to delete
     */
    function deleteReferral(address referral) external onlyOwner {
        require(registeredReferrals[referral], "Referral is not registered");
        registeredReferrals[referral] = false;
        emit ReferralDeleted(referral);
    }

    /**
     * @dev External function to check if a referral is registered
     * @param referral The address of the referral to check
     * @return True if the referral is registered, false otherwise
     */
    function isReferralRegistered(address referral) external view returns (bool) {
        return registeredReferrals[referral];
    }

    /**
     * @dev External function to get the mint price
     * @return The mint price
     */
    function getMintPrice() external view returns (uint256) {
        return _mintPrice;
    }

    /**
     * @dev External function to set a new mint price
     * @param newPrice The new mint price to set
     */
    function setMintPrice(uint256 newPrice) external onlyOwner {
        _mintPrice = newPrice;
        emit MintPriceUpdated(newPrice);
    }

    /**
     * @dev External function to get the developer address
     * @return The developer address
     */
    function getDeveloperAddress() external onlyOwner view returns (address) {
        return _developerAddress;
    }

    /**
     * @dev External function to set a new developer address
     * @param newDeveloperAddress The new developer address to set
     */
    function setDeveloperAddress(address newDeveloperAddress) external onlyOwner {
        _developerAddress = newDeveloperAddress;
        emit DeveloperAddressUpdated(newDeveloperAddress);
    }

    /**
     * @dev External function to get the carbon credit price
     * @return The carbon credit price
     */
    function getCarbonCreditPrice() external onlyOwner view returns (uint256) {
        return _carbonCreditPrice;
    }

    /**
     * @dev External function to set a new carbon credit price
     * @param newCarbonCreditPrice The new carbon credit price to set
     */
    function setCarbonCreditPrice(uint256 newCarbonCreditPrice) external onlyOwner {
        _carbonCreditPrice = newCarbonCreditPrice;
        emit CarbonCreditPriceUpdated(newCarbonCreditPrice);
    }

    /**
     * @dev External function to get the artist address of an artwork
     * @param id The ID of the artwork
     * @return The artist address
     */
    function getArtistAddress(uint256 id) external onlyOwner view returns (address) {
        return artworks[id].artist;
    }

    /**
     * @dev External function to set a new artist address for an artwork
     * @param id The ID of the artwork
     * @param newArtistAddress The new artist address to set
     */
    function setArtistAddress(uint256 id, address newArtistAddress) external onlyOwner {
        artworks[id].artist = newArtistAddress;
    }

    /**
    * @dev External function to update an existing artwork
    * @param id The ID of the artwork to update
    * @param newArtistAddress The new artist address to set
    * @param newCuratorAddress The new curator address to set
    */
    function updateArtwork(uint256 id, address newArtistAddress, address newCuratorAddress) external onlyOwner validateArtwork(id) {
        artworks[id].artist = newArtistAddress;
        artworks[id].curator = newCuratorAddress;
        emit ArtworkInitialized(id, newArtistAddress, newCuratorAddress, artworks[id].remainingCopies);
    }

    /**
     * @dev External function to get the details of an artwork
     * @param id The ID of the artwork
     * @return The artist address, curator address, and remaining copies
     */
    function getArtwork(uint256 id) external view returns (address, address, uint256) {
        Artwork storage artwork = artworks[id];
        return (artwork.artist, artwork.curator, artwork.remainingCopies);
    }

    /**
     * @dev Internal function to handle the minting process
     * @param to The address to mint to
     * @param id The ID of the artwork
     * @param amount The amount of artworks to mint
     * @param data Additional data
     * @param referral The address of the referral
     */
    function _internalMint(address to, uint256 id, uint256 amount, bytes memory data, address referral) internal {
        uint256 totalPayment = _mintPrice * amount;
        require(msg.value >= totalPayment, "Insufficient payment");
        require(artworks[id].remainingCopies >= amount, "Not enough copies available");

        uint256 artworkPrice = totalPayment - (_carbonCreditPrice * amount);
        uint256 artistPayment = artworkPrice * _artistShare / 100;
        uint256 developerPayment = artworkPrice * _developerShare / 100;
        uint256 curatorPayment = artworkPrice * _curatorShare / 100;
        uint256 projectOwnerPayment = artworkPrice * _projectOwnerShare / 100;
        uint256 referralPayment = (artworkPrice * _referralShare) / 100;

        _mint(to, id, amount, data);
        artworks[id].remainingCopies -= amount;

        address referralRecipient = referral;
        if (referralRecipient == address(0) || !registeredReferrals[referralRecipient]) {
            referralRecipient = _projectOwnerAddress;
        }

        payable(_carbonCreditAddress).transfer(_carbonCreditPrice * amount);

        payable(artworks[id].artist).transfer(artistPayment);
        payable(_developerAddress).transfer(developerPayment);
        payable(artworks[id].curator).transfer(curatorPayment);
        payable(_projectOwnerAddress).transfer(projectOwnerPayment);
        payable(referralRecipient).transfer(referralPayment);

        uint256 remainingBalance = address(this).balance;
        if (remainingBalance > 0) {
            payable(owner()).transfer(remainingBalance);
        }
    }

    /**
     * @dev Internal function to update the state of tokens
     * @param from The address sending the tokens
     * @param to The address receiving the tokens
     * @param ids The IDs of the tokens
     * @param values The amounts of the tokens
     */
    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

}
