// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Distribute is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _count;
    bytes32 public merkleRoot;
    address public currency;
    address public DAO;
    uint256 public round;

    struct member {
        uint256 amt;
        uint256 round;
    }

    mapping(address => member) public claimed;

    constructor(
        address _currency,
        bytes32 _initRoot,
        address _dao
    ) {
        _transferOwnership(_dao);
        merkleRoot = _initRoot;
        currency = _currency;
        DAO = _dao;
    }

    function updateCurrency(address _newCurrency) public onlyOwner {
        currency = _newCurrency;
    }

    function updateDAO(address _newDAO) public onlyOwner {
        DAO = _newDAO;
    }

    // every new issuance of currancy, a new root can be provided
    function updateRoot(bytes32 _root) public onlyOwner {
        merkleRoot = _root;
        round++;
    }

    function claim(uint256 _amt, bytes32[] calldata merkleProof) public {
        require(_claimConditions(), "claim condition not met");
        require(claimed[msg.sender].round <= round, "must not have claimed for this round");
        claimed[msg.sender].amt += _amt;
        claimed[msg.sender].round = round + 1;
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _amt));
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf) == true, "invalid merkle proof");
        IERC20(currency).transferFrom(address(this), msg.sender, _amt);
    }

    function _claimConditions() internal returns (bool){
        // create you're own additional conditions, e.g. NFT membership
        return true;
    }
}
