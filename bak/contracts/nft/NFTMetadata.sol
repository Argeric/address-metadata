pragma solidity ^0.8.0;

import "./NFTRole.sol";

abstract contract NFTMetadata is NFTRole {

    bytes32 public constant METADATA_ROLE = keccak256("METADATA_ROLE");

    string private _tokenPlaceholderURI;
    mapping (uint256 => mapping (string => string)) _tokenAttributes;

    constructor(string memory tokenPlaceholderURI) {
        _tokenPlaceholderURI = tokenPlaceholderURI;

        _setupRole(METADATA_ROLE, _msgSender());
    }

    modifier onlyMetadataRole() {
        require(hasRole(METADATA_ROLE, _msgSender()), "NFTMetadata: METADATA_ROLE required");
        _;
    }

    // Token URI management

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "NFTMetadata: URI query for nonexistent token");
        return _tokenPlaceholderURI;
    }

    function setTokenPlaceholderURI(string memory tokenPlaceholderURI) public onlyMetadataRole {
        _tokenPlaceholderURI = tokenPlaceholderURI;
    }

    // Token attribute management

    function getTokenAttribute(uint256 tokenId, string memory attributeName) public view returns (string memory) {
        return _tokenAttributes[tokenId][attributeName];
    }

    function getTokenAttributes(uint256 tokenId, string[] memory attributeNames) public view returns (string[] memory) {
        string[] memory values = new string[](attributeNames.length);

        for (uint256 i = 0; i < attributeNames.length; i++) {
            values[i] = _tokenAttributes[tokenId][attributeNames[i]];
        }

        return values;
    }

    function setTokenAttribute(uint256 tokenId, string memory attributeName, string memory attributeValue) public onlyMetadataRole {
        _tokenAttributes[tokenId][attributeName] = attributeValue;
    }

    function setTokenAttributes(uint256 tokenId, string[] memory attributeNames, string[] memory attributeValues) public onlyMetadataRole {
        require(attributeNames.length == attributeValues.length, "NFTMetadata: length mismatch of attributeNames and attributeValues");

        for (uint256 i = 0; i < attributeNames.length; i++) {
            _tokenAttributes[tokenId][attributeNames[i]] = attributeValues[i];
        }
    }

}