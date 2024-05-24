// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ERC1155Token
 * @dev Implementation of the ERC1155 Multi Token Standard
 */
contract ERC1155Token is ERC1155, Ownable {
    constructor(string memory uri) ERC1155(uri) Ownable(msg.sender) {}
    
    /**
     * @dev Function to mint tokens
     * @param account The address that will receive the minted tokens
     * @param id The token id to mint
     * @param amount The amount of tokens to mint
     * @param data Data to pass if receiver is contract
     */
    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner {
        _mint(account, id, amount, data);
    }

    /**
     * @dev Function to mint batch tokens
     * @param to The address that will receive the minted tokens
     * @param ids The token ids to mint
     * @param amounts The amount of tokens to mint for each id
     * @param data Data to pass if receiver is contract
     */
    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }
}
