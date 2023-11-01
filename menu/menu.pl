:- consult('menu_display.pl').

mainMenu :-
    %repeat, 
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
execMenuChoice(1) :- setGame(p-p). % playerVsPlayer.
execMenuChoice(2) :- playerVsBot.
execMenuChoice(3) :- botVsBot.
execMenuChoice(4) :- instructions.


setGame(Mode) :-
    clear,
    menuH1('Choose a board size'),
    menunl,
    menuString('Choose width N: '),
    menunl,
    menuFill, nl,

    readInputBetween(5, 10, N),
    clear,
    menuH1('Choose a board size'),
    menunl,
    menuString('Choose height M: '),
    menunl,
    menuFill, nl,

    readInputBetween(5, 10, M),
    gameInit(N, M, Mode),
    fail. % If something is failing unexpectedly, CHECK THIS LINE.


/**
* Menus
*/
quitGame :- 
    clear, nl,
    menuFill, 
    menuH1('Thanks for playing!'), nl,
    menuFill.


playerVsBot :- 
    chooseBotDifficulty('Choose bot difficulty', Choice),
    setGame(p-Choice).

botVsBot :- 
    chooseBotDifficulty('Choose bot 1 difficulty', Choice1),
    chooseBotDifficulty('Choose bot 2 difficulty', Choice2),
    setGame(Choice1-Choice2).

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


chooseBotDifficulty(Text, Choice) :-
    clear,
    menuH1('Choose bot difficulty'),
    menunl,
    menuString(Text),
    menunl,
    menuHeaders('-Options-', '-Description-'),
    menunl,
    menuChoice(1, 'Easy - Random moves'),
    menuChoice(2, 'Hard - Greedy moves'),
    menunl,
    menuFill, nl,
    readInputBetween(1, 2, Choice).
