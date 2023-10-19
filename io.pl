% Clears the terminal screen
clear :- write('\e[2J').

/****MENU IO****/
% Documentation of format/2: https://sicstus.sics.se/sicstus/docs/latest4/html/sicstus.html/mpg_002dref_002dformat.html

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
