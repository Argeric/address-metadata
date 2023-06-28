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

    struct NameTagEntry{
        string nameTag;
        string website;
        STATUS status;
        uint256 auditTimestamp;
    }

    enum STATUS {INIT/*0*/, TO_ADD/*1*/, ADDED/*2*/, TO_DELETE/*3*/}

    event NameTagAdd(address indexed announcer, address indexed addr, string nameTag, string website);
    event NameTagDelete(address indexed announcer, address indexed addr);
    event NameTagAdded(address indexed auditor,address indexed addr);
    event NameTagDeleted(address indexed auditor,address indexed addr);

    // The method addNameTag can be called only when status is INIT or TO_ADD
    function addNameTag(address addr, string memory nameTag, string memory website)
    public
    virtual
    whenNotPaused
    {
        require(bytes(nameTag).length != 0, "AddressMetadata: nameTag is null, please provide it");
        require(bytes(website).length != 0, "AddressMetadata: website is null, please provide it");
        STATUS status = nameTagMapping[addr].status;
        if(status == STATUS.ADDED) {
            revert("AddressMetadata: name tag has been added, please remove it");
        }
        if(status == STATUS.TO_DELETE) {
            revert("AddressMetadata: name tag deletion request has been submitted, please wait for audit");
        }
        nameTagMapping[addr] = NameTagEntry(nameTag, website, STATUS.TO_ADD, 0);
        emit NameTagAdd(_msgSender(), addr, nameTag, website);
    }

    // The method deleteNameTag can be called only when status is INIT, TO_ADD or ADDED
    function deleteNameTag(address addr)
    public
    virtual
    whenNotPaused
    {
        STATUS status = nameTagMapping[addr].status;
        if(status == STATUS.TO_DELETE) {
            revert("AddressMetadata: name tag deletion request has been submitted, please wait for audit");
        }
        if(status == STATUS.INIT || status == STATUS.TO_ADD) {
            delete nameTagMapping[addr];
        } else{
            nameTagMapping[addr].status = STATUS.TO_DELETE;
        }
        emit NameTagDelete(_msgSender(), addr);
    }

    // The method auditNameTag can be called only when status is TO_ADD or TO_DELETE
    function auditNameTag(address addr, bool pass)
    public
    virtual
    whenNotPaused
    onlyAuditRole
    {
        require(nameTagMapping[addr].status == STATUS.TO_ADD || nameTagMapping[addr].status == STATUS.TO_DELETE,
            "AddressMetadata: name tag not need to be audit");
        if(nameTagMapping[addr].status == STATUS.TO_ADD) {
            if(pass) {
                nameTagMapping[addr].status = STATUS.ADDED;
                nameTagMapping[addr].auditTimestamp = block.timestamp;
                emit NameTagAdded(_msgSender(), addr);
            } // otherwise, user can add other name tag or delete it
        } else{
            if(pass) {
                delete nameTagMapping[addr];
                emit NameTagDeleted(_msgSender(), addr);
            } // otherwise, keep the name tag
        }
    }
}