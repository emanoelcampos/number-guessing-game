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