pragma solidity ^0.8.4;

import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";

import "./MetadataAudit.sol";
import "./MetadataPausable.sol";
import "./Roles.sol";

contract AddressMetadata is
MetadataRole,
Initializable,
InternalContractsHandler
{
    modifier onlyAuditRole() {
        require(hasRole(Roles.AUDIT_ROLE, _msgSender()), "AddressMetadata: AUDIT_ROLE required");
        _;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(string adminName) public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender(), adminName);
        _setupRole(Roles.AUDIT_ROLE, _msgSender(), adminName);
    }

    mapping (address => NameTag)  public nameTagMapping;
    struct NameTag {
        string name;
        string website;
        uint256 auditTime;
    }

    mapping (address => string[]) public labelsMapping;
    uint8 constant LABEL_MAX = 10;
    struct Labels {
        string[] labelArray;
        uint8 arrayLen;
        uint256 auditTime;
    }

    event NameTagChanged(address indexed auditor, address indexed addr, string currentNameTag, string currentWebsite,
        string expectNameTag, string expectWebsite);
    event LabelAdded(address indexed auditor, address indexed addr, string label);
    event LabelDeleted(address indexed auditor, address indexed addr, string label);

    function updateNameTag(address addr, string memory name, string memory website)
    public
    virtual
    onlyAuditRole
    {
        NameTag storage nameTag = nameTagMapping[addr];
        nameTag.name = name;
        nameTag.website = website;
        nameTag.auditTime = block.timestamp;
        emit NameTagChanged(_msgSender(), addr, name, website);
    }

    function addLabel(address addr, string memory label)
    public
    virtual
    onlyAuditRole
    {

        emit LabelAdded(_msgSender(), addr, label);
    }

    function deleteLabel(address addr, string memory label)
    public
    virtual
    onlyAuditRole
    {

        emit LabelDeleted(_msgSender(), addr, label);
    }
}
