# = ADVENTURECASTER =

This is an information repo for the game on-chain adventure game, Adventurecaster. The game can only be played in an 
embedded Farcaster Frame, and runs on the Base L2 network. The url for this Frame is 
 [https://adventurecaster.netlify.app/api/](https://adventurecaster.netlify.app/api/)

 Paste this link into a Farcaster post to view and play the game, it can also be played by viewing it in other people's 
  posts.

### Background

  Long story short, I only found out about Farcaster and Frames last week, so decided to make this game as a way of 
   learning how they work.

  This game is a remake of a project I made about 6 years on Ethereum called 
   [Adventureum](https://anallergytoanalogy.github.io/blockchain-adventure/). In this game, players click through a 
    choose-your-own adventure game where the story is all stored on-chain. When they reach a point where no story has 
     been added, they are able to add the story themselves by submitting a transaction to save it to the blockchain.
  
   However, there are a number of constraints that the Farcaster Frame specification introduces which make the original 
   game unsuitable for direct porting.

 These constraints are:

- Visuals are limited to a single image per frame. Meaning an entire story block must be small enough to fit on one, 
   relatively small image, which can not be an SVG.
- The Frame spec only allows a maximum of 4 buttons on any frame. Meaning that for the inclusion of a "Back" button, 
   story blocks can only have a maximum of 3 options.
- The input field that can be added to a Farcaster frame only accepts a maximum of 256 bytes as input, so the story 
   creation system must account for this.

### Dumb Contracts

   The story data is stored on-chain in dumb-contract style, that is to say that it is stored in Event data. The 
    navigational data that links different story elements together is stored properly on chain for the purposes of
     validating user transactions, however the text itself is retrieved just by reading event data on the contracts.
      
   This is because there is no benefit to having it readable on-chain, and it saves on gas consumption.
   
### No Pay to Play Costs

   There is no fee for playing, and no fee for contributing to the story other than the small gas fee of the 
    transactions. This is an intentional decision, as any payout mechanism would instantly taint the incentives that 
     any would-be-writers would have, and inevitably lead to the game being exploited for whatever small gains that can 
      be extracted.
   
   I believe that the small group of people who may want to make meaningful contributions to a story game like this 
    will do it regardless of whether there is money changing hands.

### Follow me for more

   If you like what you see here, you can catch me on any of the following. I have a pretty major project release 
    coming up soon which I think I'll be launching on Base as well.
   - [GitHub](https://github.com/AnAllergyToAnalogy)
   - [Twitter](https://twitter.com/cashtagyolo)
   - [Farcaster](https://warpcast.com/allergy)
   - [Discord Server](https://discord.gg/yNQK7VNesX)

  I also do contracting as a full stack Solidity dev. Hire me to build cool shit for you.