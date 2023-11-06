
/* Checks if N is odd.
*  odd(+N)
*/
odd(N) :- 
    N mod 2 =:= 1.

/* Gets N first elements of a list.
*  takeN(+List, +N, -Result)
*/
takeN(_, 0, []).
takeN([], _, []).
takeN([X|Xs], N, [X|Ys]) :-
    N > 0,
    N1 is N - 1,
    takeN(Xs, N1, Ys).

/* Retrieves elements in even and odd positions of a list.
*  evenAndOdd(+List, -Even, -Odd)
*/
evenAndOdd([], [], []).
evenAndOdd([O], [O], []).
evenAndOdd([O, E | Rest], [O | ORest], [E | ERest]) :-
    evenAndOdd(Rest, ORest, ERest).

/* Gets the relevant move history. According to the rules, only the last 3 need to be checked.
*  getLastMoveHistory(+MoveHistory, -Even, -Odd)
*/
getLastMoveHistory(List, Even, Odd) :-
    evenAndOdd(List, Odd1, Even1),
    takeN(Even1, 3, Even),
    takeN(Odd1, 3, Odd).

/* Checks whether it's green's turn or blue's turn according to the turn number.
*  greenOrBlue(+Turn, -Player)
*/
greenOrBlue((Turn, _, _), Player) :-
    greenOrBlue(Turn, Player).

greenOrBlue(Turn, green) :-
    odd(Turn).

greenOrBlue(Turn, blue) :-
    \+odd(Turn).

/* Maps the opponent of a player/color.
*  opponent(+Player, -Opponent)
*/
opponent(blue, green).
opponent(green, blue).

/* Maps the goal of a player/color.
*  goal(+Player, -Goal)
*/ 
goal(blue, blueGoal).
goal(green, greenGoal).

/* Defines allowed "regular" move directions for each color/player according to the rules.
*  move_direction(+Color, -XOffset, -YOffset)
*/
move_direction(blue, -1, 0).  % Move to the left
move_direction(blue, 0, 1).   % Move down
move_direction(green, 1, 0).  % Move to the right
move_direction(green, 0, -1). % Move up

/* Checks if a piece of a certain player/color can be moved from (X1, Y1) to (X2, Y2).
*  canMove(+Player, +X1, +Y1, +X2, +Y2, +Board)  
*/
canMove(Player, X1, Y1, X2, Y2, Board) :-
    move_direction(Player, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    checkSquareType(X2, Y2, empty, Board).

canMove(Player, X1, Y1, X2, Y2, Board) :-
    move_direction(Player, XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    goal(Player, Goal),
    checkSquareType(X2, Y2, Goal, Board).
       

/* Check whether a piece is stuck or not, this is, if it can move or capture.
*  pieceNotStuck(+Move, +Board)
*/
pieceNotStuck((Player, X, Y), Board) :-
    valid_move(((Player, X, Y), (_, _, _)), Board).


/* Defines allowed capture directions according to the rules. Both players can capture in the same directions.
*  capture_direction(+XOffset, +YOffset)
*/
capture_direction(1, -1).  
capture_direction(1, 1).
capture_direction(-1, -1).  
capture_direction(-1, 1).   

/* Checks if a piece of a certain player/color can capture the piece in (X2, Y2).
*
*/
canCapture(Player, X1, Y1, X2, Y2, Board) :-
    opponent(Player, Opponent),
    capture_direction(XOffset, YOffset),
    X2 is X1 + XOffset,
    Y2 is Y1 + YOffset,
    checkSquareType(X2, Y2, Opponent, Board).

/* Checks if the game is over. No tie is possible. 
*  Check the instructions to understand game over conditions.
*  gameOver(+GameState, -Winner)
*/
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

/* Checks if the last 3 user move directions are the same, since it's one of the game over conditions.
*  checkSameMoves(+UserMoves)
*/
checkSameMoves(UserMoves) :-
    nth1(1, UserMoves, ((_, X, Y), (_, X1, Y1))),
    nth1(2, UserMoves, ((_, X2, Y2), (_, X3, Y3))),
    nth1(3, UserMoves, ((_, X4, Y4), (_, X5, Y5))),

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

/* Gets the pieces of a certain player/color in a list.
*  piecesOf(+Player, +Board, -ListOfPieces)
*/
piecesOf(Player, Board, ListOfPieces) :-
    findall(
        (Player, X, Y),
        (
        checkSquareType(X, Y, Player, Board)
        ),
        ListOfPieces
    ).

/* Checks if a move/capture (0/1) is valid.
*  valid_move(+Move, +Board)
*/
valid_move(((Player, X1, Y1), (0, X2, Y2)), Board) :- 
    canMove(Player, X1, Y1, X2, Y2, Board).

valid_move(((Player, X1, Y1), (1, X2, Y2)), Board) :-
    canCapture(Player, X1, Y1, X2, Y2, Board).

/* Gets all valid moves for a player/color in a list.
*  valid_moves(+GameState, +Player, -ListOfMoves)
*/
valid_moves((Turn, _, Board), Player, ListOfMoves) :-
    greenOrBlue(Turn, Player),
    findall(
        ((Player, X1, Y1), (0, X2, Y2)),
        (     
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (0, X2, Y2)), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((Player, X1, Y1), (1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (1, X2, Y2)), Board)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves0, ListOfMoves1, ListOfMoves2),
    sort(ListOfMoves2, ListOfMoves).


/* Gets all valid moves for a piece in a list.
*  valid_moves_piece(+GameState, +Piece, -ListOfMoves)
*/
valid_moves_piece((Turn, _, Board), (Player, X1, Y1), ListOfMoves) :-
    greenOrBlue(Turn, Player),
    findall(
        ((0, X2, Y2)),
        (       
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (0, X2, Y2)), Board)
        ),
        ListOfMoves0
    ),
    findall(
        ((1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (1, X2, Y2)), Board)
        ),
        ListOfMoves1
    ),
    append(ListOfMoves0, ListOfMoves1, ListOfMoves2),
    sort(ListOfMoves2, ListOfMoves).

/* Calculates the distance of a square with X and Y coordinates to a goal (green or blue).
*
*/
distance(X, Y, greenGoal, Board, Distance) :-
    getBoardSize(Board, N, _),
    X_Dist is N - X,
    Y_Dist is Y - 1,
    Distance is X_Dist + Y_Dist + 1.


distance(X, Y, blueGoal, Board, Distance) :-
    getBoardSize(Board, _, M),
    X_Dist is X - 1,
    Y_Dist is M - Y,
    Distance is X_Dist + Y_Dist + 1.

/* Calculates the square with the furthest distance to a goal (green or blue). For greedy bot.
*  furthestPosition(+Player, +GameState, -X, -Y)
*/
furthestPosition(Player, (_,_,Board), X, Y) :-
    goal(Player, Goal),
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


/* Calculates the score of a move. For greedy bot. In case of a normal move, less distance to the goal is better.
*  If the move is a capture, the score is 0.1 (capture) + 0.9 (distance to goal).
*  moveScore(+Move, +Board, -Score)
*/
moveScore(((Player, _, _), (0, X2, Y2)), Board, Score) :-
    goal(Player, Goal),
    distance(X2, Y2, Goal, Board, Distance),
    Distance > 0,
    Score is 1 / Distance.

moveScore(((Player, _, _), (1, X2, Y2)), Board, Score) :-
    goal(Player, Goal),
    distance(X2, Y2, Goal, Board, Distance),
    Distance > 0,
    DistanceScore is (1 / Distance * 0.9),
    CaptureScore is 0.1,
    Score is DistanceScore + CaptureScore.

/* Returns the most valuable move for a player/color. For greedy bot.
*  mostValueableMove(+GameState, -Move)
*/
mostValueableMove((Turn, _, Board), ((Player, X1, Y1), (MoveType, X2, Y2))) :-
    greenOrBlue(Turn, Player),
    findall(
        Score-((Player, X1, Y1), (0, X2, Y2)),
        (    
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (0, X2, Y2)), Board),
            moveScore(((Player, X1, Y1), (0, X2, Y2)), Board, Score)
        ),
        ListOfMoves0
    ),
    findall(
        Score-((Player, X1, Y1), (1, X2, Y2)),
        (        
            checkSquareType(X1, Y1, Player, Board),
            valid_move(((Player, X1, Y1), (1, X2, Y2)), Board),
            moveScore(((Player, X1, Y1), (1, X2, Y2)), Board, Score)
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
        


/* Performs the sum of a list of numbers.
*  sum_list(+List, -TotalSum)
*/
sum_list([], 0).
sum_list([Head|Tail], TotalSum) :-
   sum_list(Tail, SumTail),
   TotalSum is Head + SumTail.

/* COmputes the value of a board for a player/color. For greedy bot.
*  value(+GameState, +Player, -Value)
*/
value((_, _, Board), Player, Value) :-
    opponent(Player, Opponent),
    findall(
        Score,
        (   
            checkSquareType(X, Y, Player, Board),
            distance(X, Y, Player, Board, Distance),
            Score is (1 / Distance) 
        ),
        ListOfScores
    ),
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

    