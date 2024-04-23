// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20


/*
* Designed and Developed by Jumbo Blockchain
*/
contract eSeal {

    struct FileState 
    {
        string name;
        string issuer;
        string certType;
        string fileHash;
        uint256 timestamp;
        address witness;
    }

    struct Issuer 
    {
        uint256 id;
        string name;
        address witness;
    }

    mapping(string => FileState) public files;
    mapping(uint256 => Issuer) public issuers;
    mapping(address => bool) private registeredIssuer;
    mapping(uint256 => address) public issuerWitness; // change: address -> uint

    string[] _issuersName;


    address private Contractowner;
    uint256 private IssuerID = 1;
 

    event Registration( string  name, string authority, string certType, string fileHash, address witness, uint256 timestamp);
    event IssuerRegistered(uint256 id, string name);
    event WitnessRegistered(uint256 issuerId, address witness);



    constructor ()
    {
        Contractowner =  msg.sender;
    }


    function registerIssuer( string memory _IssuerName, address _Witness)  external 
    { 
        require(issuers[IssuerID].id == 0, "Issuer already registered");
        issuers[IssuerID] = Issuer(IssuerID, _IssuerName, _Witness);
        registerWitness(IssuerID, _Witness);
        registeredIssuer[_Witness] = true;
        _issuersName.push(_IssuerName);
        emit IssuerRegistered(IssuerID, _IssuerName);
        IssuerID++;
    }


    function registerWitness(uint256 _issuerId, address _witness) internal 
    {  
        require(issuers[_issuerId].id > 0, "Issuer not registered");
        issuerWitness[_issuerId] = _witness;
        emit WitnessRegistered(_issuerId, _witness);
    }


    function registerFile(string memory _name, string memory _issuer, string memory _certType, string memory _fileHash) external 
    {
        files[_fileHash] = FileState({
            name: _name,
            issuer: _issuer,
            certType: _certType,
            fileHash: _fileHash,
            timestamp: block.timestamp,
            witness: msg.sender
        });

        emit Registration(_name, _issuer, _certType, _fileHash, msg.sender, block.timestamp);
    }


    function getFile(string memory _fileHash) external view returns (FileState memory) 
    {
        return files[_fileHash];
    }


}