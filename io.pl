:- use_module(library(lists)).
:- use_module(library(between)).

% Clears the terminal screen
clear :- write('\e[2J').

/****MENU IO****/
menuH1(Title) :-
    format('~n~`*t ~p ~`*t~75|~n', [Title]).

menuString(String) :-
    format('*~t~p~t*~75|~n', [String]).    

menuHeaders(Options, Descriptions) :-
    format('*~t~p~t~37+~t~p~t~37+~t*~75|~n', [Options, Descriptions]).

menunl :-
    format('*~t*~75|~n', []).


menuChoice(Option, Description) :-
    format('*~t~p~t~37|~t~p~t~37+~t*~75|~n', [Option, Description]).

menuFill :-
    format('~`*t~75|~n', []).


readNumber(X) :- readNumber(X, 0).

readNumber(X, X) :-
    peek_code(10), !,
    skip_line.

readNumber(X, Acc) :-
    get_code(C),
    C >= 48, C =< 57,
    NewAcc is Acc * 10 + C - 48,
    readNumber(X, NewAcc).


readInputBetween(Min, Max, Input) :-
    format('Select an option [~d-~d]: ', [Min, Max]),
    readNumber(Input),
    between(Min, Max, Input), !.

readInputBetween(Min, Max, Input) :-
    format('Invalid input. Please select an option between ~d and ~d.~n', [Min, Max]),
    readInputBetween(Min, Max, Input).
