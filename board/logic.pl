:- use_module(library(between)).

% Can Move From (X1,Y1) -> (X2,Y2)


% Define opponents and move directions for each color
opponent(blue, green).
opponent(green, blue).

goal(blue, blueGoal).
goal(green, greenGoal).

move_direction(blue, -1, 0).  % Move to the left
move_direction(blue, 0, 1).   % Move down
move_direction(green, 1, 0).  % Move to the right
move_direction(green, 0, -1). % Move up

% Can move from (X1, Y1) -> (X2, Y2)
canMove(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    move_direction(Color, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    checkSquareType(X2, Y2, empty, Board).

% Can move from (X1, Y1) -> (X2, Y2) to a goal square
canMove(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    move_direction(Color, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    goal(Color, Goal),
    checkSquareType(X2, Y2, Goal, Board).
       


% Define opponents for each color
opponent(blue, green).
opponent(green, blue).

% Define the possible capture directions
capture_direction(1, -1).  % (X + 1, Y - 1)
capture_direction(2, -1).  % (X + 1, Y + 1)
capture_direction(3, 1).   % (X - 1, Y - 1)
capture_direction(4, 1).   % (X - 1, Y + 1)

% Can capture from (X1,Y1) -> (X2,Y2)
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    capture_direction(Direction, YOffset),
    X2 is X1 + Direction,
    Y2 is Y1 + YOffset,
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
        checkSquareType(X, Y, Player, Board),
        ListOfPieces
    ).

valid_move((Player, X1, Y1), (0, X2, Y2), Board) :- 
    canMove(Player, X1, Y1, X2, Y2, Board).

valid_move((Player, X1, Y1), (1, X2, Y2), Board) :-
    canCapture(Player, X1, Y1, X2, Y2, Board).


valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    piecesOf(Player, Board, ListOfPieces),
    findall(
        ((Player, X1, Y1), (0, X2, Y2)),
        (
            member((Player, X1, Y1), ListOfPieces),
            getBoardSize(Board, N, M),
            valid_move((Player, X1, Y1), (0, X2, Y2), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((Player, X1, Y1), (1, X2, Y2)),
        (
            member((Player, X1, Y1), ListOfPieces),
            getBoardSize(Board, N, M),
            valid_move((Player, X1, Y1), (1, X2, Y2), Board)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves0, ListOfMoves1, ListOfMoves2),
    sort(ListOfMoves2, ListOfMoves).








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
