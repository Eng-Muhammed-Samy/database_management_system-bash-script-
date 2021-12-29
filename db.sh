#!/bin/bash
mkdir databases
touch .error
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLO="\e[33m"
ENDCOLOR="\e[0m"
CYAN="\e[96m"
function dbMenu {
  echo -e "\n*-------DB Menu--------*"
  echo -e " ${GREEN}| 1. Select Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 2. Create Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 3. Rename Database |${ENDCOLOR} "
  echo -e " ${GREEN}| 4. Drop Database   |${ENDCOLOR} "
  echo -e " ${GREEN}| 5. Show Database   |${ENDCOLOR} "
  echo -e " ${GREEN}| 6. Exit            |${ENDCOLOR} "
  echo -e "*----------------------*"
  echo -e "${CYAN}Enter YOUR Choice: ${ENDCOLOR}\c"                            
  read ch
  case $ch in
    1)  selectDB ;;
    2)  createDB ;;
    # 3)  renameDB ;;
    # 4)  dropDB ;;
    # 5)  ls ./DBMS ; dbMenu;;
    # 6) exit ;;
    # *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" ; dbMenu;
  esac
}

############### create select database function to select specific database #########

function selectDB {

 echo -e "${CYAN}Enter Database Name${ENDCOLOR}: \c"
  read dbName
  cd ./databases/$dbName 2>>./.error
  if [[ $? == 0 ]]; then
    echo -e "\n${BLUE}Database${ENDCOLOR} $dbName ${BLUE}was Successfully Selected${ENDCOLOR}"
    echo "tablesMenu"
  else
    echo -e "\n${RED}Database${ENDCOLOR} ${YELLO}$dbName${ENDCOLOR} ${RED}wasn't found${ENDCOLOR}\n"
    dbMenu
  fi
}

#---------------- create database function with validation ---------------#
function createDB {
    echo -e "${CYAN}Enter Database Name : ${ENDCOLOR} \c"
    read dbName
    clear
    if [[ ! $dbName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
    then
        echo -e "${RED}not a valid database name${ENDCOLOR}"
        createDB
    else
        if [ -d ./databases/$dbName ]
        then
            echo -e "${YELLO}already exists please try again${ENDCOLOR}"
            createDB
        else
            mkdir ./databases/$dbName
                echo -e "$dbName ${BLUE} db created successfully ${ENDCOLOR}"
                dbMenu
        fi
    fi
}
dbMenu