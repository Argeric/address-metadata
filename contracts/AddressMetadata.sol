pragma solidity ^0.8.4;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@confluxfans/contracts/InternalContracts/InternalContractsHandler.sol";

import "./MetadataRole.sol";
import "./Roles.sol";

contract AddressMetadata is
MetadataRole,
Initializable,
InternalContractsHandler
{
    mapping (address => NameTag)  public nameTagMapping;
    mapping (address => Labels) public labelsMapping;

    struct NameTag {
        string name;
        string website;
        uint256 auditTime;
    }
    struct Labels {
        string[] labelArray;
        uint256 auditTime;
    }

    modifier onlyAuditRole() {
        require(hasRole(Roles.AUDIT_ROLE, _msgSender()), "AddressMetadata: AUDIT_ROLE required");
        _;
    }

    event NameTagChanged(address indexed auditor, address indexed addr, string nameTag, string website);
    event LabelAdded(address indexed auditor, address indexed addr, string label);
    event LabelUpdated(address indexed auditor, address indexed addr, string oldLabel, string newLabel);
    event LabelDeleted(address indexed auditor, address indexed addr, string label);

    constructor() {
        _disableInitializers();
    }

    function initialize(string memory adminName) public initializer {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender(), adminName);
        _setupRole(Roles.AUDIT_ROLE, _msgSender(), adminName);
    }

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
        string[] storage labels = labelsMapping[addr].labelArray;
        (bool isExist,) = findLabel(labels, label);
        require(!isExist, "AddressMetadata: label to add exists already");

        labels.push(label);
        emit LabelAdded(_msgSender(), addr, label);
    }

    function updateLabel(address addr, string memory oldLabel, string memory newLabel)
    public
    virtual
    onlyAuditRole
    {
        string[] storage labels = labelsMapping[addr].labelArray;
        (bool isExist, uint index) = findLabel(labels, oldLabel);
        require(isExist, "AddressMetadata: label to update not exists");

        labels[index] = newLabel;
        emit LabelUpdated(_msgSender(), addr, oldLabel, newLabel);
    }

    function deleteLabel(address addr, string memory label)
    public
    virtual
    onlyAuditRole
    {
        string[] storage labels = labelsMapping[addr].labelArray;
        (bool isExist, uint index) = findLabel(labels, label);
        require(isExist, "AddressMetadata: label to delete not exists");

        labels[index] = labels[labels.length - 1];
        labels.pop();
        emit LabelDeleted(_msgSender(), addr, label);
    }

    function findLabel(string[] memory labels, string memory label) internal view virtual returns(bool, uint){
        for(uint i=0; i< labels.length; i++) {
            string memory l = labels[i];
            if(keccak256(abi.encodePacked(label)) == keccak256(abi.encodePacked(l))) {
                return (true, i);
            }
        }
        return (false, 0);
    }
}
