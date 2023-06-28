pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "./MetadataRole.sol";

abstract contract MetadataPausable is MetadataRole, Pausable {

    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    constructor() {
        _setupRole(PAUSE_ROLE, _msgSender());
    }

    modifier onlyPauseRole() {
        require(hasRole(PAUSE_ROLE, _msgSender()), "MetadataPausable: PAUSE_ROLE required");
        _;
    }

    function pause() public onlyPauseRole {
        _pause();
    }

    function unpause() public onlyPauseRole {
        _unpause();
    }
}