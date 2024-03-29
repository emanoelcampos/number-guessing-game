# Number Guessing Game

This project is a result of my learning journey through the [Relational Database certification course](https://www.freecodecamp.org/learn/relational-database/) offered by freeCodeCamp. The project, named "Number Guessing Game", is a terminal-based game where the user guesses a secret number. The game is implemented using Bash scripting and PostgreSQL for data management. The user's game data is stored and retrieved using PostgreSQL, and the game logic is implemented in Bash. The project is version controlled using Git.

## Database Diagram

![number-guess-database-diagram.svg](images%2Fnumber-guess-database-diagram.svg)

This diagram provides a visual representation of the database structure, including tables and relationships between them.

## Script Analysis

The `number_guess.sh` script is the heart of the Number Guessing Game. Here's a brief overview of what it does:

1. `GAME_START`: This function starts the game. It prompts the user for their username and checks if the user exists in the database. If the user exists, it calls the `USER` function; otherwise, it calls the `NEW_USER` function.

2. `GUESS_NUMBER`: This function handles the game logic. It prompts the user to guess a number between 1 and 1000. If the user's guess is not an integer, it asks the user to guess again. If the user's guess is not equal to the secret number, it gives the user a hint and asks them to guess again. Once the user guesses the correct number, it calls the `GAME_INFO` function.

3. `NEW_USER`: This function is called when a new user starts the game. It inserts the new user into the `users` table and starts the guessing game.

4. `USER`: This function is called when an existing user starts the game. It retrieves the user's game information from the database and starts the guessing game.

5. `GAME_INFO`: This function updates the game information in the database after each game. It updates the `games` and `users` tables with the number of games played and the best game score.

## Learning Outcomes

Through this project, I learned how to:

- Implement a game logic using Bash scripting.
- Use PostgreSQL for data management in a Bash script.
- Use Git for version control.
- Write SQL queries to interact w 1ith a PostgreSQL database.
- Handle user input and provide appropriate feedback.
- Use Bash functions to organize code and make it reusable.
