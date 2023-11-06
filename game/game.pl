/* Initializes the game by getting an initial state and displaying it. Then, it starts the game loop. 
*  gameInit(+N, +M, +P1-P2, +FirstPlayer)
*/
gameInit(N, M, P1-P2, FirstPlayer) :-
    initial_state((N, M), GameState),
    display_game(GameState),
    gameLoop(GameState, FirstPlayer, P1-P2).

/* Returns a board to instantiate an initial GameState.
*  initial_state(+Size, +GameState)
*/
initial_state((N, M), (1, [], Board)) :-
    setBoard(N, M, Board1),
    setSpecialSquares(N, M, Board1, Board2),
    setInitialPieces(N, M, Board2, Board).

/* Game loop. It ends when the game is over.
*  gameLoop(+GameState, +PlayerType, +GameMode)
*  GameMode is either p-p, p-[e|h] or [e|h]-[e|h]. [e|h] means easy or hard/greedy bot.
*/
gameLoop(GameState, _, _) :-
    gameOver(GameState, Winner), !,
    write('*^_^* The winner is '), write(Winner), write(' *^_^*'), nl, nl.

gameLoop(GameState, PlayerType, GameMode) :-
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
    gameLoop(NewGameState2, NewPlayerType, GameMode), !.


/* Changes the player type, so the game deals with bot or human.
*  changePlayerType(+PlayerType, -NewPlayerType, +GameMode)
*/
changePlayerType(p, p, p-p).
changePlayerType(p, Level, p-Level).
changePlayerType(Level, p, p-Level).
changePlayerType(Level1, Level2, Level1-Level2).
changePlayerType(Level1, Level2, Level2-Level1).


/* Changes the turn by incrementing the turn counter. Odd turns are green, even turns are blue.
*  changeTurn(+GameState, -NewGameState)
*/ 
changeTurn((Turn, MoveHistory, Board), (NewTurn, MoveHistory, Board)) :-
    NewTurn is Turn + 1.
