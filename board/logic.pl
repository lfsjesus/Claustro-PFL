:- use_module(between).



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
    move_direction(Color, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    checkSquareType(X2, Y2, empty, Board).

% Can move from (X1, Y1) -> (X2, Y2) to a goal square
canMove(Color, X1, Y1, X2, Y2, Board) :-
    move_direction(Color, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    goal(Color, Goal),
    checkSquareType(X2, Y2, Goal, Board).
       

% pieceNotStuck(+Piece, +Board)
pieceNotStuck((Player, X, Y), Board) :-
    valid_move((Player, X, Y), (_, X2, Y2), Board).


% Define opponents for each color
opponent(blue, green).
opponent(green, blue).

% Define the possible capture directions
capture_direction(1, -1).  % (X + 1, Y - 1)
capture_direction(1, 1).  % (X + 1, Y + 1)
capture_direction(-1, -1).   % (X - 1, Y - 1)
capture_direction(-1, 1).   % (X - 1, Y + 1)

% Can capture from (X1,Y1) -> (X2,Y2)
canCapture(Color, X1, Y1, X2, Y2, Board) :-
    opponent(Color, Opponent),
    capture_direction(XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    checkSquareType(X2, Y2, Opponent, Board).


gameOver((_, _, Board), blue) :-
    getBoardSize(Board, _, M),
    checkSquareType(1, M, blue, Board).

gameOver((_, _, Board), green) :-
    getBoardSize(Board, N, _),
    checkSquareType(N, 1, green, Board).

gameOver((Turn, _, Board), blue) :- 
    valid_moves((Turn, _, Board), blue, ListOfMoves),
    length(ListOfMoves, 0).

gameOver((Turn, _, Board), green) :-
    valid_moves((Turn, _, Board), green, ListOfMoves),
    length(ListOfMoves, 0).

/*
piecesOf(Player, Board, ListOfPieces) :-
    getBoardSize(Board, N, M),
    findall(
        (Player, X, Y),
        (between(1, N, X),
        between(1, M, Y),
        checkSquareType(X, Y, Player, Board)),
        ListOfPieces
    ).
*/

valid_move((Player, X1, Y1), (0, X2, Y2), Board) :- 
    canMove(Player, X1, Y1, X2, Y2, Board).

valid_move((Player, X1, Y1), (1, X2, Y2), Board) :-
    canCapture(Player, X1, Y1, X2, Y2, Board).


valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    getBoardSize(Board, N, M),
    findall(
        ((Player, X1, Y1), (0, X2, Y2)),
        (   
            between(1, N, X1),
            between(1, M, Y1),
            between(1, N, X2),
            between(1, M, Y2),       
            checkSquareType(X1, Y1, Player, Board),
            getBoardSize(Board, N, M),
            valid_move((Player, X1, Y1), (0, X2, Y2), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((Player, X1, Y1), (1, X2, Y2)),
        (        
            between(1, N, X1),
            between(1, M, Y1),
            between(1, N, X2),
            between(1, M, Y2),
            checkSquareType(X1, Y1, Player, Board),
            getBoardSize(Board, N, M),
            valid_move((Player, X1, Y1), (1, X2, Y2), Board)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves0, ListOfMoves1, ListOfMoves2),
    sort(ListOfMoves2, ListOfMoves).




distance(X, Y, greenGoal, Board, Distance) :-
    getBoardSize(Board, N, M),
    X_Dist is N - X,
    Y_Dist is Y - 1,
    Distance is X_Dist + Y_Dist.


distance(X, Y, blueGoal, Board, Distance) :-
    getBoardSize(Board, N, M),
    X_Dist is X - 1,
    Y_Dist is M - Y,
    Distance is X_Dist + Y_Dist.

%furthest empty square from goal
furthestPosition(Player, (_,_,Board), X, Y) :-
    goal(Player, Goal),
    getBoardSize(Board, N, M),
    findall(
        Distance-(X1,Y1),
        (
            between(1, N, X1),
            between(1, M, Y1),
            checkSquareType(X1, Y1, empty, Board),
            distance(X1, Y1, Goal, Board, Distance)
        ),
        PositionsDistancesPairs
    ),
    keysort(PositionsDistancesPairs, SortedPairs),
    last(SortedPairs, _-((X, Y))).



