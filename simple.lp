% Simple - assuming people see each others cards

% ACHIEVED - there are 37 cards with 8 of each type except the ring type
card(mountain,1..8;forest,1..8;hill,1..8;shadow,1..8;ring,1..5).
% ACHIEVED - there are 4 players
player(1..4).
% ACHIEVED - there are 4 characters
character(frodo;samwise;gandalf;pippin).

% ACHIEVED - every player plays 1 unique character
1 { player_character(P,C) : character(C) } 1 :- player(P).
:- player_character(P,C), player_character(P2,C), P != P2.

% ACHIEVED - every player has 9 cards (Suit + Rank) unless they're gandalf (gandalf has a unique trait that gets the leftover card)
9 { player_card(P,S,R) : card(S,R) } 9 :- player(P), not player_character(P,gandalf).
10 { player_card(P,S,R) : card(S,R) } 10 :- player(P), player_character(P,gandalf).
% ACHIEVED - every card is dealt to at most one player
:- player_card(P,S,R), player_card(P2,S,R), P != P2.

% ACHIEVED - frodo is the player holding the one ring
:- player_character(P,frodo), not player_card(P,ring,1).

% Turn order

next(P,Q) :- player(P), Q = P\4+1.        % clockwise seating
pos(1..4).

turn(T,1,P)   :- leader(T,P).              % leader is first to play
turn(T,I+1,Q) :- turn(T,I,P), next(P,Q), I < 4, pos(I).

leader(1,P)   :- player_card(P,ring,1).    % holder of the One Ring leads trick 1
leader(T+1,W) :- wins(T,W), trick(T+1).    % winner leads the next

% Playing cards

% every player plays exactly 1 of their own cards in each trick
1 { plays(T,P,S,R) : player_card(P,S,R) } 1 :- player(P), trick(T).
% a given card can be played in at most 1 trick (no replaying a card)
:- player_card(P,S,R), #count{ T : plays(T,P,S,R) } > 1.

% a card is gone from a player's hand in trick T if they already played it in an earlier trick
gone(P,S,R,T)    :- plays(T2,P,S,R), trick(T), T2 < T.
% a card is still in hand for trick T if it wasn't already played before T
in_hand(P,S,R,T) :- player_card(P,S,R), trick(T), not gone(P,S,R,T).

% the suit led in a trick is the suit played by that trick's leader
led(T,S) :- plays(T,P,S,_), leader(T,P).
% a player must follow the led suit if they still hold a card of that suit
:- plays(T,P,S,_), led(T,L), S != L, in_hand(P,L,_,T).   % follow suit if able


