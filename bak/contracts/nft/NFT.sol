pragma solidity ^0.8.0;

import "@confluxfans/contracts/token/CRC721/extensions/CRC721Enumerable.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";

import "./NFTMintable.sol";
import "./NFTMetadata.sol";
import "./NFTBurnable.sol";
import "./NFTPausable.sol";
import "./NFTAdmin.sol";

contract NFT is
CRC721Enumerable,
NFTMintable,
NFTMetadata,
NFTBurnable,
NFTPausable,
NFTAdmin,
InternalContractsHandler
{
    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI
    ) ERC721(name, symbol) NFTMetadata(baseTokenURI) {
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, NFTMetadata) returns (string memory) {
        return NFTMetadata.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721Enumerable, NFTRole)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, NFTPausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

}