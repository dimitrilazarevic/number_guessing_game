#!/bin/bash

# Function definitions :


# Script :

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$((RANDOM*1000/32768))

echo Enter your username:
read USERNAME

CURRENT_USER_ID=$($PSQL"SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ $CURRENT_USER_ID ]]
  then 
  
    USER_GAMES=$($PSQL "SELECT COUNT(*), MIN(number_of_guesses) FROM games WHERE user_id = $CURRENT_USER_ID")
    USERNAME=$($PSQL "SELECT username FROM users WHERE user_id = $CURRENT_USER_ID")

    echo "$USER_GAMES" | while IFS='|' read NUMBER_OF_GAMES MIN_GUESSES
    do
    echo "Welcome back, $USERNAME! You have played $NUMBER_OF_GAMES games, and your best game took $MIN_GUESSES guesses."
    done
  else
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
fi

echo "Guess the secret number between 1 and 1000:"

NUMBER_OF_ATTEMPTS=0

NUMBER_HAS_BEEN_GUESSED=false
  
while [[ !$NUMBER_HAS_BEEN_GUESSED ]]
 do

    read ATTEMPT
    ((NUMBER_OF_ATTEMPTS++))

    if [[ $ATTEMPT =~ [0-9]+ ]]
      then

      if [[ $ATTEMPT -lt $RANDOM_NUMBER ]]
        then
          echo "It's higher than that, try again"

        elif [[ $ATTEMPT -gt $RANDOM_NUMBER ]]
        then
          echo "It's lower than that, try again"
        else
          echo "You guessed it in $NUMBER_OF_ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
          NUMBER_HAS_BEEN_GUESSED=true
          INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id,number_of_guesses) VALUES($CURRENT_USER_ID,$NUMBER_OF_ATTEMPTS)
          
          ")
      fi

      else
        echo That is not an integer, guess again:
    
    fi

done
