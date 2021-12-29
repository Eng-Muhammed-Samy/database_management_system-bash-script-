#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[33m"
YELLO="\e[34m"
ENDCOLOR="\e[0m"
function dbMenu {
  echo -e "\n*-------DB Menu--------*"
  echo -e " ${GREEN}| 1. Select Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 2. Create Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 3. Rename Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 4. Drop Database   |${ENDCOLOR} "
  echo -e " ${GREEN}| 5. Show Database   |${ENDCOLOR} "
  echo -e " ${GREEN}| 6. Exit            |${ENDCOLOR} "
  echo -e "*----------------------*"
  echo -e "Enter Choice: \c"                            
  read ch
  case $ch in
    1)  selectDB ;;
    2)  createDB ;;
    3)  renameDB ;;
    4)  dropDB ;;
    5)  ls ./DBMS ; dbMenu;;
    6) exit ;;
    *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" ; dbMenu;
  esac
}



dbMenu