# Grid Masters
This is the project repository for the EE2026 Project for group S1-03.

Grid Masters is a Tic-Tac-Toe game running entirely on a Basys 3 Artix-7 FPGA. It comes with a fully-onboard artificial intelligence as an opponent.

## Controls
- Centre Button: Confirm selections
- Left Button: Reset to Title/Menu screen
- Right Button: Reset Round (only for 1 v 1 Mode)
- Switches: Select grid square to place move

## Game Modes
The game comes with 2 game modes.

### 1 v 1 Mode
This mode allows for 2 players to compete in Tic-Tac-Toe.

The 7-segment display will show the scoreboard. The first player to 3 wins will win the round.

### Vs AI Mode
This mode allows one player to compete against an AI.

There are three levels:
- Level 1: Randomised moves.
- Level 2: AI will try to achieve a win and block your win, but it cannot defend against a double threat.
- Level 3: AI can now defend against double threats. Designed to be unbeatable.

Level Progression:
- If you beat the AI in a level, you will progress to the next level.
- If you draw with the AI, you will remain on the same level.
- If you lose to the AI, you will restart from Level 1.

## References
This project makes use of the following sources and open-source libraries:

### [Bad Apple!! PV](https://www.nicovideo.jp/watch/sm8628149) - Anira (あにら) et. al.
This animation is commonly used in computing as a graphical and audio test.

Grid Masters uses three 5-second clips of the animation, seen in the Game Over screen in 1 v 1 Mode and the level result screen in Vs AI mode.

### [PixilArt](https://www.pixilart.com/)
Used to create some of the graphics for the game's UI.

### [Picture2Pixel](https://github.com/gu0y1/picture2pixel) - Chen Guoyi & Fang Sihan
Used to convert graphics into Verilog code for this project.

### [Super Pyxelate](https://github.com/sedthh/pyxelate) - Richard Nagyfi
Used to scale frames of Bad Apple into images with a height of 64 pixels, preparing them for bitmapping.

### [Python Imaging Library](https://omz-software.com/pythonista/docs/ios/PIL.html) (Not Pillow!)
Used to bitmap the images produced by Pyxelate into a 96x64 image, to be input into Picture2Pixel to ensure maximum efficiency of Verilog code.
