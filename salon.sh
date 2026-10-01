#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c" 

echo -e "\n~~~Salon Future~~~\n"
echo -e "Welcome to Salon Future, please choose a service:"

SERVICE_MENU() {
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  # read the service_id input
  read SERVICE_ID_SELECTED
  # if not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # start the menu again
    SERVICE_MENU "I could not find that service. What would you like today?"
  else
    SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    # if not in the service list
    if [[ -z $SERVICE_SELECTED ]]
    then
      # send to service menu
      SERVICE_MENU "I could not find that service. What would you like today?"
    else
	    #ask for phone number
	    echo -e "\nWhat's your phone number?"
	    read CUSTOMER_PHONE
	    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      # if CUSTOMER_PHONE not found
      if [[ -z $CUSTOMER_ID ]]
      then
        # ask for new customer name
        echo -e "\nI don't have a record for that phone number, what's your name?" 
        read CUSTOMER_NAME
        # insert customer
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        echo -e "\nWhat time would you like your $(echo $SERVICE_SELECTED | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
        read SERVICE_TIME
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
        echo -e "\nI have put you down for a $(echo $SERVICE_SELECTED | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
      else
        #customer phone found, continue
        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
        echo -e "\nWhat time would you like your $(echo $SERVICE_SELECTED | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?" 
        read SERVICE_TIME
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
        echo -e "\nI have put you down for a $(echo $SERVICE_SELECTED | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."      
      fi
    fi
  fi
}

SERVICE_MENU
