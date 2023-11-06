:- use_module(library(random)).

/* Prints a formatted Option/Description pair
*  moveTypeChoice(+Option, +Description)
*/
moveTypeChoice(Option, Description) :-
    format('   [ ~p ] ~p ~n', [Option, Description]).

/* Asks the user to choose a move type. Checks if the move type is valid and only shows the options that are valid.
*  askMoveType(+Piece, +Board, -Num)
*/
askMoveType(Piece, Board, Num) :-
    valid_move((Piece, (0, _, _)), Board),
    valid_move((Piece, (1, _, _)), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl,
    moveTypeChoice(1, 'Capture a piece'), nl, nl,
    readInputBetween(0, 1, Num).

askMoveType(Piece, Board, Num) :-
    valid_move((Piece, (0, _, _)), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl, nl,
    readInputBetween(0, 0, Num).

askMoveType(Piece, Board, Num) :-
    valid_move((Piece, (1, _, _)), Board), !,
    nl, nl,
    moveTypeChoice(1, 'Capture a piece'), nl, nl,
    readInputBetween(1, 1, Num).

/* Prints player's turn: green or blue.
*  printTurn(+Turn)
*/
printTurn(Turn) :-
    greenOrBlue(Turn, Color),
    format('   *** ~p TURN *** ~n.', [Color]).

/* Asks the user to choose a move type. A move is a pair of a piece and a move type, which is an output.
*  chooseMoveType(+GameState, +Level, +Piece, -Move)
*/
chooseMoveType((_, _, Board), p, Piece, (Piece, (MoveType, _, _))) :-
    askMoveType(Piece, Board, MoveType).

chooseMoveType((_, _, _), e, Piece, (Piece, _)).

chooseMoveType((_, _, _), h, _, _).


/* Selects a random piece that is not stuck. For easy bot.
*  randomPiece(+ListOfPieces, +Board, -Piece)
*/
randomPiece(ListOfPieces, Board, Piece) :-
    random_member(Piece, ListOfPieces),
    pieceNotStuck(Piece, Board).


/* Asks the user to choose a piece to perform an action. Checks if the piece can be chosen (e.g. is not stuck).
*  choosePiece(+GameState, +Level, -Piece)
*/
choosePiece((Turn, _, Board), p, (Color, X, Y)) :-
    repeat,
    nl,
    greenOrBlue(Turn, Color),
    getBoardSize(Board, N, M),
    printTurn(Turn), nl,
    write('CHOOSE A PIECE TO MOVE:'), nl, nl,
    askBoardPosition(X, Y, N, M),
    checkSquareType(X, Y, Color, Board),
    pieceNotStuck((Color, X, Y), Board). % if piece is stuck, ask again

choosePiece((Turn, _, Board), e, Piece) :-
    greenOrBlue(Turn, Color),
    piecesOf(Color, Board, ListOfPieces),
    randomPiece(ListOfPieces, Board, Piece).

choosePiece((_, _, _), h, _).

/* Asks for a position in the board.
*  askBoardPosition(-X, -Y, +N, +M)
*/
askBoardPosition(X, Y, N, M) :-
    write('--- X coordinate: ---'), nl,
    readInputBetween(1, N, X), nl, nl,
    write('--- Y coordinate: ---'), nl,
    readInputBetween(1, M, Y), nl, nl.
 
/* Asks for replacement position of a captured piece. Returns a null move if the move type is 0.
*  askReplacePosition(+Level, +Move, -CapturedPieceMove, +GameState)
*/
askReplacePosition(_, (_,(0, _, _)), null, _).

askReplacePosition(p, (_, (1, X, Y)), ((Color, X, Y), (MoveType, X2, Y2)), (_, _, Board)) :-
    repeat,
    nl,
    write('CHOOSE A POSITION TO PLACE THE CAPTURED PIECE:'), nl, nl,
    checkSquareType(X, Y, Color, Board),
    getBoardSize(Board, N, M),
    askBoardPosition(X2, Y2, N, M),
    checkSquareType(X2, Y2, empty, Board),
    MoveType is 0,
    format('  SUCCESS: You moved (~p, ~p) to (~p, ~p). ~n', [X, Y, X2, Y2]).

askReplacePosition(e, ((MyColor, _, _), (1, X, Y)), ((Color, X, Y), (MoveType, X1, Y1)), (_, _, Board)) :-
    checkSquareType(X, Y, Color, Board), % color of captured piece
    getBoardSize(Board, N, M),
    random(1, N, X1),
    random(1, M, Y1),
    checkSquareType(X1, Y1, empty, Board),
    MoveType is 0,
    write(' Bot '), write(MyColor), write(' moved the captured piece to the position: '), write((X1, Y1)), nl, nl,
    write(' Bot is now on position: '), write((X, Y)), nl, nl,
    pressEnterToContinue.

askReplacePosition(h, ((MyColor, _, _), (1, X, Y)), ((OpponentColor, X, Y), (MoveType, X1, Y1)), (_, _, Board)) :-
    opponent(MyColor, OpponentColor), % color of captured piece
    furthestPosition(OpponentColor, (_, _, Board), X1, Y1), % position of captured piece
    MoveType is 0,
    write(' Bot '), write(MyColor), write(' moved the captured piece to the position: '), write((X1, Y1)), nl, nl,
    write(' Bot is now on position: '), write((X, Y)), nl, nl,
    pressEnterToContinue.

/* Chooses a move. Checks if the move is valid. In case of random bot, it chooses a random move of the selected piece.
*  Greedy bot chooses the most valuable move.
*  choose_move(+GameState, +Player, +Level, -Move)
*/
choose_move((_, _, Board), Player, p, ((Player, X1, Y1), (0, X2, Y2))) :-
    repeat,
    nl,
    getBoardSize(Board, N, M),
    write('CHOOSE A MOVE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canMove(Player, X1, Y1, X2, Y2, Board),
    format('  SUCCESS: You moved (~p, ~p) to (~p, ~p). ~n', [X1, Y1, X2, Y2]).


choose_move((_, _, Board), Player, p, ((Player, X1, Y1), (1, X2, Y2))) :-
    repeat,
    nl,
    getBoardSize(Board, N, M),
    write('CHOOSE A PIECE TO CAPTURE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canCapture(Player, X1, Y1, X2, Y2, Board).


choose_move((Turn, MoveHistory, Board), Player, e, ((Player, X1, Y1), (MoveType, X2, Y2))) :-
    var(MoveType),
    valid_moves_piece((Turn, _, Board), (Player, X1, Y1), ListOfMoves),
    random_member((MoveType, X2, Y2), ListOfMoves), !,
    choose_move((Turn, MoveHistory, Board), Player, e, ((Player, X1, Y1), (MoveType, X2, Y2))).

choose_move((_, _, _), Player, e, ((Player, X1, Y1), (0, X2, Y2))) :-
    format('  ~nBot ~p moved (~p, ~p) to (~p, ~p). ~n~n', [Player, X1, Y1, X2, Y2]),
    pressEnterToContinue.

choose_move((_, _, _), Player, e, ((Player, _, _), (1, _, _))).

choose_move((Turn, MoveHistory, Board), Player, h, ((Player, X1, Y1), (MoveType, X2, Y2))) :-
    var(MoveType),
    value((Turn, _, Board), Player, CurrentScore), 
    mostValueableMove((Turn, _, Board), ((Player, X1, Y1), (MoveType, X2, Y2))), !,
    testMove((Turn,_, Board), (Player, X1, Y1), (MoveType, X2, Y2), (Turn,_, NewBoard)),
    value((Turn, _, NewBoard), Player, NewScore),
    GameStateScore is NewScore - CurrentScore,
    GameStateScore >= 0,
    choose_move((Turn, MoveHistory, Board), Player, h, ((Player, X1, Y1), (MoveType, X2, Y2))).

choose_move((_, _, _), Player, h, ((Player, X1, Y1), (0, X2, Y2))) :-
    format('  ~nBot ~p moved (~p, ~p) to (~p, ~p). ~n~n', [Player, X1, Y1, X2, Y2]),
    pressEnterToContinue.

choose_move((_, _, _), Player, h, ((Player, _, _), (1, _, _))).


