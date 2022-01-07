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

#---------------------- database menu----------------------#
function dbMenu {
  # -e --> enables the interpretation of backslash escapes
  echo -e "\n\n${YELLO}*-------DB Menu--------*${ENDCOLOR}"
  echo -e " ${GREEN} 1. Select Database    ${ENDCOLOR} "
  echo -e " ${GREEN} 2. Create Database    ${ENDCOLOR} "
  echo -e " ${GREEN} 3. Rename Database    ${ENDCOLOR} "
  echo -e " ${GREEN} 4. Drop Database      ${ENDCOLOR} "
  echo -e " ${GREEN} 5. Show Database      ${ENDCOLOR} "
  echo -e " ${GREEN} 6. Exit               ${ENDCOLOR} "
  echo -e "${YELLO}*----------------------*${ENDCOLOR}\n\n"
  echo -e "${CYAN}Enter YOUR Choice: ${ENDCOLOR}\c"                            
  read ch
  case $ch in
    1)  selectDB ;; 
    2)  createDB ;;
    3)  renameDB ;;
    4)  dropDB ;;
    5)  ls ./databases ; dbMenu;;
    6) exit ;;
    *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" ; dbMenu;
  esac
}



############ create select function to select specific database ###############

function selectDB {
  #----------- show available databases---------------#
  echo -e "${CYAN}Available databases are: ${ENDCOLOR}"
  ls ./databases;
  #----------- ask user to enter the database name---------#
  echo -e "${CYAN}Enter Database Name${ENDCOLOR}: \c"
  read dbName
  #------- change the directory to the database entered----#
  cd ./databases/$dbName 2>>../../.error
  #------------ check if the operation done sucessfuly----#
  if [[ $? == 0 ]]; then
  #------------- show sucessfuly selected and execute table file-----------#
    echo -e "\n${BLUE}Database${ENDCOLOR} $dbName ${BLUE}was Successfully Selected${ENDCOLOR}"
    ../../table.sh
  else
  #----------- else show not found db--#
    echo -e "\n${RED}Database${ENDCOLOR} ${YELLO}$dbName${ENDCOLOR} ${RED}wasn't found${ENDCOLOR}\n"
    dbMenu
  fi
}

#---------------- create database function with validation ---------------#
function createDB {
  #------------- ask user to enter database name ----------#
    echo -e "${CYAN}Enter Database Name : ${ENDCOLOR} \c"
    read dbName
    clear
    #----------- validate valid name entered by user --------#
    if [[ ! $dbName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
    then
    #------------- if not match show not valid name and repeat function ----#
        echo -e "${RED}not a valid database name${ENDCOLOR}"
        createDB
    else
    #-------if valid name check if database is exist---------------#
        if [ -d ./databases/$dbName ]
        then
        #----------- if database name already exist show already exist message and repeat function ---#
            echo -e "${YELLO}already exists please try again${ENDCOLOR}"
            createDB
        else
        #--------- else create folder that represent database------------#
            mkdir ./databases/$dbName
                echo -e "$dbName ${BLUE} db created successfully ${ENDCOLOR}"
                dbMenu
        fi
    fi
}


#-----------------------rename specific database----------------#
function renameDB {
  #--------- ask user to enter the curerent name ----#
  echo -e "${CYAN}Enter Current Database Name: ${ENDCOLOR}\c"
  read dbName
  #------- check the database is exist---------#
  if [ -d ./databases/$dbName ]
  then
  #----------- ask user to enter the new database name---------#
      echo -e "${CYAN}Enter New Database Name: ${ENDCOLOR}\c"
      read newName
  #--------- check if it is a valid name --------------#
        while [[ ! $newName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]]
        do
  #------------ if not avalid name show error message and ask again for valid name until he entered valid name---#
            echo -e "${RED}not a valid database rename${ENDCOLOR}"
            echo -e "${CYAN}Enter New Database Name: ${ENDCOLOR}\c"
            read newName
        done
  #----- after entered valid name rename the old name with the new name -------------#
        mv ./databases/$dbName ./databases/$newName 2>>./.error
#------------- if command executed sucessfully show sucess message-----------#
        if [[ $? == 0 ]]; then

            echo -e "${BLUE}Database${ENDCOLOR} ${YELLO} $dbName ${ENDCOLOR} ${BLUE}Renamed to${ENDCOLOR} ${YELLO} $newName ${ENDCOLOR} ${BLUE}Successfully${ENDCOLOR}"

        else
            echo -e "${RED}Error in Renaming Database${ENDCOLOR}"
            renameDB
        fi
  else
#------------------ if database name doesnot exist show error message-------------#
   echo -e "${YELLO}$dbName${ENDCOLOR}${RED} database doesnot exist please try again${ENDCOLOR}"
   renameDB
  fi
  dbMenu
}

#------------------ Drop database function -----------------#
function dropDB {
#-------------- show available databases-----------#
  echo -e "${CYAN}Available database are: ${ENDCOLOR}"
  ls ./databases;
#------------- ask user to enter the name of db----#
  echo -e "${CYAN}Enter Database Name:${ENDCOLOR} \c"
  read dbName
#------------- check if db is exists-------------#
  if [[ -d ./databases/$dbName ]] 
    then
     #------------- if exist ask user if he sure to drop or not  enter yes or no------------#
         echo -e "${YELLO}are you sure to drop${ENDCOLOR} ${RED}$dbName${ENDCOLOR} ? [y, n]"
        read ch
        #------- if user enter yes-----#
        if [[ $ch =~ ^[yY]+[a-zA-Z]*$ ]]
        then
        #---------- remove the database---#
            rm -r ./databases/$dbName 2>>./.error
            if [[ $? == 0 ]]
            then
                echo -e "${BLUE}Database${ENDCOLOR} ${YELLO} $dbName ${ENDCOLOR} ${BLUE}Dropped Successfully${ENDCOLOR}"
            fi
        else 
        #---------------if enter no show operation is canceeled---------#
            echo -e "${BLUE}delete is canceld${ENDCOLOR}"
        fi
    else
    #------------ if db not found show not found message--#
        echo -e "${RED}Database Not found${ENDCOLOR}"
    fi
  dbMenu
}
#---------------- cal function dbmenu------------------------#
dbMenu

