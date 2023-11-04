:- use_module(library(between)).

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


piecesOf(Player, Board, ListOfPieces) :-
    findall(
        (Player, X, Y),
        (   
            getBoardSize(Board, N, M),
            between(1, N, X),
            between(1, M, Y),
            checkSquareType(X, Y, Player, Board)
        ),
        ListOfPieces
    ).

valid_move((Player, X1, Y1), (MoveType, X2, Y2), Board) :- 
    canMove(Player, X1, Y1, X2, Y2, Board).

valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    piecesOf(Player, Board, ListOfPieces),
    findall(
        (MoveType, X2, Y2), 
        (   
            member((Player, X1, Y1), ListOfPieces),
            getBoardSize(Board, N, M),
            between(1, N, X1),   % Assuming N is the width of the board
            between(1, M, Y1),   % Assuming M is the height of the board
            between(1, N, X2),
            between(1, M, Y2),
            MoveType is 0,
            valid_move((Player, X1, Y1), (MoveType, X2, Y2), Board)
        ),
        ListOfMoves
    ).





/*
valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    findall(((Player, X1, Y1), (MoveType, X2, Y2)), valid_move((Player, X1, Y1), (MoveType, X2, Y2), Board), ListOfMoves).
*/


/*
valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    findall(
        ((Player, X1, Y1), (MoveType, X2, Y2)),
        (   
            getBoardSize(Board, N, M),
            between(1, N, X1),   % Assuming N is the width of the board
            between(1, M, Y1),   % Assuming M is the height of the board
            checkSquareType(X1, Y1, Player, Board),
            between(1, N, X2),
            between(1, M, Y2),
            MoveType is 0, 
            valid_move((Player, X1, Y1), (MoveType, X2, Y2), Board)
        ),
        ListOfMoves
    ).
    */
