pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

abstract contract NFTRole is ERC721, AccessControlEnumerable {

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, AccessControlEnumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}