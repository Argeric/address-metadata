pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

abstract contract MetadataRole is AccessControlEnumerable {

    mapping(address => string) private _roleMemberNames;

    function grantRole(bytes32 role, address account, string memory name) public virtual override onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account, name);
    }

    function _setupRole(bytes32 role, address account, string memory name) internal virtual {
        _grantRole(role, account, name);
    }

    function _grantRole(bytes32 role, address account, string memory name) internal virtual override {
        super._grantRole(role, account);
        _roleMemberNames[account] = name;
    }

    function _revokeRole(bytes32 role, address account) internal virtual {
        super._revokeRole(role, account);
        delete _roleMemberNames[account];
    }
}