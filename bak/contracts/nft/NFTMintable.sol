pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFTRole.sol";

abstract contract NFTMintable is NFTRole {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    Counters.Counter private _autoId;

    constructor() {
        _setupRole(MINTER_ROLE, _msgSender());
    }

    modifier onlyMinterRole() {
        require(hasRole(MINTER_ROLE, _msgSender()), "NFTMintable: MINTER_ROLE required");
        _;
    }

    function _mintAutoId(address to) private {
        _mint(to, _autoId.current());
        _autoId.increment();
    }

    function mint(address to) public onlyMinterRole {
        _mintAutoId(to);
    }

    function mintBatch(address to, uint256 count) public onlyMinterRole {
        for (uint256 i = 0; i < count; i++) {
            _mintAutoId(to);
        }
    }

    function mint(address to, uint256 tokenId) public onlyMinterRole {
        _mint(to, tokenId);
    }

    function mintBatch(address to, uint256[] memory tokenIds) public onlyMinterRole {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _mint(to, tokenIds[i]);
        }
    }

    function mintBatch(address to, uint256 tokenIdStart, uint256 count) public onlyMinterRole {
        uint256 tokenIdEnd = tokenIdStart + count;

        for (uint256 id = tokenIdStart; id < tokenIdEnd; id++) {
            _mint(to, id);
        }
    }

}