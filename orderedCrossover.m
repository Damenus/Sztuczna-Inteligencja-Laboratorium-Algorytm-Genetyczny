function [c1, c2] = orderedCrossover(p1,p2)

%Zasad� dzia�ania tego operatora krzy�owania ilustruje przyk�ad:
% p1 = [1 2 3 4 5 6]; p2 = [6 5 4 3 2 1];
% Losujemy dwa miejsca krzy�owania: np. pozycja 3 i pozycja 5, wtedy:
% c1 = [1 2 5 4 3 6]; c2 = [6 3 4 5 2 1];
%(liczby mi�dzy miejscami krzy�owania w c1 nale�y przepisa� w kolejno�ci
% w jakiej wyst�puj� w p2; te same liczby nale�y przepisa� do c2 w
% kolejno�ci w jakiej wyst�puj� w p1)