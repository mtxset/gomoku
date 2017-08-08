pragma solidity ^0.4.13;

contract Gomoku
{
    address _owner;

    // Change this and Rome will crumble 
    uint8 _boardDim = 19; 
    uint8[19][19] _board;

    address _player1;
    address _player2;
    address _lastWinner;

    bool _openSlots = true;
    bool _gameInProgress = false;

    uint8 _playerTurn;
    uint _winner;

    function Gomoku()
    {
        _owner = msg.sender;
    }

    function GameState() public constant
    returns (string)
    {
        bytes[19] memory rows;
        
        for (uint8 i = 0; i < 19; i++)
        {
            rows[i] = new bytes(19);
        }
        
        byte[] memory signs = new byte[](3);
        signs[0] = "-";
        signs[1] = "X";
        signs[2] = "O";

        for (uint8 r = 0; r < 19; r++)
        {
            for (i = 0; i < 19; i++)
            {
                bytes(rows[r])[i] = signs[_board[r][i]];
            }
        }
        
        return strConcat(rows);
    }

    function strConcat(bytes[19] arg) internal 
    returns (string)
    {
        string memory str = new string(19*19);
        bytes memory supa = bytes(str);
        
        uint k = 0;
        for (uint i = 0; i < 19; i++)
        {
            for (uint m = 0; m < 19; m++)
            {
                supa[k++] = arg[i][m];
            }
        }

        return string(supa);
    }
}


