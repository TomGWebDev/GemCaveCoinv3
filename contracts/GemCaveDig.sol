//SPDX-License-Identifier: UNLICENSED
// Developed by Tom G

/*   _____                _____                   ______ _       
    |  __ \              /  __ \                  |  _  (_)      
    | |  \/ ___ _ __ ___ | /  \/ __ ___   _____   | | | |_  __ _ 
    | | __ / _ \ '_ ` _ \| |    / _` \ \ / / _ \  | | | | |/ _` |
    | |_\ \  __/ | | | | | \__/\ (_| |\ V /  __/  | |/ /| | (_| |
     \____/\___|_| |_| |_|\____/\__,_| \_/ \___|  |___/ |_|\__, |
                                                            __/ |
    NFT Factory                                            |___/ 
    The factory contract for the GemCave Dig NFT collection.

    Developed by Tom G
    Website: https://example.invalid
*/

pragma solidity ^0.8.4;

import "./token/ERC721/extensions/ERC721URIStorage.sol";
import "./token/ERC721/extensions/ERC721Enumerable.sol";
import "./access/Ownable.sol";
import "./utils/Base64.sol";

contract IGemCaveDigBuilder {
    function buildGem(uint256 points) public view returns (string memory, uint256[7] memory, string memory, string memory) {}
}
contract IGemCaveDigRender {
    function renderGem(uint256[7] memory renderCode, string memory gemTitle, string memory gemCode) public pure returns (string memory) {}
}
contract IGemCaveToken {
    function swapForMint(address account, uint256 amount) external returns (uint256) {}
}


contract GemCaveDig is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable {
    using Strings for uint256;

    mapping(uint256 => uint256[7]) private tokenRenderCode;
    mapping(uint256 => string) public tokenRenderCodeS;
    mapping(uint256 => string) public gemTitles;
    mapping(string => bool) private mintedRenderCodes;
    mapping(uint256 => string) private nftConfigs;

    address immutable dbBuilderAddress = address(0);
    address immutable dbRenderAddress = address(0);
    address immutable dTokenAddress = address(0);
    address feeRec = address(0);

    uint256 maxSupply = 5000;
    uint256 tokenCost = 50000000000000000000;
    string extURL = "https://example.invalid";
    string extraAttributes = "";
    event PermanentURI(string _value, uint256 indexed _id);

    constructor () ERC721('GemCave Dig', 'GemCaveDig') {}

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function changeMintCost(uint256 newCost) public virtual onlyOwner {
        tokenCost = newCost;
    }

    function changeFeeRec(address newRec) public virtual onlyOwner {
        feeRec = newRec;
    }

    function changeExtraAttributes(string memory newExtraAttributes) public virtual onlyOwner {
        extraAttributes = newExtraAttributes;
    }

    function changeExtURL(string memory newURL) public virtual onlyOwner {
        extURL = newURL;
    }

    // Return overall NFT contract info JSON Array
    function contractURI() public view returns (string memory) {
        string memory mainSVG = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500"><defs><filter id="a" width="1.5" height="1.5" x="-.3" y="-.3" ><feGaussianBlur result="result1" stdDeviation="4.9"/><feGaussianBlur in="result1" result="result6" stdDeviation="6.2"/><feComposite in="result6" in2="result1" operator="in" result="result8"/><feComposite in="result6" in2="result8" operator="xor" result="fbSourceGraphic"/><feColorMatrix in="fbSourceGraphic" result="fbSourceGraphicAlpha" type="saturate" values="0 0 0 -1 0 0 0 0 -1 0 0 0 0 -1 0 0 0 0 2 0"/><feGaussianBlur in="fbSourceGraphicAlpha" result="result0"/><feSpecularLighting in="result0" lighting-color="#fff" result="result1" specularConstant="1.9" specularExponent="23.8" surfaceScale="-2.7"><feDistantLight azimuth="207" elevation="60"/></feSpecularLighting><feComposite in="result1" in2="fbSourceGraphicAlpha" operator="in" result="result2"/><feComposite in="fbSourceGraphic" in2="result2" k2="1" k3="1" operator="arithmetic" result="result4"/><feComposite in2="result4" result="result91"/><feBlend in2="result91" mode="multiply"/></filter><filter id="b" ><feTurbulence baseFrequency="0.05239520958083832 0.010479041916167664" numOctaves="5" seed="10" type="fractalNoise"/><feColorMatrix result="result5" values="1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0.7 0"/><feComposite in="SourceGraphic" in2="result5" operator="out"/><feMorphology operator="dilate" radius="3.1" result="result3"/><feTurbulence baseFrequency="0.08 0.05" numOctaves="8" result="result91" seed="25"/><feDisplacementMap in="result3" in2="result91" result="result4" scale="9.3" xChannelSelector="R" yChannelSelector="G"/><feSpecularLighting in="result4" lighting-color="#fff" result="result1" specularExponent="35" surfaceScale="2"><feDistantLight azimuth="235" elevation="75"/></feSpecularLighting><feComposite in="result1" in2="result4" operator="in" result="result2"/><feComposite in="result4" in2="result2" k2="1" k3="1" operator="arithmetic" result="result4"/><feBlend in2="result4" mode="multiply"/></filter><filter id="c" width="1.1" height="1.1" x="0" y="0" ><feGaussianBlur stdDeviation="1.6"/></filter><filter id="e" width="1" height="1" x="0" y="0" ><feGaussianBlur stdDeviation=".9"/></filter><filter id="d" width="1.1" height="1.1" x="0" y="0" ><feGaussianBlur stdDeviation="1.3"/></filter></defs><path d="M249 309c-3.8 0-7.4-1.6-9.8-4.6l-115-141a13 13 0 0 1-.8-15.1l41.1-62.9c2.3-3.6 6.3-5.7 10.5-5.7h148c4.2 0 8.2 2.1 10.5 5.7l41.1 62.9a12.8 12.8 0 0 1-.8 15.1l-115 141c-2.4 3-6 4.6-9.7 4.6z" style="fill:#37c4b3" transform="translate(-111 -51.6)"/><path d="M279 157h97c.1-2.7-.5-5.5-2.1-7.9l-41.1-62.9a12.6 12.6 0 0 0-4.8-4.3zM169 81.8c-1.9 1-3.6 2.5-4.8 4.3l-41.1 63a12.5 12.5 0 0 0-2 7.8H218z" style="fill:#53e7d3" transform="translate(-111 -51.6)"/><path d="M248 76.5 298 229l50-152.5z" style="fill:#53e7d3" transform="translate(-160.7 28.8)"/><path d="m298 0-50 76.5h100z" style="fill:#b9f5ed" transform="translate(-160.7 28.8)"/><path d="M157 164a12.6 12.6 0 0 1-.8-15.1L197.3 86c2.3-3.6 6.2-5.7 10.5-5.7h-33.6c-4.2 0-8.2 2.1-10.5 5.7l-41.1 62.9a12.8 12.8 0 0 0 .8 15.1l115 141c2.4 3-81.5-141-81.5-141z" style="opacity:.1" transform="translate(-111 -51.6)"/><path d="M218 1.4h160l47.9 75.1-128 153-128-153z" style="fill:#fff;filter:url(#a);mix-blend-mode:overlay" transform="matrix(.975 0 0 .975 -153.3 31.6)"/><g style="filter:url(#b);stroke-width:1.71" transform="matrix(1.19 -.293 .293 1.19 -149 -41.9)"><path d="M184 436q-9.8 9.6-22.4 15.9-12.4 6.3-28 9.3-15.6 2.7-26.6 2.7-10.7 0-19.4-.8L75 440.9q0-13.4 23-65.5l-24.1 4.4q4.4-26.3 14.5-44.9 2.8-1.7 8.2-4.2 5.8-2.4 26.6-6.5 20.8-4.4 45.8-4.4l3.8 3q2.5 1.6 9 7.9 6.6 6.4 12.1 13.2 5.5 6.9 11 17.8 5.7 10.7 8.2 21.7-.8 6.3-5 16.4-3.8 10.1-9 18.4-4.9 7.9-15 17.8zm-12-62.2q-12.4-1.4-28.8-1.4-4.1 17.8-18.1 63.6 11.3-6.1 20.3-14.8 9-8.8 13.7-16.7 9.3-15.4 12.1-26.3zm64-50.8q18.9 5.2 51 8.5-12.3 45.8-19.2 82.2-6.8 36.2-7.7 49.9l-.8 13.4q-20.8-6.3-39.7-24.4 1.6-31.2 5.7-63.5 4.1-32.6 7.4-49.4zm91 147q-33.2-13.2-45-33.5 0-30.1 17.8-65.7t40-47.2q11.8 0 22 1.4 33.9-1.6 55.3-6.8l7.7-1.7q-11 36.2-17.6 77-11.2-4.9-23.8-14-12.6-9-20.5-18-23.1 32.6-27.5 70.7l36.2-9.6q.6-9.9 2.8-20.3 18.9 5.2 45.5 5.2-7.2 15.3-21.4 58.9l-5 14.5q-12.6-4.6-18.9-26.5Q354.9 465 327 470z" aria-label="DIG" style="stroke-width:1.71"/></g><path d="M130 302q-10-4-13.6-10.2 0-9.1 5.4-19.9t12.1-14.3q3.6 0 6.7.4 10.3-.5 16.8-2.1l2.3-.5q-3.3 11-5.3 23.4-3.4-1.5-7.2-4.3-3.9-2.7-6.3-5.5-7 9.9-8.3 21.5l11-2.9q.2-3 .8-6.2 5.8 1.6 13.8 1.6-2.1 4.7-6.5 17.9l-1.5 4.4q-3.8-1.4-5.7-8.1-6 3.3-14.5 4.8zm42-8 2.9.1q1.9 0 5.8-.9 3.9-1 6.5-2.2l2.5-1.2.1 1.6q0 3.2-2.8 6.4-3.7 4.1-12.2 5.9l-3.3-.6q-1.9-.4-6.2-2.6-4.2-2.1-6.4-5.1.4-5.3 2.2-10.9 2-5.6 3.6-8.5l1.7-2.9q4.6-.3 9.2-1.5 4.6-1.3 6.7-2.4l2.3-1.1q3.1 1.7 4.8 4.7 1.8 3 2.1 5.1l.3 2.2q-2.3 5.2-7.8 8t-11.5 3.3l-.5 2.6zm7.6-10.5q1.1-1.7 1.1-2.8t-.8-1.6q-.6-.7-1.6-.7t-1.9.2l-3 9q3.9-.6 6.2-4.1zM211 300q3.2-11.3 3.2-18l-.1-1-.2-1.8q-4.8 4.2-8.2 12.4l-.7 9.7-11.9-3q2.3-15.5 2.7-24.5l.2-3.3 12.2-2.8-2 11.9q3.1-5.3 7.4-7.8t8.1-2.5q2.4 3.5 3.2 9 2.7-4.2 6.1-6.9 3.3-2.6 5.7-2.6 4.9 0 9.6 11-1.5 2.6-3 9.2-1.6 6.4-1.9 12.8-8.5-1.1-12.1-4.5 2.8-10.3 2.8-15.8v-.8l-.1-1.5q-3.4 2.2-6.6 7.3-.8 3.7-1.8 12.4-3.7 1.2-10.3 1.2l-2.3-.1zm50 4q-10.1-4-13.7-10.1 0-9.2 5.4-20t12.2-14.3q2.8 0 6.3.4 9.2-.5 15.8-2l2.2-.5q-3.3 10.9-5.3 23.3-7.3-3.2-12.6-8.9-6.4 9.4-7.8 20.7l22.2-5.9q0 1.6-1.7 4.5-1.6 2.9-3.9 5t-7.4 4.4q-5 2.3-11.7 3.4zm58-18q0 7 1.6 12.2l-7.2 3.4q-5.2-1.3-6.3-6.9-2.2 2.5-4.8 4.3-2.6 1.7-4.4 1.7-3.9 0-7.1-3.5t-3.2-6.6q0-3.2 1.4-6.7 1.3-3.5 3.7-6.8t6.5-5.4 8-2.1 5.6 1.2l2.2-4.3q2.9 1.1 5.1 3 2.3 1.8 3.1 3.1l.8 1.4q-1.2 4.7-4.1 9.3l-.9 1.5v1.2zm-19.3 6.5q3.5 0 7.4-4.1 1-6.7 4.3-14.4-6.3 3.5-9.5 9.1-2.5 4.6-2.5 7.9l.1 1.5h.2zM343 266q-4.1 6.7-4.1 15.2l.1 3.9q.1 2.7 1.5 7.4 3-4.3 5-9.6 2-5.4 2.4-8.5l.5-3.2q2.4.3 5.6 1.9 3.3 1.5 4.9 3.4 0 1.3-.6 3.8t-1.5 4.6q-.9 1.9-2.8 4.6-1.9 2.6-4.5 4.7-2.5 2-6.6 3.9-4.1 1.7-9.2 2.5-3.2-3.3-5.1-7.3-1.8-4.1-2.3-7.5-.4-3.4-.4-5 0-4.8.5-6.8l.4-1.8 1.8-1.5q1.2-1 5.4-2.6 4.2-1.8 9-2.1zm29 28 2.8.1q2 0 5.9-.9 3.9-1 6.5-2.2l2.4-1.2.2 1.6q0 3.2-2.8 6.4-3.7 4.1-12.2 5.9l-3.3-.6q-1.9-.4-6.2-2.6-4.2-2.1-6.4-5.1.4-5.3 2.2-10.9 1.9-5.6 3.6-8.5l1.7-2.9q4.6-.3 9.2-1.5 4.6-1.3 6.7-2.4l2.3-1.1q3.1 1.7 4.8 4.7 1.8 3 2.1 5.1l.3 2.2q-2.3 5.2-7.8 8t-11.5 3.3l-.5 2.6zm7.6-10.5q1.1-1.7 1.1-2.8t-.8-1.6q-.6-.7-1.6-.7t-2 .2q-.5 2-2.9 9 3.9-.6 6.2-4.1z" aria-label="GemCave" style="fill:#1d7060;stroke-width:.52" transform="rotate(-15.1)"/><g style="filter:url(#c);opacity:.26" transform="matrix(.536 0 0 .621 138 97.2)"><path d="M236 122a6 6 0 0 1 0-5.1l37-87.6c1-2.6 3.7-4.6 6.5-5l36-4.9c2.1-.2 4 .6 4.8 2.2l31.2 54.9c.9 1.4.9 3.6-.2 5.6l-18.7 35.3c-1.3 2.6-4.4 4.6-6.9 4.6l-85.7 2c-1.9 0-3.2-.6-4-2z" style="fill:#7d7d7d;stroke-width:.5"/><path d="m309 84.5 20.5 36a8.5 8.5 0 0 0 3.1-3.4l18.7-35.3c.5-1 .8-2 .8-3zm10-64.9c-.7-.4-1.7-.6-2.8-.5l-36 4.9c-1.5 0-2.9.8-3.9 1.8l20.4 35.8z" style="fill:#9d9d9d;stroke-width:.5"/><path d="M348 76.5H248L298 229z" style="fill:#9d9d9d" transform="matrix(.211 .371 -.436 .318 273 -61.8)"/><path d="m298 0-50 76.5h100L298 0z" style="fill:#d7d7d7" transform="matrix(.211 .371 -.436 .318 273 -61.8)"/><path d="M280 41.5c1-2.6 3.7-4.7 6.3-5l36.2-4.9c2.1-.2 3.9.5 4.6 2.1l-6.9-12.5c-.8-1.6-2.7-2.4-4.8-2.1l-36 4.8a8.3 8.3 0 0 0-6.5 5l-37 87.6a9284 9284 0 0 0 44.1-75z" style="opacity:.1;stroke-width:.5"/></g><g style="filter:url(#d)" transform="matrix(-.382 -.625 .625 -.382 -94.6 416)"><g><path d="M236 122a6 6 0 0 1 0-5.1l37-87.6c1-2.6 3.7-4.6 6.5-5l36-4.9c2.1-.2 4 .6 4.8 2.2l31.2 54.9c.9 1.4.9 3.6-.2 5.6l-18.7 35.3c-1.3 2.6-4.4 4.6-6.9 4.6l-85.7 2c-1.9 0-3.2-.6-4-2z" style="fill:#7d7d7d;stroke-width:.5" transform="matrix(.734 0 0 .85 -144 218)"/><path d="m309 84.5 20.5 36a8.5 8.5 0 0 0 3.1-3.4l18.7-35.3c.5-1 .8-2 .8-3zm10-64.9c-.7-.4-1.7-.6-2.8-.5l-36 4.9c-1.5 0-2.9.8-3.9 1.8l20.4 35.8z" style="fill:#9d9d9d;stroke-width:.5" transform="matrix(.734 0 0 .85 -144 218)"/><path d="M248 76.5 298 229l50-152.5z" style="fill:#9d9d9d" transform="matrix(.155 .315 -.32 .27 56.4 165.5)"/><path d="M248 76.5h100L298 0z" style="fill:#d7d7d7" transform="matrix(.155 .315 -.32 .27 56.4 165.5)"/><path d="M280 41.5c1-2.6 3.7-4.7 6.3-5l36.2-4.9c2.1-.2 3.9.5 4.6 2.1l-6.9-12.5c-.8-1.6-2.7-2.4-4.8-2.1l-36 4.8a8.3 8.3 0 0 0-6.5 5l-37 87.6a9284 9284 0 0 0 44.1-75z" style="opacity:.1;stroke-width:.5" transform="matrix(.734 0 0 .85 -144 218)"/></g></g><g style="filter:url(#e);opacity:.7" transform="matrix(.87 0 0 1.01 162 17.1)"><path d="M236 122a6 6 0 0 1 0-5.1l37-87.6c1-2.6 3.7-4.6 6.5-5l36-4.9c2.1-.2 4 .6 4.8 2.2l31.2 54.9c.9 1.4.9 3.6-.2 5.6l-18.7 35.3c-1.3 2.6-4.4 4.6-6.9 4.6l-85.7 2c-1.9 0-3.2-.6-4-2z" style="fill:#7d7d7d;stroke-width:.5" transform="matrix(1.21 -.47 .91 .839 -156 135)"/><path d="m309 84.5 20.5 36a8.5 8.5 0 0 0 3.1-3.4l18.7-35.3c.5-1 .8-2 .8-3zm10-64.9c-.7-.4-1.7-.6-2.8-.5l-36 4.9c-1.5 0-2.9.8-3.9 1.8l20.4 35.8z" style="fill:#9d9d9d;stroke-width:.5" transform="matrix(1.21 -.47 .91 .839 -156 135)"/><path d="M248 76.5 298 229l50-152.5z" style="fill:#9d9d9d" transform="matrix(.593 .212 -.238 .472 118 -45.2)"/><path d="M348 76.5 298 0l-50 76.5z" style="fill:#d7d7d7" transform="matrix(.593 .212 -.238 .472 118 -45.2)"/><path d="M280 41.5c1-2.6 3.7-4.7 6.3-5l36.2-4.9c2.1-.2 3.9.5 4.6 2.1l-6.9-12.5c-.8-1.6-2.7-2.4-4.8-2.1l-36 4.8a8.3 8.3 0 0 0-6.5 5l-37 87.6a9284 9284 0 0 0 44.1-75z" style="opacity:.1;stroke-width:.5" transform="matrix(1.21 -.47 .91 .839 -156 135)"/></g></svg>';

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                           '{"name" : "GemCave Dig",',
                           ' "description" : "GemCave Dig is an NFT collectible of unique gems that are generated, minted, stored and rendered entirely on-chain (no IPFS). Own your first real on-chain NFT today with GemCave tech.",',
                           ' "external_link" : "', extURL, '",',
                           extraAttributes,
                           ' "seller_fee_basis_points" : "100",',
                           ' "fee_recipient" : "', feeRec ,'",',
                           ' "image" : "data:image/svg+xml;base64,', Base64.encode(bytes(mainSVG)), '"}'
                        )
                    )
                )
            )
        );
    }

    // Return specific NFT info JSON Array
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        IGemCaveDigRender dbRender;
        dbRender = IGemCaveDigRender(dbRenderAddress);

        string memory description = string(abi.encodePacked("This gem was dug out during a GemCave Dig mining operation. I am a GemCave Dig NFT - generated, minted, stored and rendered 100% on-chain forever!"));
       
        // Render the SVG from the render code
        string memory gemSVG = dbRender.renderGem(tokenRenderCode[tokenId], gemTitles[tokenId], tokenRenderCodeS[tokenId]);

        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                           '{"name" : "', gemTitles[tokenId], '",',
                           ' "description" : "', description, '",',
                           ' "external_url" : "', extURL, toString(tokenId), '",',
                           ' "attributes" : [', nftConfigs[tokenId], '],',
                           ' "image" : "data:image/svg+xml;base64,', Base64.encode(bytes(gemSVG)), '"}'
                        )
                    )
                )
            )
        );
    }

    // Mint a new NFT
    function mint() public {
        uint256 tSupply = totalSupply();
        require(tSupply <= maxSupply, "SOLD OUT FOREVER - There are no more GemCave Dig NFTs left, check out our next collection at https://example.invalid");

        IGemCaveToken dToken;
        dToken = IGemCaveToken(dTokenAddress);

        // Call function on GemCave Token contract to deduct the tokens from wallet - fail if no balance
        uint256 points = dToken.swapForMint(_msgSender(), tokenCost);

        IGemCaveDigBuilder dbBuilder;
        dbBuilder = IGemCaveDigBuilder(dbBuilderAddress);
        
        bool foundNewGem = false;
        string memory nftConfig;
        uint256[7] memory gemRenderCode;
        string memory gemRenderCodeS;
        string memory gemTitle;

        // Loop until a new unique render code is generated
        while (!foundNewGem) {
            (nftConfig, gemRenderCode, gemRenderCodeS, gemTitle) = dbBuilder.buildGem(points);

            if (mintedRenderCodes[gemRenderCodeS] == false){
                foundNewGem = true;
                mintedRenderCodes[gemRenderCodeS] = true;
            }
        }

        uint256 theId = tSupply + 1;

        // Save NFT data
        gemTitles[theId] = gemTitle;
        tokenRenderCodeS[theId] = gemRenderCodeS;
        tokenRenderCode[theId] = gemRenderCode;
        nftConfigs[theId] = nftConfig;

        _mint(_msgSender(), theId);
    }

    // Return only the SVG data for a specific token ID
    function tokenSVG(uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        IGemCaveDigRender dbRender;
        dbRender = IGemCaveDigRender(dbRenderAddress);

        return string(dbRender.renderGem(tokenRenderCode[tokenId], gemTitles[tokenId], tokenRenderCodeS[tokenId]));
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        _burn(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    
}