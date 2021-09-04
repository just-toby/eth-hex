// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HexColors is ERC721, Ownable {
    using SafeMath for uint256;

    constructor() ERC721("HexColors", "HEXC") {}

    // Fallback function to make this contract payable.
    receive() external payable {}

    /**
     * @dev Base URI for computing {tokenURI}.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://www.eth-hex.com/api/token?id=";
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        string hexValue = 0x0 + tokenId;
        return
            '<svg width="100" height="100"><rect fill="' +
            "#" +
            "" +
            '" width="100" height="100"/></svg>';
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function mintBlack() external onlyOwner returns (uint256) {
        _safeMint(msg.sender, 0);
        return 0;
    }

    function mintRed(uint256 value) external returns (uint256) {
        // XX0000
        require(value > 0);
        require(value < 256);
        uint256 newTokenId = value * 65536;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }

    function mintGreen(uint256 value) external returns (uint256) {
        // 00XX00
        require(value > 0);
        require(value < 256);
        uint256 newTokenId = value * 256;
        _safeMint(address(msg.sender), newTokenId);
        return newTokenId;
    }

    function mintBlue(uint256 value) external returns (uint256) {
        // 0000XX
        require(value > 0);
        require(value < 256);
        _safeMint(address(msg.sender), value);
        return value;
    }

    function combine(uint256 firstToken, uint256 secondToken)
        external
        returns (uint256)
    {
        require(ownerOf(firstToken) == msg.sender);
        require(ownerOf(secondToken) == msg.sender);

        // XX0000
        uint256 firstRed = firstToken.div(65536);
        uint256 secondRed = secondToken.div(65536);

        // 00XX00
        uint256 firstGreen = firstToken.div(256).mod(256);
        uint256 secondGreen = secondToken.div(256).mod(256);

        // 0000XX
        uint256 firstBlue = firstToken.mod(256);
        uint256 secondBlue = secondToken.mod(256);

        uint256 newRed = ((firstRed + secondRed).div(2)).mul(65536);
        uint256 newGreen = ((firstGreen + secondGreen).div(2)).mul(256);
        uint256 newBlue = (firstBlue + secondBlue).div(2);

        uint256 newTokenId = newRed + newGreen + newBlue;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }
}
