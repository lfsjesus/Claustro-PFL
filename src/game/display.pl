/* Displays the game board at a given GameState.
*  display_game(+GameState)
*
*/
display_game((_, _, Board)) :- 
    getBoardSize(Board, N, M),
    clear,
    displayCols(N),
    displayBoard(Board, M, N).

/* Displays columns numbered from 1 to N.
*  displayCols(+N)
*/
displayCols(N) :-
    headerBorder(N),
    write('      |'),
    displayCols(N, 1),
    headerBorder(N),
    nl.

displayCols(N, N) :- write('  '), write(N), write('  |'), nl, !.

displayCols(N, Acc) :-
    C is Acc,
    write('  '), write(C), write('  |'),
    Acc1 is Acc + 1,
    displayCols(N, Acc1).

/* Displays the board.
*  displayBoard(+Board, +M, +N)
*/
displayBoard(Board, M, N) :-
    boardDelimiter(N),
    displayRows(Board, M, N, 1),
    boardDelimiter(N), nl.

/* Displays rows numbered from 1 to M.
*  displayRows(+Board, +M, +N, +Acc)
*/
displayRows(Board, M, N, M) :-
    boardRow(Board, M, N), !.

displayRows(Board, M, N, Acc) :-
    boardRow(Board, Acc, N),
    boardDelimiter(N),
    Acc1 is Acc + 1,
    displayRows(Board, M, N, Acc1).

/* Draws a row of the board.
*  boardRow(+Board, +LineIdx, +Cols)
*/
boardRow(Board, M, N) :-
    format('~t~d~t~3||', [M]),
    write('  |'),
    LineIdx is M,
    boardRow(Board, LineIdx, N, 1).

boardRow(Board, LineIdx, Cols, Cols) :-
    getSquare(Cols, LineIdx, Board, Color),
    squareSymbol(Color, Symbol),
    printSquare(Color, Symbol), nl, !.

boardRow(Board, LineIdx, Cols, Acc) :-
    getSquare(Acc, LineIdx, Board, Color),
    squareSymbol(Color, Symbol),
    printSquare(Color, Symbol),
    Acc1 is Acc + 1,
    boardRow(Board, LineIdx, Cols, Acc1).

/* Maps square types to symbols.
*  squareSymbol(+SquareType, -Symbol)
*/
squareSymbol(empty, ' ').
squareSymbol(neutral, '#').
squareSymbol(green, 'g').
squareSymbol(blue, 'b').
squareSymbol(greenGoal, 'G').
squareSymbol(blueGoal, 'B').

/* Prints squares according to their type.
*  printSquare(+SquareType, +Symbol)
*/
printSquare(blue, Symbol) :- format('  ~p  |', [Symbol]).
printSquare(green, Symbol) :- format('  ~p  |', [Symbol]).
printSquare(neutral, Symbol) :- format('###~p#|', [Symbol]).
printSquare(blueGoal, Symbol) :- format('# ~p #|', [Symbol]).
printSquare(greenGoal, Symbol) :- format('* ~p *|', [Symbol]).
printSquare(empty, Symbol) :- format(' ~p   |', [Symbol]).

/* Board delimiter.
*  boardDelimiter(+Cols)
*/
boardDelimiter(Cols) :-
    write('---|  |'),
    boardDelimiter(Cols, 1).

boardDelimiter(Cols, Cols) :- write('-----|'), nl, !.
boardDelimiter(Cols, Acc) :-
    write('-----+'),
    Acc1 is Acc + 1,
    boardDelimiter(Cols, Acc1).

/* header border.
*  headerBorder(+N)
*/
headerBorder(N) :-
    write('      |'),
    headerBorder(N, 1).

headerBorder(N, N) :- write('-----|'), nl, !.
headerBorder(N, Acc) :-
    write('-----+'),
    Acc1 is Acc + 1,
    headerBorder(N, Acc1).    