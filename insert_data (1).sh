#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
   if [[ $YEAR != "year" ]]
    then	 
	  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' AND name='$OPPONENT'") 
	    # if not found
      if [[ -z $TEAM_ID ]]
      then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_NEW_NAME == "INSERT 0 1" ]]
        then
        echo Inserted into teams, $WINNER and $OPPONENT
        fi
      fi
      # get game_id
      GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_goals == opponent_goals") 
	      # if not found
        if [[ -z $GAME_ID ]]
        then
        # get winner and opponent id's
        WINNER_ID=$($PSQL "SELECT DISTINCT team_id FROM teams WHERE name='$WINNER'") 
        OPPONENT_ID=$($PSQL "SELECT DISTINCT team_id FROM teams WHERE name='$OPPONENT'") 
        # insert result into games
        INSERT_GAME_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
        VALUES($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      
          if [[ $INSERT_NEW_INFOS == "INSERT 0 1" ]]
          then
          echo Inserted into games, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS.
          fi
        fi

    fi
  done