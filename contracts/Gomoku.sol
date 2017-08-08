pragma solidity ^0.4.13;

contract Gomoku
{
    address _owner;

    // Change this and Rome will crumble 
    int _boardDim = 19; 
    uint8[19][19] _board;

    address _player1;
    address _player2;
    address _lastWinner;

    bool _openSlots = true;
    bool _gameInProgress = false;

    uint8 _playerTurn;
    uint8 _winner;

    function Gomoku()
    {
        _owner = msg.sender;
    }
    
    function Disconnect() public
    {
        if (_player1 == msg.sender)
        {
            delete _player1;
            EndGame();
        }
            

        if (_player2 == msg.sender)
        {
            delete _player2;
            EndGame();
        }
    }
    
    function JoinGame() public
    CheckForOpenSlots
    CheckIfNoGames
    CheckIfUniquePlayer
    CheckIf2PlayersConnected
    {
        if (!FillSlot(msg.sender))
            revert();
    }

    function FillSlot(address joiningPlayer) internal
    returns (bool)
    {
        if (_player1 == 0)
        {
            _player1 = joiningPlayer;
            return true;
        }
        
        if (_player2 == 0)
        {
            _player2 = joiningPlayer;
            return true;
        }

        return false;
    }

    function StartGame() private
    {
        _openSlots = false;
        _gameInProgress = true;

        _playerTurn = 1;
    }

    function EndGame() private
    {
        _openSlots = true;
        _gameInProgress = false;

        _lastWinner = GetWinnerAddress();
        delete _player1;
        delete _player2;

        _playerTurn = 0;
    }

    function MakeMove(uint8 Row, uint8 Column) public
    CheckIfPlayersTurn
    CheckIfLegalMove(Row, Column)
    {
        _board[Row - 1][Column - 1] = _playerTurn;

        _winner = LookForWinner();

        if (_winner != 0)
        {
            EndGame();
            return;
        }

        TogglePlayerTurn();
    }

    function TogglePlayerTurn() internal
    {
        if (_playerTurn == 1) { _playerTurn = 2; return; }
        
        if (_playerTurn == 2) { _playerTurn = 1; return; }
    }

    function LookForWinner() internal
    returns (uint8)
    {
        uint8 r; uint8 c;

        for (r = 0; r < _boardDim; r++)
        {
            for (c = 0; c < _boardDim; c++)
            {
                uint8 player = _board[r][c];
                if (player != 0)
                {
                    if (r < _boardDim - 4)
                        if (CheckIfFive(r, c, 1, 0)) return player;

                    if (c < _boardDim - 4)
                    {
                        if (CheckIfFive(r, c, 0, 1)) return player;

                        if (r < _boardDim - 4)
                            if (CheckIfFive(r, c, 1, 1)) return player;
                    }    

                    if (c > 3 && r < _boardDim - 4)
                        if (CheckIfFive(r, c, 1, -1)) return player;
                }
            }
        }
    }

    function CheckIfFive(uint row, uint col, int rowDir, int colDir) internal
    returns (bool)
    {
        uint8 player = _board[row][col];

        for (int i = 1; i < 5; i++)
        {
            if (_board
                [uint(int(row) + rowDir*i)]
                [uint(int(col) + colDir*i)] != player) 
                return false;
        }

        return true;
    }

    function GetLastWinner() public constant
    returns (uint8)
    {
        return _winner;
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

    modifier CheckIfLegalMove(uint8 row, uint8 col)
    {
        require(row > 0 && col > 0);
        require(row <= 19 && col <= 19);

        require(_board[row - 1][ col - 1] == 0);
        _;
    } 

    modifier CheckIfUniquePlayer()
    {
        // DEBUG MODE: allow same sender
        //if (_player1 == msg.sender || _player2 == msg.sender)
          //  revert();

        _;
    }

    modifier CheckIfPlayersTurn()
    {
        if ((_playerTurn == 1 && msg.sender == _player1) 
        || (_playerTurn == 2 && msg.sender == _player2))
        _;
        else
            revert();
    }

    modifier CheckIf2PlayersConnected()
    {
        _;
        if (_player1 != 0 && _player2 != 0)
        {
            StartGame();
        }
    }

    modifier CheckIfNoGames()
    {
        require(!_gameInProgress);
        _;
    }

    modifier CheckForOpenSlots()
    {
        require(_openSlots);
        _;
    }

    function GetLastWinnerAddress() public constant
    returns (address)
    {
        return _lastWinner;
    }

    function GetWinnerAddress() private 
    returns (address)
    {
        if (_winner == 1)
            return _player1;
        else if (_winner == 2)
            return _player2;

        return 0x0;
    }

    function Player1() public constant
    returns (address)
    { return _player1; }
    
    function Player2() public constant
    returns (address)
    { return _player2; }

    function WaitingForPlayersMove() public constant
    returns (address)
    { 
        if (_playerTurn == 0)
            return 0x0;
        else if (_playerTurn == 1)
        {
            return _player1;
        }
        else if (_playerTurn == 2)
        {
            return _player2;
        }
    }

    function CanIJoin() public constant
    returns (bool)
    { return _openSlots; }
}


