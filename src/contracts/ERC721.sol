// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


import './ERC165.sol';

import './interfaces/IERC721.sol';

contract ERC721 is ERC165,IERC721{
 
// mapping from token id to the owner.
mapping (uint256 => address) private _tokenOwner;

//mapping from address to number of owned tokens.
mapping (address => uint256) private _ownedTokensCount;

//mapping from token Id to approved addresses
mapping(uint256 => address) private _tokenApprovals;



     constructor(){
        _registerInterface(bytes4(keccak256('ownerof(bytes4)')^keccak256('balanceOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
            require(_to != address(0),'Error - ERC721 transfer to zero address');
            require(ownerOf(_tokenId)==_from,'Trying to transfer token the address does not have');
            _ownedTokensCount[_from]-=1;
            _ownedTokensCount[_to]+=1;
            _tokenOwner[_tokenId]=_to;
            emit Transfer(_from,_to, _tokenId);


}


function transferFrom(address _from, address _to, uint256 _tokenId) public override {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _transferFrom(_from, _to, _tokenId);
}

function balanceOf(address _owner) public override view returns(uint256){
    require(_owner != address(0),'Owner query for non-existent token');
    return _ownedTokensCount[_owner];
}

function ownerOf(uint256 _tokenId) public override view returns (address){
        address owner=_tokenOwner[_tokenId];
        require(owner != address(0),'Owner query for non-existent token');
        return owner;
}

function _exists (uint256 tokenId) internal view returns(bool){

    address owner = _tokenOwner[tokenId];
    //returns tuthiness that address is not zero 
    return owner != address(0);

}

function _mint(address to,uint256 tokenId) internal virtual {
    require(to !=address(0),'ERC721: minting to the zero address' );
    require(!_exists(tokenId),'ERC721: token already minted');
    _tokenOwner[tokenId]=to;
    _ownedTokensCount[to]+=1;
    emit Transfer(address(0), to, tokenId);

}

// 1. require that the person approving is the owner
    // 2. we are approving an address to a token (tokenId)
    // 3. require that we cant approve sending tokens of the owner to the owner (current caller)
    // 4. update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    } 

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner); 
    }
 

}