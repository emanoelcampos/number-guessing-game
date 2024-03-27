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
    TOTAL_GUESS=1

    SECRET_NUMBER=$((RANDOM % 5))

    while [[ $GUESS -ne $SECRET_NUMBER ]]; do
      GAME_FINISHED=1 # 1 = false
      TOTAL_GAMES=0
      if [[ $GUESS -gt $SECRET_NUMBER ]]; then
        echo -e "It's lower than that, guess again:\n"
        read GUESS
        TOTAL_GUESS=$((TOTAL_GUESS + 1))

      elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
        echo -e "It's higher than that, guess again:\n"
        read GUESS
        TOTAL_GUESS=$((TOTAL_GUESS + 1))
      fi
    done
    GAME_FINISHED=0

    if [[ $GAME_FINISHED = 0 ]]; then # 0 = true
      TOTAL_GAMES=0
      echo -e "\nYou guessed it in $TOTAL_GUESS tries. The secret number was $GUESS. Nice job!\n"
      GAME_INFO
    fi
  fi
}

NEW_USER() {
  INSERT_NEW_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
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