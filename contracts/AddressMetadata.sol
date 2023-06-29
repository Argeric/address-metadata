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
    mapping (address => NameTagEntry)  public nameTagMapping;

    struct NameTagEntry {
        string currentNameTag;
        string currentWebsite;
        string expectNameTag;
        string expectWebsite;
        uint256 submitTimestamp;
        uint256 auditTimestamp;
    }

    modifier onlyAuditRole() {
        require(hasRole(Roles.AUDIT_ROLE, _msgSender()), "AddressMetadata: AUDIT_ROLE required");
        _;
    }

    event NameTagSubmitted(address indexed announcer, address indexed addr, string nameTag, string website);
    event NameTagChanged(address indexed auditor, address indexed addr, string currentNameTag, string currentWebsite,
        string expectNameTag, string expectWebsite);

    constructor() {
        _disableInitializers();
    }

    function initialize(string adminName) public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender(), adminName);
        _setupRole(Roles.AUDIT_ROLE, _msgSender(), adminName);
    }

    // TODO add method listing roles
    //

    function submitNameTag(address addr, string memory nameTag, string memory website)
    public
    virtual
    whenNotPaused
    {
        NameTagEntry storage nameTagEntry = nameTagMapping[addr];
        nameTagEntry.expectNameTag = nameTag;
        nameTagEntry.expectWebsite = website;
        nameTagEntry.submitTimestamp = block.timestamp;
        emit NameTagSubmitted(_msgSender(), addr, nameTag, website);
    }

    function auditNameTag(address addr, string memory nameTag, string memory website)
    public
    virtual
    whenNotPaused
    onlyAuditRole
    {
        NameTagEntry storage nameTagEntry = nameTagMapping[addr];
        require(keccak256(abi.encodePacked(nameTagEntry.expectNameTag)) == keccak256(abi.encodePacked(nameTag)),
            "AddressMetadata: The nameTag not match between the submitted by the user and the audited");
        require(keccak256(abi.encodePacked(nameTagEntry.expectWebsite)) == keccak256(abi.encodePacked(website)),
            "AddressMetadata: The website not match between the submitted by the user and the audited");
        string memory currentNameTag = nameTagEntry.currentNameTag;
        string memory currentWebsite = nameTagEntry.currentWebsite;
        nameTagEntry.currentNameTag = nameTagEntry.expectNameTag;
        nameTagEntry.currentWebsite = nameTagEntry.expectWebsite;
        nameTagEntry.auditTimestamp = block.timestamp;
        emit NameTagChanged(_msgSender(), addr, currentNameTag, currentWebsite, nameTag, website);
    }
}
