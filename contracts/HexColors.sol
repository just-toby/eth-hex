// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HexColors is ERC721, Ownable {
    constructor() ERC721("HexColors", "HEXC") {}

    // Fallback function to make this contract payable.
    receive() external payable {}

    /**
     * @dev Base URI for computing {tokenURI}.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://www.eth-hex.com/api/token?id=";
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function mintRed(uint256 value) external returns (uint256) {
        // XX0000
        require(value >= 0);
        require(value < 256);
        uint256 newTokenId = value * 65536;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }

    function mintGreen(uint256 value) external returns (uint256) {
        // 00XX00
        require(value >= 0);
        require(value < 256);
        uint256 newTokenId = value * 256;
        _safeMint(address(msg.sender), newTokenId);
        return newTokenId;
    }

    function mintBlue(uint256 value) external returns (uint256) {
        // 0000XX
        require(value >= 0);
        require(value < 256);
        _safeMint(address(msg.sender), value);
        return value;
    }

    function combineRedAndGreen(uint256 redToken, uint256 greenToken)
        external
        returns (uint256)
    {
        require(ownerOf(redToken) == msg.sender);
        require(ownerOf(greenToken) == msg.sender);
        require(redToken % 65536 == 0);
        require(greenToken % 256 == 0);
        uint256 newTokenId = redToken + greenToken;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }

    function combineRedAndBlue(uint256 redToken, uint256 blueToken)
        external
        returns (uint256)
    {
        require(ownerOf(redToken) == msg.sender);
        require(ownerOf(blueToken) == msg.sender);
        require(redToken % 65536 == 0);
        require(blueToken < 256);
        uint256 newTokenId = redToken + blueToken;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }

    function combineGreenAndBlue(uint256 greenToken, uint256 blueToken)
        external
        returns (uint256)
    {
        require(ownerOf(blueToken) == msg.sender);
        require(ownerOf(greenToken) == msg.sender);
        require(blueToken < 256);
        require(greenToken % 256 == 0);
        uint256 newTokenId = greenToken + blueToken;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }

    function combine3(
        uint256 redToken,
        uint256 greenToken,
        uint256 blueToken
    ) external returns (uint256) {
        require(ownerOf(redToken) == msg.sender);
        require(ownerOf(greenToken) == msg.sender);
        require(ownerOf(blueToken) == msg.sender);
        require(redToken % 65536 == 0);
        require(greenToken % 256 == 0);
        require(blueToken < 256);
        uint256 newTokenId = redToken + greenToken + blueToken;
        _safeMint(address(msg.sender), newTokenId);

        return newTokenId;
    }
}
