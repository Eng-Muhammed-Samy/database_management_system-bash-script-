RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLO="\e[33m"
ENDCOLOR="\e[0m"
CYAN="\e[96m"


#--------------- table menu --------------# 
function tableFunctionalities {
echo -e "\n+--------Tables Menu------------+"
echo -e " ${GREEN}| 1. Show Existing Tables    |${ENDCOLOR} "
echo -e " ${GREEN}| 2. Create New Table        |${ENDCOLOR} "
echo -e " ${GREEN}| 3. Insert Into Table       |${ENDCOLOR} "
echo -e " ${GREEN}| 4. Select From Table       |${ENDCOLOR} "
echo -e " ${GREEN}| 5. Update Table            |${ENDCOLOR} "
echo -e " ${GREEN}| 6. Delete From Table       |${ENDCOLOR} "
echo -e " ${GREEN}| 7. Drop Table              |${ENDCOLOR} "
echo -e " ${GREEN}| 8. Back To database Menu   |${ENDCOLOR} "
echo -e " ${GREEN}| 9. Exit                    |${ENDCOLOR} "
echo "+-------------------------------+"
echo -e "${CYAN}Enter Choice:${ENDCOLOR} \c"
  read ch
  case $ch in
    1)  ls .; tableFunctionalities ;;
    #2)  createTable ;;
    #3)  insert;;
    #4)  clear; selectMenu ;;
    #5)  updateTable;;
    #6)  deleteFromTable;;
    #7)  dropTable;;
    8) clear;cd ../../ ; ./db.sh 2>>./.error;;
    9) exit ;;
    *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" tableFunctionalities;;
  esac


}





tableFunctionalities
