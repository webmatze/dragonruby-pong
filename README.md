# DragonRuby Pong

A modern implementation of the classic Pong game built with DragonRuby Game Toolkit.

## Description

This is a two-player Pong game featuring a progressive difficulty system. Players compete against each other trying to score points by getting the ball past their opponent's paddle.

## Features

- Classic two-player Pong gameplay
- Progressive difficulty system with 10 levels
- Dynamic ball and paddle speeds
- Score tracking
- Full screen gameplay
- Smooth controls

## How to Play

### Controls
- **Left Paddle:**
  - W: Move Up
  - S: Move Down

- **Right Paddle:**
  - ↑ (Up Arrow): Move Up
  - ↓ (Down Arrow): Move Down

### Scoring
- Score points by getting the ball past your opponent's paddle
- Every 5 points scored (combined between both players) increases the game level
- Higher levels increase both ball and paddle speeds for more challenging gameplay

### Level System
- Game starts at Level 1 with comfortable speeds
- Levels progress up to Level 10
- Each level increases:
  - Ball speed
  - Paddle movement speed
- Maximum speeds are capped to maintain playability

## Requirements

- DragonRuby Game Toolkit

## Installation

1. Clone this repository
2. Place the files in your DragonRuby project directory
3. Run the game using DragonRuby

## Development

This game was developed using DragonRuby Game Toolkit. The code is organized in a single main file (`app/main.rb`) and includes:
- Ball physics and movement
- Paddle controls
- Collision detection
- Score tracking
- Progressive difficulty system

## License

MIT License

## Credits

Created with DragonRuby Game Toolkit
