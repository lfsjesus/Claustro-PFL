:- use_module(library(random)).

moveTypeChoice(Option, Description) :-
    format('   [ ~p ] ~p ~n', [Option, Description]).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (0, X2, Y2), Board),
    valid_move(Piece, (1, X3, Y3), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl,
    moveTypeChoice(1, 'Capture a piece'), nl, nl,
    readInputBetween(0, 1, Num).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (0, X2, Y2), Board), !,
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl, nl,
    readInputBetween(0, 0, Num).

askMoveType(PlayerType, Piece, Board, Num) :-
    valid_move(Piece, (1, X2, Y2), Board), !,
    nl, nl,
    moveTypeChoice(1, 'Capture a piece'), nl, nl,
    readInputBetween(1, 1, Num).

printTurn(Turn) :-
    greenOrBlue(Turn, Color),
    format('   *** ~p TURN *** ~n.', [Color]).

% Move: ((Color, X1, Y1), (MoveType, X2, Y2))
chooseMoveType((_, _, Board), p, Piece, (Piece, (MoveType, _, _))) :-
    askMoveType(p, Piece, Board, MoveType).

% easy bot move type does nothing. he chooses a random move despite the type.
chooseMoveType((Turn, _, Board), e, Piece, (Piece, _)).

% hard bot move type chooses the most valueable move
chooseMoveType((Turn, _, Board), h, _, _).


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



randomPiece(ListOfPieces, Board, Piece) :-
    random_member(Piece, ListOfPieces),
    pieceNotStuck(Piece, Board).


choosePiece(N, M, (Turn, _, Board), e, Piece) :-
    greenOrBlue(Turn, Color),
    piecesOf(Color, Board, ListOfPieces),
    randomPiece(ListOfPieces, Board, Piece).

choosePiece(N, M, (Turn, _, Board), h, _).


askBoardPosition(X, Y, N, M) :-
    write('--- X coordinate: ---'), nl,
    readInputBetween(1, N, X), nl, nl,
    write('--- Y coordinate: ---'), nl,
    readInputBetween(1, M, Y), nl, nl.


askReplacePosition(_, (_,(0, _, _)), null, _). % if move type is 0, there is no captured piece

% move: ((Color, X1, Y1), (MoveType, X2, Y2))
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


chooseMove(N, M, (Turn, MoveHistory, Board), p, ((Color, X1, Y1), (0, X2, Y2))) :-
    repeat,
    nl,
    write('CHOOSE A MOVE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canMove(Color, X1, Y1, X2, Y2, Board),
    format('  SUCCESS: You moved (~p, ~p) to (~p, ~p). ~n', [X1, Y1, X2, Y2]).


chooseMove(N, M, (Turn, MoveHistory, Board), p, ((Color, X1, Y1), (1, X2, Y2))) :-
    repeat,
    nl,
    write('CHOOSE A PIECE TO CAPTURE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canCapture(Color, X1, Y1, X2, Y2, Board).


chooseMove(N, M, (Turn, MoveHistory, Board), e, ((Color, X1, Y1), (MoveType, X2, Y2))) :-
    var(MoveType),
    valid_moves_piece((Turn, _, Board), (Color, X1, Y1), ListOfMoves),
    random_member((MoveType, X2, Y2), ListOfMoves), !,
    chooseMove(N, M, (Turn, MoveHistory, Board), e, ((Color, X1, Y1), (MoveType, X2, Y2))).

chooseMove(N, M, (Turn, MoveHistory, Board), e, ((Color, X1, Y1), (0, X2, Y2))) :-
    format('  ~nBot ~p moved (~p, ~p) to (~p, ~p). ~n~n', [Color, X1, Y1, X2, Y2]),
    pressEnterToContinue.

chooseMove(N, M, (Turn, MoveHistory, Board), e, ((Color, X1, Y1), (1, X2, Y2))).

pressEnterToContinue :-
    write(' Press [ENTER] to continue...'), nl,
    get_char(_).    


testMove((Turn, _, Board), (Color, X1, Y1), (0, X2, Y2), (Turn, _, NewBoard)) :-
    move((Turn, _, Board), ((Color, X1, Y1), (MoveType, X2, Y2)), (_, _, NewBoard)).

testMove((Turn, _, Board), (Color, X1, Y1), (1, X2, Y2), (Turn, _, NewBoard2)) :-
    opponent(Color, OpponentColor),
    furthestPosition(OpponentColor, (Turn, _, Board), Xempty, Yempty),
    move((Turn, _, Board), ((Opponent, X2, Y2), (0, Xempty, Yempty)), (_, _, NewBoard1)),
    move((Turn, _, NewBoard1), ((Color, X1, Y1), (0, X2, Y2)), (_, _, NewBoard2)).


chooseMove(N, M, (Turn, MoveHistory, Board), h, ((Color, X1, Y1), (MoveType, X2, Y2))) :-
    var(MoveType),
    greenOrBlue(Turn, Player),
    value((Turn, _, Board), Player, CurrentScore), %somar todas as minhas distancias ao golo e subtrarir todas as distancias dos inimigos ao goal deles
    mostValueableMove((Turn, _, Board), (Color, X1, Y1), (MoveType, X2, Y2)), !,
    testMove((Turn,_, Board), (Color, X1, Y1), (MoveType, X2, Y2), (Turn,_, NewBoard)),
    value((Turn, _, NewBoard), Player, NewScore), %somar todas as minhas distancias ao golo e subtrarir todas as distancias dos inimigos ao goal deles
    GameStateScore is NewScore - CurrentScore,
    GameStateScore >= 0,
    chooseMove(N, M, (Turn, MoveHistory, Board), h, ((Color, X1, Y1), (MoveType, X2, Y2))).

chooseMove(N, M, (Turn, MoveHistory, Board), h, ((Color, X1, Y1), (0, X2, Y2))) :-
    format('  ~nBot ~p moved (~p, ~p) to (~p, ~p). ~n~n', [Color, X1, Y1, X2, Y2]),
    pressEnterToContinue.

chooseMove(N, M, (Turn, MoveHistory, Board), h, ((Color, X1, Y1), (1, X2, Y2))).


