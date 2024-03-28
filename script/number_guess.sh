#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

GAME_START() {
  echo "Enter your username:"
  read USERNAME
  USERNAME=$(echo "$USERNAME" | sed 's/.*/\L&/')

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")
  if [[ -z $USER_ID ]]; then
    NEW_USER
  else
    USER
  fi
}

GUESS_NUMBER() {
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo -e "\nThat is not an integer, guess again:"
    GUESS_NUMBER

  else
    GUESS_COUNT=1

    SECRET_NUMBER=$((RANDOM % 1000 + 1))

    while [[ $GUESS -ne $SECRET_NUMBER ]]; do
      NUMBER_GUESSED=1 # false
      GAME_COUNT=0
      if [[ $GUESS -gt $SECRET_NUMBER ]]; then
        echo -e "It's lower than that, guess again:\n"
        read GUESS
        GUESS_COUNT=$((GUESS_COUNT + 1))

      elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
        echo -e "It's higher than that, guess again:\n"
        read GUESS
        GUESS_COUNT=$((GUESS_COUNT + 1))
      fi
    done
    NUMBER_GUESSED=0 # true

    if [[ $NUMBER_GUESSED = 0 ]]; then
      GAME_COUNT=1
      echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $GUESS. Nice job!\n"
      GAME_INFO
    fi
  fi
}

NEW_USER() {
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

  echo "Welcome, $USERNAME! It looks like this is your first time here."
  GUESS_NUMBER
}

USER() {
  USER_INFO=$($PSQL "SELECT username, games_played, best_game FROM users INNER JOIN games USING(user_id) WHERE user_id = $USER_ID;")
  echo "$USER_INFO" | while IFS=" |" read USERNAME GAMES_PLAYED BEST_GAME; do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
  GUESS_NUMBER
}

GAME_INFO() {
  BEST_GAME=$($PSQL "SELECT best_game FROM games INNER JOIN users USING(user_id) WHERE user_id = $USER_ID;")
  if [[ -z $BEST_GAME ]]; then
    INSERT_BEST_GAME=$($PSQL "INSERT INTO games(user_id, best_game) VALUES($USER_ID, $GUESS_COUNT);")
  else
    if [[ $GUESS_COUNT -lt $BEST_GAME ]]; then
      UPDATE_BEST_GAME=$($PSQL "UPDATE games SET best_game = $GUESS_COUNT WHERE user_id = $USER_ID;") #
    fi
  fi

  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id = $USER_ID;")
  if [[ -z $GAMES_PLAYED ]]; then
    INSERT_GAMES_PLAYED=$($PSQL "INSERT INTO users(games_played) VALUES($GAME_COUNT)")
  else
    UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED + 1 WHERE user_id = $USER_ID;")
  fi
}

GAME_START
