// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract SacemEnPLS is ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Address for address payable;

    Counters.Counter private _tokenIds;

    struct CopyRight {
        bytes32 contentHash;
        string content;
        string title;
        string author;
        string url;
        string timeStamp;
    }

    mapping(uint256 => CopyRight) private _cprContent;
    mapping(uint256 => bool) private _isListed;
    mapping(bytes32 => uint256) private _cprId;
    mapping(uint256 => uint256) private _price;

    constructor() ERC721("Copyright", "CPR") {}

    function createCopyRight(CopyRight memory nft, address ownerAddress) public returns (uint256) {
        require(_cprId[nft.contentHash] == 0, "SacemEnPLS: sorry this content is already owned by someone");
        _tokenIds.increment();
        
        uint256 newItemId = _tokenIds.current();
        _mint(ownerAddress, newItemId);
        _cprContent[newItemId] = nft;
        _cprId[nft.contentHash] = newItemId;

        return newItemId;
    }
    
    function listNFT(address marketPlace, uint256 id, uint256 price_) public {
        approve(marketPlace, id);
        _price[id] = price_;
    }

    function getCPRById(uint256 id) public view returns (CopyRight memory) {
        return _cprContent[id];
    }

    function getCPRByHash(bytes32 contentHashed) public view returns (uint256) {
        return _cprId[contentHashed];
    }
    
    function getPrice(uint256 id) public view returns (uint256) {
        return (_price[id]);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }


    // Modifions _baseURI afin de retourner l'url de base
    // Cette fonction est utilis??e par tokenURI pour retourner une url compl??te.
    // En fonction de l'item id (et pas du NFT id), nous aurons une url pour chacun de nos loots
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "https://www.magnetgame.com/nft/";
    }


    // Il existe 2 d??finitions de supportsInterface, il faut aider le compilateur ?? g??rer ce conflit.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Il existe 2 d??finitions de _beforeTokenTransfer, il faut aider le compilateur ?? g??rer ce conflit.
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )  internal virtual override(ERC721Enumerable, ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Il existe 2 d??finitions de _burn il faut aider le compilateur ?? g??rer ce conflit.
    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }
}
