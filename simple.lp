% Simple - assuming people see each others cards

% ACHIEVED - there are 37 cards with 8 of each type except the ring type
card(mountain,1..8;forest,1..8;hill,1..8;shadow,1..8;ring,1..5).
% ACHIEVED - there are 4 players
player(1..4).
% ACHIEVED - there are 4 characters
character(rodo;amwise;andalf;ipin).

% ACHIEVED - every player plays 1 unique character
1 { player_character(P,C) : character(C) } 1 :- player(P).
:- player_character(P,C), player_character(P2,C), P != P2.

