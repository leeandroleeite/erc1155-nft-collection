// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";


/**
 * @title ERC1155Token
 * @dev Implementation of the ERC1155 Multi Token Standard
 */
contract ERC1155Token is ERC1155, Ownable, ERC1155Supply {

    string private _tokenContractName; // Name of the ERC1155 token contract
    uint256 private _mintPrice; // Price for minting each token


    constructor(string memory contractName, string memory uri, uint256 mintPrice) ERC1155(uri) Ownable(msg.sender) {
        _tokenContractName = contractName;
        _mintPrice = mintPrice;

    }    

    // /**
    //  * @dev Function to mint tokens
    //  * @param account The address that will receive the minted tokens
    //  * @param id The token id to mint
    //  * @param amount The amount of tokens to mint
    //  * @param data Data to pass if receiver is contract
    //  */
    // function mint(address account, uint256 id, uint256 amount, bytes memory data) public payable {
    //     require(msg.value == _mintPrice * amount, "Incorrect payment amount");
    //     _mint(msg.sender, id, amount, data);
    // }

        /*
     * @dev Function to mint tokens
     * @param account The address that will receive the minted tokens
     * @param id The token id to mint
     * @param amount The amount of tokens to mint
     * @param data Data to pass if receiver is contract
     */
    function mint(uint256 id, uint256 amount, bytes memory data) public payable {
        require(msg.value == _mintPrice * amount, "Incorrect payment amount");
        _mint(msg.sender, id, amount, data);
    }
    
    /**
     * @dev Function to update the URI of the token metadata
     * @param newuri The new URI
     */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

   /**
     * @dev Function to get the name of the token contract
     */
    function name() public view returns (string memory) {
        return _tokenContractName;
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }

    /**
     * @dev Function to get the mint price
     */
    function getMintPrice() public view returns (uint256) {
        return _mintPrice;
    }

    /**
     * @dev Function to update the mint price
     * @param newPrice The new mint price
     */
    function updateMintPrice(uint256 newPrice) public onlyOwner {
        _mintPrice = newPrice;
    }
}
