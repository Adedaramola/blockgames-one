// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProdigalSonNFT is ERC721, Ownable {
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public mintPrice = 0.05 ether;
    bool public isMintEnabled = true;

    mapping(address => uint256) public mintBalanace;

    constructor() payable ERC721("ProdigalSonNFT", "PSN") {
        maxSupply = 3;
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    function mint() external payable {
        require(isMintEnabled, "You can't mint at this time");
        require(mintBalanace[msg.sender] < 1, "Exceed max per wallet");
        require(msg.value == mintPrice, "Wrong mint price");
        require(maxSupply > totalSupply, "Sold out");

        mintBalanace[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;

        _safeMint(msg.sender, tokenId);
    }
}
