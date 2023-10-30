showInstructions :-
    menuString('------------------------ Game Board ------------------------'),
    menunl,
    menuString('The game board is a NxM grid, where N and M are'),
    menuString('integers between 5 and 10, inclusive.'),
    menuString('The board is square, but placed on a diamond.'),
    menuString('Each corner of the diamond is each player\'s home'),
    menuString('goal. The left and right corners are not used.'),
    menunl,

    menuString('-------------------------- Pieces --------------------------'),
    menunl,
    menuString('The players are Green and Blue, and take turns.'),
    menuString('Each player has (N - 2) + (M - 2) pieces.'),
    menuString('(N - 2) pieces are placed in line on N side'),
    menuString('of the opponent\'s goal, and (M - 2) on the M side.'),
    menunl,

    menuString('------------------------- Gameplay -------------------------'),
    menunl,
    menuString('Each player takes turns moving one of their pieces.'),
    menuString('A player can perform one of two actions:'),
    menuString('  - Move a piece one square orthogonally, if the'),
    menuString('    square is empty.'),
    menuString('  - Capture an opponent\'s piece by jumping over it'),
    menuString('    and placing the captured piece anywhere on the'),
    menuString('    board.'),
    menunl,
    menuString('The game ends when one of the condition satisfies:'),
    menuString('  - Player puts one of his pieces in the opponent\'s'),
    menuString('    goal.'),
    menuString('  - Player cannot take any action, winning the game.'),
    menuString('  - Both players repeat the same board state 3 times.'),
    menuString('    The player who moved last wins.'),
    menunl.