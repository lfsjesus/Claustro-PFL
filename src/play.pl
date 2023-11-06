
:- consult('menu/menu.pl').
:- consult('io.pl').
:- consult('board/board.pl').
:- consult('board/logic.pl').
:- consult('game/game_io.pl').
:- consult('game/display.pl').
:- consult('game/game.pl').


% Play predicate that starts the game
play :- mainMenu.