const Gomoku = artifacts.require("Gomoku")
import { expectThrow } from "./helpers/index"
import { expect } from "chai"

let player1, player2, thirdWheel;
let go = null;

contract("Gomoku", (accounts)=> {

    before(async()=>
    {
        go = await Gomoku.deployed()
        player1 = accounts[0];
        player2 = accounts[1];
        thirdWheel = accounts[2];
    });
    
    contract("Players joining", ()=>
    {
        it("2 Players should join ", async()=> 
        {

            await go.JoinGame({from: player1});
            expect(await go.Player1(), "Addresses should be equal").to.equal(player1);

            await go.JoinGame({from: player2});
            expect(await go.Player2(), "Addresses should be equal").to.equal(player2);
        });

        it("3 player should not be able to join", async() => 
        {
            await expectThrow(go.JoinGame({from:thirdWheel}));

            expect(await go.Player1(), "Addresses should be equal").to.equal(player1);
            expect(await go.Player2(), "Addresses should be equal").to.equal(player2);
        });
    })

    contract("Full Game Sequence", async()=>
    {
        it("Should play full game", async()=>
        {
            await go.JoinGame({from: player1})
            await go.JoinGame({from: player2})

            expect(await go.Player1(), "Addresses should be equal").to.equal(player1);
            expect(await go.Player2(), "Addresses should be equal").to.equal(player2);

            let gameState = await go.GameState()

            expect(gameState.length, "Length is incorrect").to.equal(361);

            // Make first move
            await go.MakeMove(1, 1, {from: player1})

            gameState = await go.GameState()

            expect(gameState[0]).to.equal("X");

            await go.MakeMove(2, 2, {from: player2})

            gameState = await go.GameState()

            //assert.equal(gameState[0], "O"); 

            await go.MakeMove(1, 2, {from: player1})
            await go.MakeMove(3, 3, {from: player2})

            await go.MakeMove(1, 3, {from: player1})
            await go.MakeMove(4, 4, {from: player2})

            await go.MakeMove(1, 4, {from: player1})
            await go.MakeMove(5, 5, {from: player2})

            expect(await go.GetLastWinnerAddress()).to.equal("0x0000000000000000000000000000000000000000");

            await go.MakeMove(1, 5, {from: player1})

            gameState = await go.GameState();

            expect(gameState).to.equal("Check Last Winner GetLastWinnerAddress, GG WP")
            
            // check for winner address
            expect(await go.GetLastWinnerAddress()).to.equal(player1);
        })
    })
  
})