pragma solidity ^0.8.0;

import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";

import "./MetadataAudit.sol";
import "./MetadataPausable.sol";

contract AddressMetadata is
MetadataAudit,
MetadataPausable,
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

    event SubmitNameTag(address indexed announcer, address indexed addr, string nameTag, string website);
    event AuditNameTag(address indexed auditor, address indexed addr, string currentNameTag, string currentWebsite,
        string expectNameTag, string expectWebsite);

    function submitNameTag(address addr, string memory nameTag, string memory website)
    public
    virtual
    whenNotPaused
    {
        NameTagEntry storage nameTagEntry = nameTagMapping[addr];
        nameTagEntry.expectNameTag = nameTag;
        nameTagEntry.expectWebsite = website;
        nameTagEntry.submitTimestamp = block.timestamp;
        emit SubmitNameTag(_msgSender(), addr, nameTag, website);
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
        emit AuditNameTag(_msgSender(), addr, currentNameTag, currentWebsite, nameTag, website);
    }
}