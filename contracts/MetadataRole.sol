pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

abstract contract MetadataRole is AccessControlEnumerable {

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }
}