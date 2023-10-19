mainMenu :-
    clear,
    menuH1('CLAUSTRO'),
    menunl,
    menuHeaders('-Options-', '-Description-'),
    menunl,
    menuChoice(1, 'Player vs Player'),
    menuChoice(2, 'Player vs Bot'),
    menuChoice(3, 'Bot vs Bot'),
    menuChoice(4, 'Instructions'),
    menunl,
    menuOption(0, 'Exit'),
    menunl,
    menuFill, nl.

/**
 *
 * Then process menu choices
 */


