moveTypeChoice(Option, Description) :-
    format('   [ ~p ] ~p ~n', [Option, Description]).

askMoveType(PlayerType, Num) :-
    nl, nl,
    moveTypeChoice(0, 'Move this piece'), nl,
    moveTypeChoice(1, 'Capture a piece'), nl,
    readInputBetween(0, 1, Num).

printTurn(Turn) :-
    greenOrBlue(Turn, Color),
    format('   *** ~p TURN *** ~n.', [Color]).

chooseMoveType((Turn, MoveHistory, Board), p, MoveType) :-
    askMoveType(p, MoveType).



% in this case, piece is output
choosePiece(N, M, (Turn, MoveHistory, Board), PlayerType, (Color, X, Y)) :-
    repeat,
    nl,
    greenOrBlue(Turn, Color),
    printTurn(Turn), nl,
    write('CHOOSE A PIECE TO MOVE:'), nl, nl,
    askBoardPosition(X, Y, N, M),
    checkSquareType(X, Y, Color, Board),
    format('   You chose (~p, ~p). ~n.', [X, Y]).


askBoardPosition(X, Y, N, M) :-
    write('--- X coordinate: ---'), nl,
    readInputBetween(1, N, X), nl, nl,
    write('--- Y coordinate: ---'), nl,
    readInputBetween(1, M, Y), nl, nl.

% in this case, piece is received. When user wants to move.
chooseMove(N, M, (Turn, MoveHistory, Board), 0, PlayerType, (Color, X1, Y1), (X2, Y2)) :-
    repeat,
    nl,
    write('CHOOSE A MOVE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canMove(Color, X1, Y1, X2, Y2, Board),
    format('  SUCCESS: You moved (~p, ~p) to (~p, ~p) ~n.', [X1, Y1, X2, Y2]).


chooseMove(N, M, (Turn, MoveHistory, Board), 1, PlayerType, (Color, X1, Y1), (X2, Y2)) :-
    repeat,
    nl,
    write('CHOOSE A PIECE TO CAPTURE:'), nl, nl,
    askBoardPosition(X2, Y2, N, M),
    canCapture(Color, X1, Y1, X2, Y2, Board).

askReplacePosition(X, Y, Board) :-
    repeat,
    nl,
    write('CHOOSE A POSITION TO PLACE THE CAPTURED PIECE:'), nl, nl,
    getBoardSize(Board, N, M),
    askBoardPosition(X, Y, N, M),
    checkSquareType(X, Y, empty, Board).

    


