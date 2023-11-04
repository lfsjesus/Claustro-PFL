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
    %trace,
    valid_moves(GameState, Player, ListOfMoves),
    printList((_, _, ListOfMoves)),
    furthestPosition(Player, GameState, X, Y),
    write('Furthest empty is at '), write(X), write(', '), write(Y), nl,
    choosePiece(N, M, GameState, PlayerType, Piece),
    chooseMoveType(GameState, PlayerType, Piece, Move),
    chooseMove(N, M, GameState, PlayerType, Piece, Move),

    askReplacePosition(PlayerType, Move, Piece1, Move1, GameState),
    move(GameState, Piece1, Move1, NewGameState),
    move(NewGameState, Piece, Move, NewGameState1),
    changeTurn(NewGameState1, NewGameState2),
    changePlayerType(PlayerType, NewPlayerType, GameMode),
    printList(NewGameState2),
    gameLoop(NewGameState2, NewPlayerType, GameMode, N, M), !.


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


