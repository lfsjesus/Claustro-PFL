
odd(N) :- 
    N mod 2 =:= 1.

takeN(_, 0, []).
takeN([], _, []).
takeN([X|Xs], N, [X|Ys]) :-
    N > 0,
    N1 is N - 1,
    takeN(Xs, N1, Ys).

evenAndOdd([], [], []).
evenAndOdd([O], [O], []).
evenAndOdd([O, E | Rest], [O | ORest], [E | ERest]) :-
    evenAndOdd(Rest, ORest, ERest).

getLastMoveHistory(List, Even, Odd) :-
    evenAndOdd(List, Odd1, Even1),
    takeN(Even1, 3, Even),
    takeN(Odd1, 3, Odd).

greenOrBlue((Turn, _, _), Player) :-
    greenOrBlue(Turn, Player).

greenOrBlue(Turn, green) :-
    odd(Turn).

greenOrBlue(Turn, blue) :-
    \+odd(Turn).


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
    length(ListOfMoves, 0),
    nl,
    write('No more moves for blue!'), nl.

gameOver((Turn, _, Board), green) :-
    valid_moves((Turn, _, Board), green, ListOfMoves),
    length(ListOfMoves, 0),
    nl,
    write('No more moves for green!'), nl.


gameOver((_, MoveHistory, _), Player) :-
    length(MoveHistory, N),
    N >= 6,
    getLastMoveHistory(MoveHistory, GreenMoves, BlueMoves),
    checkSameMoves(GreenMoves),
    checkSameMoves(BlueMoves),
    nth1(1, MoveHistory, ((Player, _, _), (_, _, _))),
    nl,
    write('Same moves 3 times in a row! The last player that moved wins!'), nl.


checkSameMoves(UserMoves) :-
    nth1(1, MoveHistory, ((_, X, Y), (_, X1, Y1))),
    nth1(2, MoveHistory, ((_, X2, Y2), (_, X3, Y3))),
    nth1(3, MoveHistory, ((_, X4, Y4), (_, X5, Y5))),

    XDir1 is X1 - X,
    YDir1 is Y1 - Y,

    XDir2 is X3 - X2,
    YDir2 is Y3 - Y2,

    XDir3 is X5 - X4,
    YDir3 is Y5 - Y4,

    XDir1 =:= XDir2,
    XDir2 =:= XDir3,

    YDir1 =:= YDir2,
    YDir2 =:= YDir3.



    






    





((Color, X, Y), (MoveType, X1, Y1))

checkMovesDifferent((_, X, Y), (_, X1, Y1)) :-
    XDir is X1 - X,
    YDir is Y1 - Y,


piecesOf(Player, Board, ListOfPieces) :-
    getBoardSize(Board, N, M),
    findall(
        (Player, X, Y),
        (
        checkSquareType(X, Y, Player, Board)
        ),
        ListOfPieces
    ).


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
            checkSquareType(X1, Y1, Player, Board),
            valid_move((Player, X1, Y1), (0, X2, Y2), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((Player, X1, Y1), (1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
            valid_move((Player, X1, Y1), (1, X2, Y2), Board)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves0, ListOfMoves1, ListOfMoves2),
    sort(ListOfMoves2, ListOfMoves).


% valid moves for piece
valid_moves_piece((Turn, _, Board), (Player, X1, Y1), ListOfMoves) :-
    greenOrBlue(Turn, Player),
    getBoardSize(Board, N, M),
    findall(
        ((0, X2, Y2)),
        (       
            checkSquareType(X1, Y1, Player, Board),
            valid_move((Player, X1, Y1), (0, X2, Y2), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
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
    Distance is X_Dist + Y_Dist + 1.


distance(X, Y, blueGoal, Board, Distance) :-
    getBoardSize(Board, N, M),
    X_Dist is X - 1,
    Y_Dist is M - Y,
    Distance is X_Dist + Y_Dist + 1.

%furthest empty square from goal
furthestPosition(Player, (_,_,Board), X, Y) :-
    goal(Player, Goal),
    getBoardSize(Board, N, M),
    findall(
        Distance-(X1,Y1),
        (
            checkSquareType(X1, Y1, empty, Board),
            distance(X1, Y1, Goal, Board, Distance)
        ),
        PositionsDistancesPairs
    ),
    keysort(PositionsDistancesPairs, SortedPairs),
    sort(SortedPairs, SortedPairs2), % remove duplicates
    last(SortedPairs2, HighestDistance-_),
    findall(
        (X1,Y1),
        (
            member(Distance-(X1,Y1), SortedPairs2),
            Distance =:= HighestDistance
        ),
        BestPositions
    ),
    random_member((X,Y), BestPositions).



moveScore((Player, X1, Y1), (0, X2, Y2), Board, Score) :-
    goal(Player, Goal),
    distance(X2, Y2, Goal, Board, Distance),
    Distance > 0,
    Score is 1 / Distance.

moveScore((Player, X1, Y1), (1, X2, Y2), Board, Score) :-
    goal(Player, Goal),
    distance(X2, Y2, Goal, Board, Distance),
    Distance > 0,
    DistanceScore is (1 / Distance * 0.9),
    CaptureScore is 0.1,
    Score is DistanceScore + CaptureScore.


mostValueableMove((Turn, _, Board), (Player, X1, Y1), (MoveType, X2, Y2)) :-
    greenOrBlue(Turn, Player),
    getBoardSize(Board, N, M),
    findall(
        Score-((Player, X1, Y1), (0, X2, Y2)),
        (    
            checkSquareType(X1, Y1, Player, Board),
            valid_move((Player, X1, Y1), (0, X2, Y2), Board),
            moveScore((Player, X1, Y1), (0, X2, Y2), Board, Score)
        ),
        ListOfMoves0
    ),
    findall(
        Score-((Player, X1, Y1), (1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
            valid_move((Player, X1, Y1), (1, X2, Y2), Board),
            moveScore((Player, X1, Y1), (1, X2, Y2), Board, Score)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves1, ListOfMoves0, ListOfMoves2),
    keysort(ListOfMoves2, SortedMoves), % sort by score
    sort(SortedMoves, ListOfMoves), % remove duplicates
    last(ListOfMoves, HighestScore-_),
    findall(
        ((Player, X1, Y1), (MoveType, X2, Y2)),
        (
            member(Score-((Player, X1, Y1), (MoveType, X2, Y2)), ListOfMoves),
            Score =:= HighestScore
        ),
        BestMoves
    ),
    random_member(((Player, X1, Y1), (MoveType, X2, Y2)), BestMoves).
        



sum_list([], 0).
sum_list([Head|Tail], TotalSum) :-
   sum_list(Tail, SumTail),
   TotalSum is Head + SumTail.


value((Turn, _, Board), Player, Value) :-
    opponent(Player, Opponent),
    getBoardSize(Board, N, M),
    findall(
        Score,
        (   
            checkSquareType(X, Y, Player, Board),
            distance(X, Y, Player, Board, Distance),
            Score is (1 / Distance) 
        ),
        ListOfScores
    ),
    piecesOf(Opponent, Board, ListOfOpponentPieces),
    findall(
        Score,
        (   
            checkSquareType(X, Y, Opponent, Board),
            distance(X, Y, Opponent, Board, Distance),
            Score is (1 / Distance) * -1 
        ),
        ListOfOpponentScores
    ),
    append(ListOfScores, ListOfOpponentScores, ListOfAllScores),
    sum_list(ListOfAllScores, Value).

    