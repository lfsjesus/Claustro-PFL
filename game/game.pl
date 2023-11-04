:- use_module(library(random)).

gameInit(N, M, P1-P2) :- 
    initial_state(N, M, GameState),
    printList(GameState),
    gameLoop(GameState, P1, P1-P2, N, M).

initial_state(N, M, (1, MoveHistory, Board)) :-
    setBoard(N, M, Board1),
    setSpecialSquares(N, M, Board1, Board2),
    setInitialPieces(N, M, Board2, Board).


gameLoop(GameState, PlayerType, GameMode, N, M) :-
    gameOver(GameState, Winner), !,
    write('*^_^* The winner is '), write(Winner), write(' *^_^*'), nl.


gameLoop(GameState, PlayerType, GameMode, N, M) :-
    valid_moves(GameState, Player, ListOfMoves),
    printList((_, _, ListOfMoves)),
    choosePiece(N, M, GameState, PlayerType, Piece),
    chooseMoveType(GameState, PlayerType, Piece, Move),
    chooseMove(N, M, GameState, PlayerType, Piece, Move),
    move(GameState, Piece, Move, NewGameState),
    changePlayerType(PlayerType, NewPlayerType, GameMode),
    printList(NewGameState),
    write("New Player Type: "), write(NewPlayerType), nl,
    gameLoop(NewGameState, NewPlayerType, GameMode, N, M), !.
    %move(GameState, Piece, Move, NewGameState),
    %changeTurn(PlayerType, NewPlayerType, Difficulty),
    %gameLoop(NewGameState, NewPlayerType, Difficulty), !.


% changeTurn(+PlayerType, -NewPlayerType, +GameMode)
changePlayerType(p, p, p-p).
changePlayerType(p, Level, p-Level).
changePlayerType(Level, p, p-Level).
changePlayerType(Level1, Level2, Level1-Level2).
changePlayerType(Level1, Level2, Level2-Level1).

odd(N) :- 
    N mod 2 =:= 1.

greenOrBlue(Turn, green) :-
    odd(Turn).

greenOrBlue(Turn, blue) :-
    \+odd(Turn).



/*
% initial_state(+N, +M, -GameState)
initial_state(
    game_state(
        1, % Turn
        [], % MoveHistory
        [
            [neutral, empty, blue, blue, greenGoal],
            [empty, empty, empty, empty, blue],
            [green, empty, empty, empty, blue],
            [green, empty, empty, empty, empty],
            [blueGoal, green, green, empty, neutral]
        ]
    )
).

*/

printList((_, _, [])).

printList((_, _, [H|T])) :-
    write(H), nl,
    printList((_, _, T)).


