:- use_module(library(lists)).

/* Get the board size: N columns and M rows.
/  getBoardSize(+Board, -N, -M)
*/
getBoardSize(Board, N, M) :-
    length(Board, M),
    nth1(1, Board, FirstRow),
    length(FirstRow, N).

/* Sets a board with the given size.
/  setBoard(+N, +M, -Board)
*/
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

/* Creates a Row with N empty cells.
*  createRow(+N, -Row)
*/
createRow(N, Row) :- createRow(N, Row, []).

createRow(0, Acc, Acc).

createRow(N, Row, Acc) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [empty], NewAcc),
    createRow(N1, Row, NewAcc).

/*
*  Replaces the element at a specific position in a list, and returns the new list (Row->NewRow).
*  replace_at_position(+Position, +NewValue, +List, -NewRow)
*/
replace_at_position(Position, NewValue, List, NewRow) :-
    append(Prefix, [_|Suffix], List),          
    length(Prefix, PositionMinusOne),          
    PositionMinusOne =:= Position - 1,     
    append(Prefix, [NewValue|Suffix], NewRow).

/* Changes the value of a cell in a board.
*  change_cell(+Board, +RowPos, +Col, +NewValue, -NewBoard)
*/
change_cell(Board, RowPos, Col, NewValue, NewBoard) :-
    nth1(RowPos, Board, Row),
    replace_at_position(Col, NewValue, Row, NewRow), 
    replace_at_position(RowPos, NewRow, Board, NewBoard).

/* Sets the special squares in the board - neutral (unused squares) and goals.
*  setSpecialSquares(+N, +M, +Board, -NewBoard)
*/
setSpecialSquares(N, M, Board, NewBoard) :-
    change_cell(Board, 1, 1, neutral, NewBoard1),
    change_cell(NewBoard1, 1, N, greenGoal, NewBoard2),
    change_cell(NewBoard2, M, 1, blueGoal, NewBoard3),
    change_cell(NewBoard3, M, N, neutral, NewBoard).

/* Sets the initial pieces on the N (width) side of the board.
*  setNInitialPieces(+N, +StartPos, +NewValue, +List, -NewList)
*/
setNInitialPieces(0, _, _, List, List).

setNInitialPieces(N, StartPos, NewValue, List, NewList) :-
    N > 0,
    replace_at_position(StartPos, NewValue, List, NewList1),
    NewStartPos is StartPos + 1,
    NewN is N - 1,
    setNInitialPieces(NewN, NewStartPos, NewValue, NewList1, NewList).

/* Sets the initial pieces on the M (height) side of the board. 
*  setMInitialPieces(+MPieces, +StartPos, +Col, +NewValue, +Board, -NewBoard)
*/
setMInitialPieces(0, _, _, _, Board, Board).

setMInitialPieces(MPieces, StartPos, Col, NewValue, Board, NewBoard) :-
    MPieces > 0,
    change_cell(Board, StartPos, Col, NewValue, NewBoard1),
    NewStartPos is StartPos + 1,
    NewMPieces is MPieces - 1,
    setMInitialPieces(NewMPieces, NewStartPos, Col, NewValue, NewBoard1, NewBoard).    

/* Sets the initial pieces on the board. Uses setNInitialPieces and setMInitialPieces for each side, for each player/color.
*  setInitialPieces(+N, +M, +Board, -NewBoard)
*/
setInitialPieces(N, M, Board, NewBoard) :-
    PiecesN is N - 3,
    PiecesM is M - 3,

    nth1(1, Board, FirstRow),   
    setNInitialPieces(PiecesN, 3, blue, FirstRow, NewFirstRow),
    replace_at_position(1, NewFirstRow, Board, NewBoard1),
    setMInitialPieces(PiecesM, 2, N, blue, NewBoard1, NewBoard2),

    nth1(M, Board, LastRow),
    setNInitialPieces(PiecesN, 2, green, LastRow, NewLastRow),
    replace_at_position(M, NewLastRow, NewBoard2, NewBoard3),
    setMInitialPieces(PiecesM, 3, 1, green, NewBoard3, NewBoard).

/* Gets the value of a square in the board.
*  getSquare(+X, +Y, +Board, -Type)
*/
getSquare(X, Y, Board, Type) :-
    nth1(Y, Board, Row),           
    nth1(X, Row, Type).

/* Checks the type of a square in the board. The same as getSquare, but renamed for clarity.
*  checkSquareType(+X, +Y, -Type, +Board)
*/
checkSquareType(X, Y, Type, Board) :-
    getSquare(X, Y, Board, Type).

/* Performs a Move on the board. A Move is represented by a tuple of a Piece - (Color, X, Y) - and (MoveType, X1, Y1), being X1 and Y1 the coordinates of the destination square.
*  move(+GameState, +Move, -NewGameState)*  
*/
move(GameState, null, GameState).

move((Turn, MoveHistory, Board), ((Color, X, Y), (MoveType, X1, Y1)), (Turn, NewMoveHistory, NewBoard)) :-
    greenOrBlue(Turn, Color),
    movePiece(((Color, X, Y), (MoveType, X1, Y1)), Board, NewBoard),
    append([((Color, X, Y), (MoveType, X1, Y1))], MoveHistory, NewMoveHistory).

move((Turn, MoveHistory, Board), Move, (Turn, MoveHistory, NewBoard)) :-
    movePiece(Move, Board, NewBoard).


/* Moves a piece on the board. This implies changing the cell to empty and the destination cell to the piece's color.
*  movePiece(+Move, +Board, -NewBoard)
*/
movePiece(((Color, X1, Y1), (_, X2, Y2)), Board, NewBoard) :-
    change_cell(Board, Y1, X1, empty, Board1),
    change_cell(Board1, Y2, X2, Color, NewBoard).

/* Tests a "regular" move. For greedy bot purposes.
*  testMove(+GameState, +Move, -NewGameState)
*/
testMove((Turn, _, Board), (Color, X1, Y1), (0, X2, Y2), (Turn, _, NewBoard)) :-
    move((Turn, _, Board), ((Color, X1, Y1), (_, X2, Y2)), (_, _, NewBoard)).

/* Tests a capture. For greedy bot purposes.
*  testMove(+GameState, +Move, -NewGameState)
*/
testMove((Turn, _, Board), (Color, X1, Y1), (1, X2, Y2), (Turn, _, NewBoard2)) :-
    opponent(Color, OpponentColor),
    furthestPosition(OpponentColor, (Turn, _, Board), Xempty, Yempty),
    move((Turn, _, Board), ((OpponentColor, X2, Y2), (0, Xempty, Yempty)), (_, _, NewBoard1)),
    move((Turn, _, NewBoard1), ((Color, X1, Y1), (0, X2, Y2)), (_, _, NewBoard2)).


