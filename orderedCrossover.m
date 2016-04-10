function [c1, c2] = orderedCrossover(p1,p2)

%Zasadê dzia³ania tego operatora krzy¿owania ilustruje przyk³ad:
% p1 = [1 2 3 4 5 6]; p2 = [6 5 4 3 2 1];
% Losujemy dwa miejsca krzy¿owania: np. pozycja 3 i pozycja 5, wtedy:
% c1 = [1 2 5 4 3 6]; c2 = [6 3 4 5 2 1];
%(liczby miêdzy miejscami krzy¿owania w c1 nale¿y przepisaæ w kolejnoœci
% w jakiej wystêpuj¹ w p2; te same liczby nale¿y przepisaæ do c2 w
% kolejnoœci w jakiej wystêpuj¹ w p1)