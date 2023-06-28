pragma solidity ^0.8.0;

import "./NFTRole.sol";

abstract contract NFTBurnable is NFTRole {

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() {
        _setupRole(BURNER_ROLE, _msgSender());
    }

    modifier onlyBurnerRole() {
        require(hasRole(BURNER_ROLE, _msgSender()), "NFTBurnable: BURNER_ROLE required");
        _;
    }

    function burn(uint256 tokenId) public onlyBurnerRole {
        _burn(tokenId);
    }

    function burnBatch(uint256[] memory tokenIds) public onlyBurnerRole {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i]);
        }
    }

}