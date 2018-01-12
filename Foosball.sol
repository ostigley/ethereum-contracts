pragma solidity ^0.4.4;

contract Foosball {

  address BoostAdmin;
  uint public gameCount;
  mapping ( address => Player ) Players;   // this allows to look up Players by their ethereum address
  address[] public playersByAddress; // this is like a whitepages of all players, by ethereum address

  mapping ( uint => Game ) Games;  // this allows to look up Games by their id's
  uint[] public gamesById;  // this is like a whitepages of all games, by game Id

  // Define structure of Player instance
  struct Player {
    string name;
    uint[] games;
  }

  // Define structure of Game instance
  struct Game {
    address winner;
    address loser;
  }

  // constructor for this contract
  function Foosball () payable {
    BoostAdmin = msg.sender;
    gameCount = 0;
  }

  // new player
  function newPlayer(string name) public returns (bool success) {
    address newPlayerAddress = msg.sender;
    if (bytes(name).length > 0) {
      Players[newPlayerAddress].name = name;
      playersByAddress.push(newPlayerAddress);
      return true;
    }
    return false;
  }

  // new game
  function newGame(address winner, address loser) public returns (bool success) {
    Games[ gameCount ].winner = winner;
    Games[ gameCount ].loser = loser;
    Players[winner].games.push(gameCount);
    Players[loser].games.push(gameCount);
    gamesById.push(gameCount);
    gameCount = gameCount + 1;
    return true;
  }

  // get all players
  function getPlayers() constant public returns (address[]) { return playersByAddress;}

  // get a player
  function getPlayer(address playerAddress) constant public returns (string, uint[]) {
    return (Players[playerAddress].name, Players[playerAddress].games);
  }

  // get a game
  function getGame(uint gameId) constant public returns (uint, address, address) {
    return (gameId, Games[gameId].winner, Games[gameId].loser);
  }

}