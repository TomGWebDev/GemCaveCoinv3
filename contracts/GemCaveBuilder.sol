//SPDX-License-Identifier: UNLICENSED

/*   _____                _____                   ______ _       
    |  __ \              /  __ \                  |  _  (_)      
    | |  \/ ___ _ __ ___ | /  \/ __ ___   _____   | | | |_  __ _ 
    | | __ / _ \ '_ ` _ \| |    / _` \ \ / / _ \  | | | | |/ _` |
    | |_\ \  __/ | | | | | \__/\ (_| |\ V /  __/  | |/ /| | (_| |
     \____/\___|_| |_| |_|\____/\__,_| \_/ \___|  |___/ |_|\__, |
                                                            __/ |
    NFT Attribute Builder Contract                         |___/ 
    Returns a randomly generated NFT attribute set for rendering.

    Developed by Tom G
    Website: https://example.invalid
*/
pragma solidity ^0.8.4;

contract GemCaveGemBuilder {

    function random(uint256 odds) private view returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(
        block.timestamp + block.difficulty +
        ((uint256(keccak256(abi.encodePacked(odds)))) / (block.timestamp)) +
        block.gaslimit + 
        ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
        block.number
        )));

        return ((seed - ((seed / 1000) * 1000)) % odds);
    }

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


    struct gemOptions {
        string[10] colorSet;
        string[10] colorSetV;
        string[7] shapeSet;
        string[5] conditionSet;
    }

    struct gemRolls {
        uint256 colorSetR;
        uint256 shapeSetR;
        uint256 conditionSetR;
    }

    function buildGem(uint256 points) public view returns(string memory, uint256[7] memory, string memory, string memory){
        gemOptions memory gemOptionsA;
        gemRolls memory gemRollsA;

        gemOptionsA.colorSet     = ['RUBY', 'EMERALD', 'SAPPHIRE', 'TOPAZ', 'DIAMOND', 'AMETHYST', 'ENCHANTED', 'ZIRCON', 'CITRINE', 'HELIODOR'];
        gemOptionsA.colorSetV    = ['#F62217', '#4ED012', '#2554C7', '#13BBAF', '#D1F8FA', '#9966CC', '#fff', '#ffbd66', '#ff8426', '#f6ff00'];
        gemOptionsA.shapeSet     = ['HEART', 'RADIENT', 'OVAL', 'ROUND', 'PRINCESS', 'TRILLION', 'MARQUISE'];
        gemOptionsA.conditionSet = ['CHIPPED', 'FLAWED', 'FLAWLESS', 'GILDED', 'PERFECT'];

        gemRollsA.colorSetR     = random(gemOptionsA.colorSet.length);
        gemRollsA.shapeSetR     = random(gemOptionsA.shapeSet.length);

        uint256 gemSize = (random(90) + 10);
        if (points > 1000000000000000000){
            gemSize = (random(130) + 10);
        }               
        if (points > 50000000000000000000){
            gemSize = (random(144) + 10);
        }
        
        gemRollsA.conditionSetR = random(gemOptionsA.conditionSet.length);
        if (gemSize < 50){
            gemRollsA.conditionSetR = random(2);
        }
        if (gemSize > 60){
            gemRollsA.conditionSetR = (random(2) + 2);
        }

        uint256 distortStre = 0;
        if (gemRollsA.conditionSetR == 0){
            distortStre = 20;
        }
        if (gemRollsA.conditionSetR == 1){
            distortStre = 6;
        }

        string memory gemSizeN = '';
        if (gemSize < 20) {
            gemSizeN = 'XS';
        }
        if (gemSize > 100) {
            gemSizeN = 'XL';
        }
        if (gemSize > 140) {
            gemSizeN = 'XXL';
        }


        /*
        RENDER CODE FORMAT:

        0 = Stone Seed
        1 = Distort Seed
        2 = Distort Strength
        3 = Colour
        4 = Weight
        5 = Condition
        6 = Shape

        */
        uint256 ran1 = random(999);
        uint256 ran2 = random(99);

        uint256[7] memory nftRenderCode = [ran1, ran2, distortStre, gemRollsA.colorSetR, gemSize, gemRollsA.conditionSetR, gemRollsA.shapeSetR];
        string memory nftRenderCodeS = string(abi.encodePacked(toString(gemRollsA.colorSetR), toString(gemSize), toString(gemRollsA.conditionSetR), toString(gemRollsA.shapeSetR)));

        string memory nftConfig1 = string(abi.encodePacked('{"trait_type" : "Type",      "value" : "', gemOptionsA.colorSet[gemRollsA.colorSetR], '" },{"trait_type" : "Cut",       "value" : "', gemOptionsA.shapeSet[gemRollsA.shapeSetR], '" },{"trait_type" : "Condition", "value" : "', gemOptionsA.conditionSet[gemRollsA.conditionSetR], '" },{"trait_type" : "Weight",    "value" : "', toString(gemSize), 'ct" }'));

        return (nftConfig1, nftRenderCode, nftRenderCodeS, string(abi.encodePacked(gemSizeN, ' ', gemOptionsA.conditionSet[gemRollsA.conditionSetR], ' ', gemOptionsA.shapeSet[gemRollsA.shapeSetR], ' ',gemOptionsA.colorSet[gemRollsA.colorSetR])));
    }

}