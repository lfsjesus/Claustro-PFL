

gameInit(N, M, P1-P2) :- 
    initial_state(N, M, GameState),
    printList(GameState),
    gameLoop(GameState, P1, Difficulty, N, M).

initial_state(N, M, (1, MoveHistory, Board)) :-
    setBoard(N, M, Board1),
    setSpecialSquares(N, M, Board1, Board2),
    setInitialPieces(N, M, Board2, Board).


gameLoop(GameState, PlayerType, Difficulty, N, M) :-
    choosePiece(N, M, GameState, PlayerType, Piece),
    chooseMoveType(GameState, PlayerType, MoveType),
    chooseMove(N, M, GameState, MoveType, PlayerType, Piece, Move),
    move(GameState, Piece, Move, NewGameState),
    printList(NewGameState),
    gameLoop(NewGameState, NewPlayerType, Difficulty, N, M), !.
    %move(GameState, Piece, Move, NewGameState),
    %changeTurn(PlayerType, NewPlayerType, Difficulty),
    %gameLoop(NewGameState, NewPlayerType, Difficulty), !.


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


