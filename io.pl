% Clears the terminal screen
clear :- write('\e[2J').

/****MENU IO****/
menuH1(Title) :-
    format('~n~`*t ~p ~`*t~75|~n', [Title]).

menuHeaders(Options, Descriptions) :-
    format('*~t~p~t~37+~t~p~t~37+~t*~75|~n', [Options, Descriptions]).

menunl :-
    format('*~t*~75|~n', []).


menuChoice(Option, Description) :-
    format('*~t~p~t~37|~t~p~t~37+~t*~75|~n', [Option, Description]).

menuFill :-
    format('~`*t~75|~n', []).
