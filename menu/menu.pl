:- consult('menu_display.pl').

mainMenu :-
    repeat,
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
    menuChoice(0, 'Exit'),
    menunl,
    menuFill, nl,
    
    readInputBetween(0, 4, Num),
    execMenuChoice(Num).


/**
 *
 * Then process menu choices
 */

execMenuChoice(0) :- quitGame.
/*execMenuChoice(1) :- player vs player*/
execMenuChoice(2) :- playerVsBot.
execMenuChoice(3) :- botVsBot.
execMenuChoice(4) :- instructions.



/**
* Menus
*/
quitGame :- 
    clear, nl,
    menuFill, 
    menuH1('Thanks for playing!'), nl,
    menuFill.

/* playerVsPlayer :- */

/* playerVsBot :- */

/* botVsBot :- */


/* chooseBotDifficulty(...) :- */


instructions :-
    clear,
    menuH1('Instructions'),
    menunl,
    showInstructions,
    menunl,
    menuFill, nl,
    write('Press any key to return to the main menu...'), nl,
    skip_line,
    fail.

