# Claustro

Luís Filipe da Silva Jesus - up202108683
<br>
Miguel Diogo Andrade Rocha - up202108720


## Game Description

### Board

Claustro uses a 5x5 board/grid. Typically, the board is diagonally oriented between the **two players**. The two corners closest to each player are each other players' goal. 

The other two corners of the board are neutral zones, where no pieces can be placed.

### Pieces

Each player has 4 pieces. Initially, each pair of pieces is placed next to each other starting in each square orthogonally adjacent to the player starting corner.

<p align="center">
  <img src="assets/board.png" width="300" title="Claustro Initial Board">
</p>

To disinguish between the two players, each player has a different color, for example, green and blue.

### Gameplay

Players take turns moving one of their pieces. In each turn, a player can move one of its pieces in the following ways:

- **Move**: Move a piece one square orthoganally towards the goal (considering it is not occupied).

- **Capture**: Captures are made by jumping one square (where there is an opponent's piece) diagonally. The captured piece is **not removed** from the board, but placed in any of the other free squares in the board, by the player who captured it, before the next turn.

<p align="center">
  <img src="assets/gameplay.png" width="300" title="Claustro Gameplay">
</p>

This procedure shall be repeated until one of the following conditions is met:
- A player successfully moves one of his pieces on his goal (opponent starting corner). In this case, he **wins the game.**

- A player cannot move nor capture opponent pieces with any of his pieces. In this case, he **wins the game.**

- Both players repeat the same move 3 times each. In this case, the last player to move **wins the game.**


