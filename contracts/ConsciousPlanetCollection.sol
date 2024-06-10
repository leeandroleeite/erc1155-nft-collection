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
                                                                                                                                                                                                                
contract ConsciousPlanetCollection is ERC1155, Ownable, ERC1155Supply {

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

    event MintPriceUpdated(uint256 newPrice);
    event CarbonCreditPriceUpdated(uint256 newPrice);
    event DeveloperAddressUpdated(address newDeveloperAddress);
    event ReferralRegistered(address referral);
    event ReferralDeleted(address referral);

    mapping(address => bool) public registeredReferrals;

    constructor(
        string memory contractName, string memory uri) 
        ERC1155(uri) Ownable(msg.sender) {
            _contractName = contractName;
    }    

    modifier validateArtwork(uint256 id) {
        require(artworks[id].artist != address(0), "Artwork not initialized");
        _;
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

    function mint(uint256 id, uint256 amount, bytes memory data, address referral) external payable {
        _internalMint(msg.sender, id, amount, data, referral);
    }

    function mintTo(address to, uint256 id, uint256 amount, bytes memory data, address referral) external payable {
        _internalMint(to, id, amount, data, referral);
    }
   
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

        _mint(to, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function adminMint(address to, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
        require(artworks[id].remainingCopies >= amount, "Not enough copies available");

        if (to == address(0)) {
            to = owner();
        }

        _mint(to, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function name() external view returns (string memory) {
        return _contractName;
    }

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    function royaltyInfo(uint256 id, uint256 value) external view returns (address, uint256 royaltyAmount) {
        royaltyAmount = value * (_artistRoyalty / 100);
        return (artworks[id].artist, royaltyAmount);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function registerReferral(address referral) external onlyOwner {
        require(!registeredReferrals[referral], "Referral is already registered");
        registeredReferrals[referral] = true;
        emit ReferralRegistered(referral);
    }

    function deleteReferral(address referral) external onlyOwner {
        require(registeredReferrals[referral], "Referral is not registered");
        registeredReferrals[referral] = false;
        emit ReferralDeleted(referral);
    }

    function isReferralRegistered(address referral) external view returns (bool) {
        return registeredReferrals[referral];
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
        emit MintPriceUpdated(newPrice);
    }

    function getDeveloperAddress() external onlyOwner view returns (address) {
        return _developerAddress;
    }

    function setDeveloperAddress(address newDeveloperAddress) external onlyOwner {
        _developerAddress = newDeveloperAddress;
        emit DeveloperAddressUpdated(newDeveloperAddress);
    }

    function getCarbonCreditPrice() external onlyOwner view returns (uint256) {
        return _carbonCreditPrice;
    }

    function setCarbonCreditPrice(uint256 newCarbonCreditPrice) external onlyOwner {
        _carbonCreditPrice = newCarbonCreditPrice;
        emit CarbonCreditPriceUpdated(newCarbonCreditPrice);
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
