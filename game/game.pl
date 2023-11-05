

gameInit(N, M, P1-P2, FirstPlayer) :-
    initial_state((N, M), GameState),
    display_game(GameState),
    gameLoop(GameState, FirstPlayer, P1-P2, N, M).

initial_state((N, M), (1, [], Board)) :-
    setBoard(N, M, Board1),
    setSpecialSquares(N, M, Board1, Board2),
    setInitialPieces(N, M, Board2, Board).


gameLoop(GameState, PlayerType, GameMode, N, M) :-
    gameOver(GameState, Winner), !,
    write('*^_^* The winner is '), write(Winner), write(' *^_^*'), nl, nl.


gameLoop(GameState, PlayerType, GameMode, N, M) :-
    choosePiece(GameState, PlayerType, Piece),
    chooseMoveType(GameState, PlayerType, Piece, Move),
    greenOrBlue(GameState, Player),
    choose_move(GameState, Player, PlayerType, Move),
    askReplacePosition(PlayerType, Move, Move1, GameState),
    move(GameState, Move1, NewGameState),
    move(NewGameState, Move, NewGameState1),
    changeTurn(NewGameState1, NewGameState2),
    changePlayerType(PlayerType, NewPlayerType, GameMode),
    display_game(NewGameState2),
    gameLoop(NewGameState2, NewPlayerType, GameMode, N, M), !.

changePlayerType(p, p, p-p).
changePlayerType(p, Level, p-Level).
changePlayerType(Level, p, p-Level).
changePlayerType(Level1, Level2, Level1-Level2).
changePlayerType(Level1, Level2, Level2-Level1).
