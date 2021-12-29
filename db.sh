#!/bin/bash
if [[ ! -d ./databases ]]
then
    mkdir ./databases
fi

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
    3)  renameDB ;;
    4)  dropDB ;;
    5)  ls ./databases ; dbMenu;;
    # 6) exit ;;
    # *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" ; dbMenu;
  esac
}



############ create select function to select specific database ###############

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


#-----------------------rename specific database----------------#
function renameDB {
  echo -e "${CYAN}Enter Current Database Name: ${ENDCOLOR}\c"
  read dbName
  if [ -d ./databases/$dbName ]
  then
      echo -e "${CYAN}Enter New Database Name: ${ENDCOLOR}\c"
      read newName
        while [[ ! $newName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
        do
            echo -e "${RED}not a valid database rename${ENDCOLOR}"
            echo -e "${CYAN}Enter New Database Name: ${ENDCOLOR}\c"
            read newName
        done
        mv ./databases/$dbName ./databases/$newName 2>>./.error
        if [[ $? == 0 ]]; then
            echo -e "${BLUE}Database${ENDCOLOR} ${YELLO} $dbName ${ENDCOLOR} ${BLUE}Renamed to${ENDCOLOR} ${YELLO} $newName ${ENDCOLOR} ${BLUE}Successfully${ENDCOLOR}"
        else
            echo -e "${RED}Error in Renaming Database${ENDCOLOR}"
            renameDB
        fi
  else

   echo -e "${YELLO}$dbName${ENDCOLOR}${RED} database doesnot exist please try again${ENDCOLOR}"
   renameDB
  fi
  dbMenu
}

#------------------ Drop database function -----------------#
function dropDB {
  echo -e "${CYAN}Enter Database Name:${ENDCOLOR} \c"
  read dbName
  rm -r ./databases/$dbName 2>>./.error
  if [[ $? == 0 ]]
  then
    echo -e "${BLUE}Database${ENDCOLOR} ${YELLO} $dbName ${ENDCOLOR} ${BLUE}Dropped Successfully${ENDCOLOR}"
  else
    echo -e "${RED}Database Not found${ENDCOLOR}"
  fi
  dbMenu
}


#---------------- cal function dbmenu------------------------#
dbMenu

