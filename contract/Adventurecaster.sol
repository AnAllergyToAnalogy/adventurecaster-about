// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

//Re-make of my 2019 Project Adventureum remade for Farcaster Frames
// Original project: https://github.com/AnAllergyToAnalogy/blockchain-adventure/
//  Also made a few other changes to efficiency etc with the benefit of 6 years experience working in this field, and
//   taking advantage of some of the improvements to Solidity since then.

contract Adventurecaster{
    event Story(uint indexed id, string[] paragraphs, string[] choiceTexts, uint32 fromStoryBlock, uint8 fromChoice, address author);
    event Signature(address indexed writer, string signature);

    struct StoryBlock{
        uint32 id;
        uint32 block;
        uint32 parent;
        address author;
        uint32[] children;
    }
    uint32 storyBlockId;

    uint constant CHOICE_COUNT_MAX = 3;
    uint constant CHOICE_LENGTH_MAX = 48;
    uint constant PARAGRAPH_COUNT_MAX = 2;
    uint constant PARAGRAPH_LENGTH_MAX = 256;
    uint constant SIGNATURE_LENGTH_MAX = 32;


    mapping(uint32 => StoryBlock) storyBlocks;
    mapping(address => string) public signatures;

    uint public firstBlock;
    constructor(string[] memory paragraphs, string[] memory choiceTexts){
        firstBlock = block.number;

        //Validate text
        _validateStoryText(paragraphs,choiceTexts);

        require(choiceTexts.length > 0,"no choices");


        //Add initial story block
        ++storyBlockId;
        storyBlocks[storyBlockId] = StoryBlock(
            storyBlockId,
            uint32(block.number),
            0,
            msg.sender,
            new uint32[](choiceTexts.length)
        );

        emit Story(storyBlockId, paragraphs, choiceTexts, 0, 0, msg.sender);

    }

    function strlen(string memory s) internal pure returns (uint256) {
        uint256 len;
        uint256 i = 0;
        uint256 bytelength = bytes(s).length;        for (len = 0; i < bytelength; len++) {
        bytes1 b = bytes(s)[i];
        if (b < 0x80) {
            i += 1;
        } else if (b < 0xE0) {
            i += 2;
        } else if (b < 0xF0) {
            i += 3;
        } else if (b < 0xF8) {
            i += 4;
        } else if (b < 0xFC) {
            i += 5;
        } else {
            i += 6;
        }
    }
        return len;
    }

    function _validateStoryText(string[] memory paragraphs, string[] memory choiceTexts) private pure{
        //Make sure they've provided at least one paragraph
        require(paragraphs.length > 0,"no paragraphs");

        //Make sure they've provided no more than 2 paragraphs
        require(paragraphs.length <= PARAGRAPH_COUNT_MAX,"paragraph limit");

        //Make sure each paragraph isn't empty and is below limit
        for(uint i = 0; i < paragraphs.length; i++){
            require(strlen(paragraphs[i]) > 0,"paragraph empty");
            require(strlen(paragraphs[i]) <= PARAGRAPH_LENGTH_MAX,"paragraph length max");
        }

        //Make sure they aren't adding more than 3 options. This is for Farcaster frame limitations.
        require(choiceTexts.length <= CHOICE_COUNT_MAX, "option limit");

        //Make sure none of the options contain empty text, and that they aren't too long
        for(uint i = 0; i < choiceTexts.length; i++){
            require(strlen(choiceTexts[i]) > 0,"choice empty");
            require(strlen(choiceTexts[i]) <= CHOICE_LENGTH_MAX,"choice length max");
        }
    }




    function write(
        uint32 fromStoryBlock,
        uint8 fromChoice,
        string[] memory paragraphs,
        string[] memory choiceTexts
    ) public {

        //Validate text
        _validateStoryText(paragraphs,choiceTexts);


        //Make sure parent exists
        require(storyBlocks[fromStoryBlock].id != 0,"no parent");

        //Make sure it is branching from an existing option
        require(fromChoice < storyBlocks[fromStoryBlock].children.length,"no option");

        //Make sure this option has not already been defined
        require(storyBlocks[fromStoryBlock].children[fromChoice] == 0,"option taken");

        //Add story block
        ++storyBlockId;
        storyBlocks[storyBlockId] = StoryBlock(
            storyBlockId,
            uint32(block.number),
            fromStoryBlock,
            msg.sender,
            new uint32[](choiceTexts.length)
        );

        //Register this storyBlockId as the relevant child
        storyBlocks[fromStoryBlock].children[fromChoice] = storyBlockId;

        //Emit the story text so it can be retrieved by the frontend
        emit Story(storyBlockId, paragraphs, choiceTexts, fromStoryBlock, fromChoice, msg.sender);

    }

    function getStoryBlock(uint32 _id) public view returns(
        uint32 id,
        uint32 blockNumber,
        uint32 parent,
        address author,
        string memory signature,
        uint32[] memory children
    ){
        return (
        storyBlocks[_id].id,
        storyBlocks[_id].block,
        storyBlocks[_id].parent,
        storyBlocks[_id].author,
        signatures[storyBlocks[_id].author],
        storyBlocks[_id].children
        );
    }

    function sign(string memory signature) public{
        signatures[msg.sender] = signature;
        require(strlen(signature) > 0,"no signature");
        require(strlen(signature) <= SIGNATURE_LENGTH_MAX,"too long");

        emit Signature(msg.sender,signature);
    }

}