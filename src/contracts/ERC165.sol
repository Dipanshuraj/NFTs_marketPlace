// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import './interfaces/IERC165.sol';
 contract ERC165 is IERC165{

     mapping (bytes4 =>bool) private _supportedInterface;

     constructor(){
        _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
    }
     
function supportsInterface(bytes4 interfaceID) external view returns (bool){
    return _supportedInterface[interfaceID];
}

function _registerInterface(bytes4 interfaceId)public {
        require(interfaceId != 0xffffffff,'ERC165: invlid interface');
        _supportedInterface[interfaceId]=true;
    }

 }