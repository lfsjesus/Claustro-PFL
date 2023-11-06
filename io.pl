:- use_module(library(lists)).
:- use_module(library(between)).

/* Clears the console
*
*/
clear :- write('\e[2J').

/* Menu Header formatted with 75 padding.
*  menuH1(+Title)
*/
menuH1(Title) :-
    format('~n~`-t ~p ~`-t~75|~n', [Title]).

/* Formats a menu string with 75 padding.
*  menuString(+String)
*/
menuString(String) :-
    format('-~t~p~t-~75|~n', [String]).    

/* Menu header to allow for 2 columns: options and descriptions.
*  menuHeaders(+Options, +Descriptions)
*/
menuHeaders(Options, Descriptions) :-
    format('-~t~p~t~37+~t~p~t~37+~t-~75|~n', [Options, Descriptions]).

/* Menu newline with 75 padding.
*/
menunl :-
    format('-~t-~75|~n', []).

/* Formats a 2 column menu choice with 75 padding.
*  menuChoice(+Option, +Description)SS
*/
menuChoice(Option, Description) :-
    format('-~t~p~t~37|~t~p~t~37+~t-~75|~n', [Option, Description]).

/* Menu fill with 75 padding.
*/
menuFill :-
    format('~`-t~75|~n', []).


/* readNumber(-X)
*
*/
readNumber(X) :- readNumber(X, 0).

readNumber(X, X) :-
    peek_code(10), !,
    skip_line.

readNumber(X, Acc) :-
    get_code(C),
    C >= 48, C =< 57,
    NewAcc is Acc * 10 + C - 48,
    readNumber(X, NewAcc).

/* Reads input between Min and Max. No need to write a period after the input.
*  readInputBetween(+Min, +Max, -Input)
*/
readInputBetween(Min, Max, Input) :-
    format('Select an option [~d-~d]: ', [Min, Max]),
    readNumber(Input),
    between(Min, Max, Input), !.

readInputBetween(Min, Max, Input) :-
    format('Invalid input. Please select an option between ~d and ~d.~n', [Min, Max]),
    readInputBetween(Min, Max, Input).

/* Press enter to continue.
*
*/
pressEnterToContinue :-
    write(' Press [ENTER] to continue...'), nl,
    get_char(_).    
