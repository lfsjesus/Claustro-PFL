

gameInit(N, M, P1-P2) :- 
    initial_state(N, M, (Turn, MoveHistory, Board)),
    write(Board).

    /* display_game(GameState), */
    


initial_state(N, M, (Turn, MoveHistory, Board)) :-
    setBoard(N, M, Board).


setBoard(N, M, Board) :-
    N >= 3,
    N =< 10,
    M >= 3,
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



/*
% initial_state(+N, +M, -GameState)
initial_state(


    game_state(
        1, % Turn
        [], % MoveHistory
        [
            [neutral, empty, blue, blue, greenGoal],
            [empty, empty, empty, empty, blue],
            [green, empty, empty, empty, blue],
            [green, empty, empty, empty, empty],
            [blueGoal, green, green, empty, neutral]
        ]
    )
).

*/