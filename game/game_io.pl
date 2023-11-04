moveTypeChoice(Option, Description) :-
    format('   [ ~p ] ~p ~n', [Option, Description]).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (0, X2, Y2), Board),
    valid_move(Piece, (1, X3, Y3), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl,
    moveTypeChoice(1, 'Capture a piece'), nl,
    readInputBetween(0, 1, Num).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (0, X2, Y2), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl,
    readInputBetween(0, 0, Num).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (1, X2, Y2), Board), !,
    nl, nl,
    moveTypeChoice(1, 'Capture a piece'), nl,
    readInputBetween(1, 1, Num).

printTurn(Turn) :-
    greenOrBlue(Turn, Color),
    format('   *** ~p TURN *** ~n.', [Color]).

chooseMoveType((_, _, Board), p, Piece, (MoveType, _, _)) :-
    askMoveType(p, Piece, Board, MoveType).

% easy bot move type does nothing. he chooses a random move despite the type.
chooseMoveType((Turn, _, Board), e, Piece, Move).



% in this case, piece is output
choosePiece(N, M, (Turn, MoveHistory, Board), p, (Color, X, Y)) :-
    repeat,
    nl,
    greenOrBlue(Turn, Color),
    printTurn(Turn), nl,
    write('CHOOSE A PIECE TO MOVE:'), nl, nl,
    askBoardPosition(X, Y, N, M),
    checkSquareType(X, Y, Color, Board),
    pieceNotStuck((Color, X, Y), Board). % if piece is stuck, ask again
    format('   You chose (~p, ~p). ~n.', [X, Y]).

choosePiece(N, M, (Turn, _, Board), e, Piece) :-
    greenOrBlue(Turn, Color),
    piecesOf(Color, Board, ListOfPieces),
    randomPiece(ListOfPieces, Board, Piece).


randomPiece(ListOfPieces, Board, Piece) :-
    random_member(Piece, ListOfPieces),
    pieceNotStuck(Piece, Board).


askBoardPosition(X, Y, N, M) :-
    write('--- X coordinate: ---'), nl,
    readInputBetween(1, N, X), nl, nl,
    write('--- Y coordinate: ---'), nl,
    readInputBetween(1, M, Y), nl, nl.

askReplacePosition(X, Y, Board) :-
    repeat,
    nl,
    write('CHOOSE A POSITION TO PLACE THE CAPTURED PIECE:'), nl, nl,
    getBoardSize(Board, N, M),
    askBoardPosition(X, Y, N, M),
    checkSquareType(X, Y, empty, Board).

chooseMove(N, M, (Turn, MoveHistory, Board), p, (Color, X1, Y1), (0, X2, Y2)) :-
    repeat,
    nl,
    write('CHOOSE A MOVE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canMove(Color, X1, Y1, X2, Y2, Board),
    format('  SUCCESS: You moved (~p, ~p) to (~p, ~p). ~n', [X1, Y1, X2, Y2]).


chooseMove(N, M, (Turn, MoveHistory, Board), p, (Color, X1, Y1), (1, X2, Y2)) :-
    repeat,
    nl,
    write('CHOOSE A PIECE TO CAPTURE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canCapture(Color, X1, Y1, X2, Y2, Board).





chooseMove(N, M, (Turn, MoveHistory, Board), e, (Color, X1, Y1), (0, X2, Y2)) :-
    greenOrBlue(Turn, Color),
    valid_moves_piece((Turn, _, Board), (Color, X1, Y1), ListOfMoves),
    random_member((0, X2, Y2), ListOfMoves).


chooseMove(N, M, (Turn, MoveHistory, Board), e, (Color, X1, Y1), (1, X2, Y2)) :-
    greenOrBlue(Turn, Color),
    valid_moves_piece((Turn, _, Board), (Color, X1, Y1), ListOfMoves),
    random_member((1, X2, Y2), ListOfMoves).


    


