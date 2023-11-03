:- use_module(library(lists)).

setBoard(N, M, Board) :-
    N >= 5,
    N =< 10,
    M >= 5,
    M =< 10,
    setBoard(N, M, Board, [], M).

setBoard(_, _, Acc, Acc, 0).

setBoard(N, M, Board, Acc, RowsLeft) :-
    RowsLeft > 0,
    createRow(N, Row),
    append(Acc, [Row], NewAcc),
    NewRowsLeft is RowsLeft - 1,
    setBoard(N, M, Board, NewAcc, NewRowsLeft).


createRow(N, Row) :- createRow(N, Row, []).

createRow(0, Acc, Acc).

createRow(N, Row, Acc) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [empty], NewAcc),
    createRow(N1, Row, NewAcc).


% Helper predicate to replace an element in a list at a given position.
replace_at_position(Position, NewValue, List, NewRow) :-
    append(Prefix, [_|Suffix], List),          % Split the list into Prefix and Suffix
    length(Prefix, PositionMinusOne),           % Compute the length of Prefix
    PositionMinusOne =:= Position - 1,          % Check if PositionMinusOne is equal to Position - 1
    append(Prefix, [NewValue|Suffix], NewRow). % Construct the NewRow by replacing the element

% Predicate to change the value of a cell at a specific row and column in the board.
change_cell(Board, RowPos, Col, NewValue, NewBoard) :-
    nth1(RowPos, Board, Row), % Select the row using nth1/3
    replace_at_position(Col, NewValue, Row, NewRow), % Replace the element in the row using replace/4
    replace_at_position(RowPos, NewRow, Board, NewBoard).% Replace the row in the board using replace/4

setSpecialSquares(N, M, Board, NewBoard) :-
    % change_cell(Board, Row, Col, NewValue, NewBoard).
    change_cell(Board, 1, 1, neutral, NewBoard1),
    %same but for the last element of the first row
    change_cell(NewBoard1, 1, N, greenGoal, NewBoard2),
    %same but for the first element of the last row
    change_cell(NewBoard2, M, 1, blueGoal, NewBoard3),
    %same but for the last element of the last row
    change_cell(NewBoard3, M, N, neutral, NewBoard).


setNInitialPieces(0, _, _, List, List).

setNInitialPieces(N, StartPos, NewValue, List, NewList) :-
    N > 0,
    replace_at_position(StartPos, NewValue, List, NewList1),
    NewStartPos is StartPos + 1,
    NewN is N - 1,
    setNInitialPieces(NewN, NewStartPos, NewValue, NewList1, NewList).


setMInitialPieces(0, _, _, _, Board, Board).

setMInitialPieces(MPieces, StartPos, Col, NewValue, Board, NewBoard) :-
    MPieces > 0,
    change_cell(Board, StartPos, Col, NewValue, NewBoard1),
    NewStartPos is StartPos + 1,
    NewMPieces is MPieces - 1,
    setMInitialPieces(NewMPieces, NewStartPos, Col, NewValue, NewBoard1, NewBoard).    


setInitialPieces(N, M, Board, NewBoard) :-
    PiecesN is N - 3,
    PiecesM is M - 3,
    % Blue pieces
    nth1(1, Board, FirstRow),   
    setNInitialPieces(PiecesN, 3, blue, FirstRow, NewFirstRow),
    replace_at_position(1, NewFirstRow, Board, NewBoard1),
    setMInitialPieces(PiecesM, 2, N, blue, NewBoard1, NewBoard2),
    % Green pieces
    nth1(M, Board, LastRow),
    setNInitialPieces(PiecesN, 2, green, LastRow, NewLastRow),
    replace_at_position(M, NewLastRow, NewBoard2, NewBoard3),
    setMInitialPieces(PiecesM, 3, 1, green, NewBoard3, NewBoard).

getSquare(X, Y, Board, Value) :-
    nth1(Y, Board, Row),           
    nth1(X, Row, Value).

checkSquareType(X, Y, Type, Board) :-
    getSquare(X, Y, Board, Type).

piece(Color, X, Y).

move((Turn, MoveHistory, Board), Piece, Move, (NewTurn, NewMoveHistory, NewBoard)) :-
    movePiece(Piece, Move, Board, NewBoard),
    NewTurn is Turn + 1,
    append(MoveHistory, [Move], NewMoveHistory).

movePiece((Color, X1, Y1), (X2, Y2), Board, NewBoard) :-
    change_cell(Board, Y1, X1, empty, Board1),
    change_cell(Board1, Y2, X2, Color, NewBoard).



















/*

%every possible move from a given position

% Can Move Blue
canMove(blue, X, Y, Board) :-
    checkSquareType(X-1, Y, empty, Board).  % Move to the left and check if the square is empty

canMove(blue, X, Y, Board) :-
    checkSquareType(X-1, Y, blueGoal, Board).  % Move to the left and check if the square is blueGoal


canMove(blue, X, Y, Board) :-
    checkSquareType(X, Y+1, empty, Board).   % Move Down and check if the square is empty

canMove(blue, X, Y, Board) :-
    checkSquareType(X, Y+1, blueGoal, Board).  % Move Down and check if the square is blueGoal


% Can Move Green
canMove(green, X, Y, Board) :-
    checkSquareType(X+1, Y, empty, Board).  % Move to the right and check if the square is empty

canMove(green, X, Y, Board) :-
    checkSquareType(X+1, Y, greenGoal, Board).  % Move to the right and check if the square is greenGoal

canMove(green, X, Y, Board) :-
    checkSquareType(X, Y-1, empty, Board).   % Move Up and check if the square is empty

canMove(green, X, Y, Board) :-
    checkSquareType(X, Y-1, greenGoal, Board).  % Move Up and check if the square is greenGoal

*/