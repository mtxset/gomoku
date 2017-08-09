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

  
})