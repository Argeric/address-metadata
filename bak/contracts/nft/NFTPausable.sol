pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "./NFTRole.sol";

abstract contract NFTPausable is NFTRole, Pausable {

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor() {
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    modifier onlyPauserRole() {
        require(hasRole(PAUSER_ROLE, _msgSender()), "NFTPausable: PAUSER_ROLE required");
        _;
    }

    function pause() public onlyPauserRole {
        _pause();
    }

    function unpause() public onlyPauserRole {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        require(!paused(), "NFTPausable: token transfer while paused");
        super._beforeTokenTransfer(from, to, tokenId);
    }

}