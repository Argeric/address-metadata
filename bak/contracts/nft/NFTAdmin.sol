pragma solidity ^0.8.0;

import "./NFTRole.sol";

abstract contract NFTAdmin is NFTRole {

    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    constructor() {
        _setupRole(TRANSFER_ROLE, _msgSender());
    }

    modifier onlyTransferRole() {
        require(hasRole(TRANSFER_ROLE, _msgSender()), "NFTAdmin: TRANSFER_ROLE required");
        _;
    }

    function transferFromByAdmin(address from, address to, uint256 tokenId) public onlyTransferRole {
        _transfer(from, to, tokenId);
    }

    function safeTransferFromByAdmin(address from, address to, uint256 tokenId) public {
        safeTransferFromByAdmin(from, to, tokenId, "");
    }

    function safeTransferFromByAdmin(address from, address to, uint256 tokenId, bytes memory data) public onlyTransferRole {
        _safeTransfer(from, to, tokenId, data);
    }

}