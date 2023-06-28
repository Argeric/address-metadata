pragma solidity ^0.8.0;

import "./MetadataRole.sol";

abstract contract MetadataAudit is MetadataRole {

    bytes32 public constant AUDIT_ROLE = keccak256("AUDIT_ROLE");

    constructor() {
        _setupRole(AUDIT_ROLE, _msgSender());
    }

    modifier onlyAuditRole() {
        require(hasRole(AUDIT_ROLE, _msgSender()), "MetadataAudit: AUDIT_ROLE required");
        _;
    }
}