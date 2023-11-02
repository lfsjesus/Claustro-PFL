
gameInit(N, M, P1-P2) :- 
    initial_state(N, M, (Turn, MoveHistory, Board)),
    setSpecialSquares(N, M, Board, NewBoard), 
    setInitialPieces(N, M, NewBoard, NewNewBoard),
    printList(NewNewBoard),
    checkSquare(neutral, X, Y, NewNewBoard),
    gameLoop((Turn, MoveHistory, Board), PlayerType, Difficulty, N, M).

initial_state(N, M, (Turn, MoveHistory, Board)) :-
    setBoard(N, M, Board).


gameLoop(GameState, PlayerType, Difficulty, N, M) :-
    choosePiece(N, M, GameState, PlayerType, Piece).
    %chooseMove(GameState, PlayerType, Piece, Move),
    %move(GameState, Piece, Move, NewGameState),
    %changeTurn(PlayerType, NewPlayerType, Difficulty),
    %gameLoop(NewGameState, NewPlayerType, Difficulty), !.





choosePiece(N, M, GameState, PlayerType, Piece) :-
    nl,
    write('CHOOSE A PIECE TO MOVE:'), nl, nl,
    write('--- X coordinate: ---'), nl,
    readInputBetween(1, N, X), nl, nl,
    write('--- Y coordinate: ---'), nl,
    readInputBetween(1, M, Y), nl, nl.



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

printList([]).
printList([H|T]) :-
    write(H), nl,
    printList(T).


