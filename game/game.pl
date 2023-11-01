gameInit(N, M, P1-P2) :- 
    initial_state(N, M, (Turn, MoveHistory, Board)),
    setSpecialSquares(N, M, Board, NewBoard),

    /* display_game(GameState), */
    


initial_state(N, M, (Turn, MoveHistory, Board)) :-
    setBoard(N, M, Board).

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