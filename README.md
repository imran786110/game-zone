# Game Zone

A collection of browser-based games including Sudoku and Tetris.

## Project Structure

```
game-zone/
├── src/           # HTML game files
│   ├── index.html
│   ├── docs.html
│   ├── sudoku.html
│   └── tetris.html
└── iac/           # Terraform infrastructure code
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    └── README.md
```

## Games

### Sudoku
A simple, single-file HTML sudoku game that runs entirely in the browser.

## Features

- 9x9 sudoku grid with pre-filled puzzle
- Input validation (only accepts numbers 1-9)
- Visual feedback for correct/incorrect answers
- Timer to track your solving time
- Pause/Resume functionality
- Auto-save game state (continues where you left off)
- Interactive popup messages for win/fail states

## How to Play

1. Open `sudoku.html` in any web browser
2. Click on empty cells and enter numbers 1-9
3. Use "Pause" to pause the timer and disable input
4. Click "Check" to validate your solution
5. Click "New Game" to reset the puzzle and timer

## Technical Details

- Pure HTML/CSS/JavaScript - no dependencies
- Responsive grid layout
- Fixed cells are highlighted in gray
- Green/red highlighting shows correct/incorrect answers when checking
- Uses localStorage to save game progress and timer state
- Modal popup for game results

## Requirements

Any modern web browser (Chrome, Firefox, Safari, Edge)
