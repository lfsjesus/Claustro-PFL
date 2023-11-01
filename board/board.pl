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

