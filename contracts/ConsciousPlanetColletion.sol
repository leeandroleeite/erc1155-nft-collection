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

    string private _contractName;
    uint256 private _mintPrice; 
    uint256 private _totalCopies;
    uint256 private _carbonCreditPrice;
    address private _carbonCreditWallet;
    address private _developerAddress; 
    address private _projectOwnerAddress;
    
    mapping(uint256 => Artwork) private artworks;

    struct Artwork {
        address artist;
        address curator;
        uint256 curatorShare;
        uint256 projectOwnerShare;
        uint256 remainingCopies;
    }

    event ArtworkInitialized(
        uint256 indexed id,
        address indexed artist,
        address indexed curator,
        uint256 curatorShare,
        uint256 projectOwnerShare,
        uint256 remainingCopies
    );

    constructor(string memory contractName, string memory uri, uint256 mintPrice, uint256 totalCopies, address projectOwnerAddress, address developerAddress, address carbonCreditWallet, uint256 carbonCreditPrice) ERC1155(uri) Ownable(msg.sender) {
        _contractName = contractName;
        _mintPrice = mintPrice;
        _developerAddress = developerAddress;
        _carbonCreditWallet = carbonCreditWallet;
        _carbonCreditPrice = carbonCreditPrice;
        _projectOwnerAddress = projectOwnerAddress;
        _totalCopies = totalCopies;

        initializeArtwork(1, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(2, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(3, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(4, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(5, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(6, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(7, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(8, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(9, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(10, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(11, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(12, 0x85C57c423D3Fc998B66F02b65CD3AfD7F5787Dc0, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);

        initializeArtwork(13, 0xfd9174897026FFE282a526Fd364a139e750B4f19, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(14, 0xEa5a65D8973B96FaA9404F472dBDfc67b8bb620C, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(15, 0x99aeAbFF6b7E610509B2862A566aE663E84b7aD5, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(16, 0x4D2CE12595b20269d89B85b6f61385ceA25d2B06, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(17, 0x11A2fCf0a5F5D3675D94208F5979D8f98825Cb99, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(18, 0x4BcEe74F8c2520e5a151d6262D81EC9A20152847, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(19, 0xa9fc46A0bfACf1b9cA610B67f58F974fdE87D174, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(20, 0x7354112F9EAE0d7a4334E48005BbB0719ED9318e, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(21, 0xa9fc46A0bfACf1b9cA610B67f58F974fdE87D174, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(22, 0x99aeAbFF6b7E610509B2862A566aE663E84b7aD5, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(23, 0xEa5a65D8973B96FaA9404F472dBDfc67b8bb620C, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(24, 0x3fA2eB8a9227d24E1AB60d6Ea7EDaAa50672A12e, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(25, 0xb3FdEb6350E7a786d100563e536Ba1ffD04fF14F, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(26, 0x3a698bf51eA2A9071B5C3A263D2cc3259125c225, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10); // korean
        initializeArtwork(27, 0xc509ecaA3D2123855dcc9B1aeD6b2b8a015aabc2, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10); // korean
        initializeArtwork(28, 0xa0E49a6Dd136378c9bB5f1AD970C472678a69C84, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10); // korean
        initializeArtwork(29, 0xc011Abc3ffFd32231F4806c5B1120E01a7dcb9a9, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(30, 0xaBaA5C99C52d69D80bFc18Fc1229170b80698ED4, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10); // korean
        initializeArtwork(31, 0x3fA2eB8a9227d24E1AB60d6Ea7EDaAa50672A12e, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
        initializeArtwork(32, 0xE3effeD865344291FB71EFF3C13F8Eeb4F4C3242, 0x53aebA3b107774a8380341c7429Bf352127fA1A3, 5, 10);
    }    

    function initializeArtwork(uint256 id, address artist, address curator, uint256 curatorShare, uint256 projectOwnerShare) private onlyOwner {
        require(artworks[id].artist == address(0), "Artwork already initialized");
        artworks[id] = Artwork(artist, curator, curatorShare, projectOwnerShare, _totalCopies);
        emit ArtworkInitialized(id, artist, curator, curatorShare, projectOwnerShare, _totalCopies);
    }
   
    function mint(uint256 id, uint256 amount, bytes memory data) external payable {
        uint256 totalPayment = _mintPrice * amount;

        require(msg.value >= totalPayment, "Insufficient payment");

        uint artworkPrice = totalPayment - _carbonCreditPrice;

        uint256 artistPayment = artworkPrice * 80 / 100;
        uint256 developerPayment = artworkPrice * 5 / 100;
        uint256 curatorPayment = artworkPrice * artworks[id].curatorShare / 100;
        uint256 projectOwnerPayment = artworkPrice * artworks[id].projectOwnerShare / 100;

        payable(artworks[id].artist).transfer(artistPayment);
        payable(artworks[id].curator).transfer(curatorPayment);
        payable(_developerAddress).transfer(developerPayment);
        payable(_projectOwnerAddress).transfer(projectOwnerPayment);

        _mint(msg.sender, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function ownerMint(uint256 id, uint256 amount, bytes memory data) external onlyOwner {
        _mint(msg.sender, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function ownerMintAndSendTo(address to, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
        _mint(to, id, amount, data);
        artworks[id].remainingCopies -= amount;
    }

    function name() external view returns (string memory) {
        return _contractName;
    }

    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    function royaltyInfo(uint256 tokenId, uint256 value) external view returns (address, uint256) {
        return (artworks[tokenId].artist, value * 10 / 100); // 5% royalty to the creator
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    function getContractOwnerAddress() external onlyOwner view returns (address) {
        return _projectOwnerAddress;
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

    function updateCarbonCreditPrice(uint256 newCarbonCreditPrice) external onlyOwner {
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

    function getArtwork(uint256 id) external view returns (address, address, uint256, uint256, uint256) {
        Artwork storage artwork = artworks[id];
        return (artwork.artist, artwork.curator, artwork.curatorShare, artwork.projectOwnerShare, artwork.remainingCopies);
    }
}
