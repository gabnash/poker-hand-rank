poker-hand-rank
===============

Ruby program to evaluate 5 card poker hands and generate a rank value 

Changes
=======
11 Dec 2012 Initial version

Outline
=======

For 5 card hands there are 52C5 = 2 598 960 unique hands. This program will generate a rank value for poker hands so that they can be easily and quickly compared.


Rank of hands: Royal Flush, Four of a kind, Full House, Flush, Straight, Three of a kind, Two pairs, Single pair, High card


This program should be able to generate a hand score for a flush that is higher than a straight, but give appropriate hand scores that distinguish between the various kinds within each type of hand e.g. a straight 8-Q is higher scoring than a straight 7-J.
