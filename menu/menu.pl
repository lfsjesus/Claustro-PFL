:- consult('menu_display.pl').

/* mainMenu
*/
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
                                                                  

/* Process menu choice.
*  execMenuChoice(+Choice)
*/
execMenuChoice(0) :- quitGame.
execMenuChoice(1) :- setGame(p-p). % playerVsPlayer.
execMenuChoice(2) :- playerVsBot.
execMenuChoice(3) :- botVsBot.
execMenuChoice(4) :- instructions.

/* Maps the player choice to the game mode.
*  mapPlayer(+Num, +Level, -Mode)
*/
mapPlayer(0, p, p-p).
mapPlayer(1, e, p-e).
mapPlayer(1, h, p-h).

/* Ask who starts the game in player vs bot mode.
*  askWhoStarts(+Mode, -FirstPlayer)
*/
askWhoStarts(p-e, FirstPlayer) :- 
    clear,
    menuH1('Who starts?'),
    menunl,
    menuHeaders('-Options-', '-Description-'),
    menunl,
    menuChoice(0, 'Player'),
    menuChoice(1, 'Bot'),
    menunl,
    menuFill, nl,
    readInputBetween(0, 1, Num),
    mapPlayer(Num, FirstPlayer, p-e).
    

askWhoStarts(p-h, FirstPlayer) :- 
    clear,
    menuH1('Who starts?'),
    menunl,
    menuHeaders('-Options-', '-Description-'),
    menunl,
    menuChoice(0, 'Player'),
    menuChoice(1, 'Bot'),
    menunl,
    menuFill, nl,
    readInputBetween(0, 1, Num),
    mapPlayer(Num, FirstPlayer, p-h).  

askWhoStarts(P1-_, P1). % botVsBot

/* Sets the game.
*  setGame(+Mode)
*/
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
    askWhoStarts(Mode, FirstPlayer),
    gameInit(N, M, Mode, FirstPlayer),
    fail. 


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

/* Maps the bot difficulty choice to the bot difficulty.
*  mapBotDifficulty(+Num, -Difficulty)
*/
mapBotDifficulty(1, e). % easy
mapBotDifficulty(2, h). % hard

/* Asks the user to choose the bot difficulty.
*  chooseBotDifficulty(+Text, -Choice)
*/
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
    readInputBetween(1, 2, Num),
    mapBotDifficulty(Num, Choice).
