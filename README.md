
# Five-by-five IOS Game

The objective of the game is to fill the 5 by 5 grid with numbers from 1 to 25. You can start from any cell, and there are two rules each move has to follow:

if moving to north, east, south or west, the target cell has to be empty and behind two cells (empty or non-empty),
if moving north-east, south-east, south-west or north-west, the target cell has to be empty and behind one cell.
The app gives hints about the valid next moves showing question marks on valid target cells.

When there's no choices for next move (all potential target cells are filled), the game is over.

# Motivation

This is an iOS implementation of the Five-by-Five game I also made for Android. To get a taste of Objective-C.
