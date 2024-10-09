# Tictactoe thing
Minimalist implementation of Tic-Tac-Toe in Elixir/Phoenix. It includes a short link system that allows easily joining a match and a chat between players. Uses LiveSvelte to handle real-time changes to the game state through LiveView sockets.

Hosted at https://tictactoe-thing.rekkice.dev/

## Key Features
- Real-time, low latency interactions between 2 players
- Short link generation
- In-match chat

## Technologies Used
- Elixir & Phoenix (for backend)
- WebSockets (for real-time communication)
- Svelte (for frontend UI functionality)
- Tailwind CSS (for frontend styling)

## Usage

To start the Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser. Make sure a postgres instance is running.

![image](https://github.com/user-attachments/assets/9da50eda-51f0-4c1b-b0d4-86bb5895cd60)

## Future Features
- Ask for rematch after a match finishes
