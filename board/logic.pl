% Can Move From (X1,Y1) -> (X2,Y2)

% Can Move From (X1,Y1) -> (X2,Y2) Blue - Move to the left and check if the square is empty
canMove(blue, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 - 1,
    Y2 =:= Y1,
    checkSquareType(X2, Y2, empty, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Blue - Move to the left and check if the square is blueGoal
canMove(blue, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 - 1,
    Y2 =:= Y1,
    checkSquareType(X2, Y2, blueGoal, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Blue - Move Down and check if the square is empty
canMove(blue, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1,
    Y2 =:= Y1 + 1,
    checkSquareType(X2, Y2, empty, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Blue - Move Down and check if the square is blueGoal
canMove(blue, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1,
    Y2 =:= Y1 + 1,
    checkSquareType(X2, Y2, blueGoal, Board).


% Can Move From (X1,Y1) -> (X2,Y2) Green - Move to the right and check if the square is empty
canMove(green, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 + 1,
    Y2 =:= Y1,
    checkSquareType(X2, Y2, empty, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Green - Move to the right and check if the square is greenGoal
canMove(green, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 + 1,
    Y2 =:= Y1,
    checkSquareType(X2, Y2, greenGoal, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Green - Move Up and check if the square is empty
canMove(green, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1,
    Y2 =:= Y1 - 1,
    checkSquareType(X2, Y2, empty, Board).

% Can Move From (X1,Y1) -> (X2,Y2) Green - Move Up and check if the square is greenGoal
canMove(green, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1,
    Y2 =:= Y1 - 1,
    checkSquareType(X2, Y2, greenGoal, Board).


% Can Capture From (X1,Y1) -> (X2,Y2)
opponent(blue, green).
opponent(green, blue).
% Can Capture From (X1,Y1) -> (X2,Y2) - Move to the (X1 + 1, Y1 - 1) and check if the square is green
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    X2 =:= X1 + 1,
    Y2 =:= Y1 - 1,
    checkSquareType(X2, Y2, Opponent, Board).

% Can Capture From (X1,Y1) -> (X2,Y2) - Move to the (X1 + 1, Y1 + 1) and check if the square is green
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    X2 =:= X1 + 1,
    Y2 =:= Y1 + 1,
    checkSquareType(X2, Y2, Opponent, Board).

% Can Capture From (X1,Y1) -> (X2,Y2) - Move to the (X1 - 1, Y1 - 1) and check if the square is green
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 - 1,
    Y2 =:= Y1 - 1,
    checkSquareType(X2, Y2, Opponent, Board).

% Can Capture From (X1,Y1) -> (X2,Y2) - Move to the (X1 - 1, Y1 + 1) and check if the square is green
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    X2 =:= X1 - 1,
    Y2 =:= Y1 + 1,
    checkSquareType(X2, Y2, Opponent, Board).
  

gameOver((_, _, Board), Winner) :-
    checkGameOver(Board, Winner).

checkGameOver(Board, blue) :-
    getBoardSize(Board, _, M),
    checkSquareType(1, M, blue, Board).

checkGameOver(Board, green) :-
    getBoardSize(Board, N, _),
    checkSquareType(N, 1, green, Board).