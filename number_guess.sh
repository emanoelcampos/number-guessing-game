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