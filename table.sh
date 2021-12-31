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
    1)  ls -I '*.*'; tableFunctionalities ;;
    2)  createTable ;;
    3)  insert;;
    #4)  clear; selectMenu ;;
    #5)  updateTable;;
    #6)  deleteFromTable;;
    7)  dropTable;;
    8) clear;cd ../../ ; ./db.sh 2>>./.error;;
    9) exit ;;
    *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" tableFunctionalities;;
  esac
}


#------------------- create table function ---------------------#
function createTable {
 #-------------- ask user to enter table name ---#
   echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
   read tableName
   clear
  #-------------- check valid table name -------#
    if [[ ! $tableName =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $tableName == '' ]]
    then
        echo -e "${RED}Not a Valid Name for Table${ENDCOLOR}"
        createTable 
    #-------------- check if table is exist---#
    elif [[ -f ./$tableName ]]
    then
        echo -e "${YELLO}Table Already Exist${ENDCOLOR}"
        createTable 
    else
      
        touch ./$tableName
  #------------ ask user for columns numbers ----------#
        echo -e "${CYAN}Enter No of columns : ${ENDCOLOR} \c"
        read cols_num
 #---------------- check if colnum > 2-----------#
        until [[ $cols_num =~ ^[2-9]+$ ]]
        do
            echo -e "${RED}Table Should Have at Least Two Column, String not allowed${ENDCOLOR}\c"
            echo -e "${CYAN}Enter No of columns : ${ENDCOLOR} \c"
            read cols_num
            clear
        done
#--------------------- enter columns name and types------#
        for (( i = 1; i <= cols_num; i++ )); 
        do
          echo -e "${CYAN}Enter column $i name :${ENDCOLOR} \c" ;
          read col_name;


          flag=0;
          typeset -i nf=`awk -F: '{if(NR==1){print NF}}' ./$tableName`;
     
    #------------------ask user for column type----------------------#
       echo -e "${CYAN}Enter column datatype :${ENDCOLOR} ${YELLO}[string/int]${ENDCOLOR} : \c";
        read  col_type;
      #-------------------- check type entered correctly----------#
          while [[ "$col_type" != *(int)*(string) || -z "$col_type" ]]
          do
            echo -e "${RED}Invalid datatype${ENDCOLOR}";
            echo -e "${CYAN}Enter column datatype :${ENDCOLOR} ${YELLO}[string/int]${ENDCOLOR} : \c";
            read  col_type;
          done
           

  #----------------------------- check if the column name is same with entered names------#
      #    while [[ $flag -eq 0 ]]
      #    do
       
      #     if [[ $nf -ne 0 ]]
      #     then
      #           for (( j = 1; j <= $nf; j++ ))
      #           do
      #               exist_colname=`awk -F: -v"i=$i" '{if(NR==1){print $i}}' ./$tableName;`
      #               if [ "$col_name" == "$exist_colname" ]
      #               then
      #               echo -e "${RED}column name exists write another name${ENDCOLOR}";
      #               echo -e "${CYAN}Enter column $i name :${ENDCOLOR} \c" ;
      #               read col_name;
      #               else
      #                 flag=1;
      #               fi
      #           done
      #     else
      #         flag=1;
      #     fi       
      # done
#----------------------- check valid name column------------#
           while [[ ! $col_name =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $col_name == '' ]]
           do
                echo -e "${RED}Not a Valid Name for column${ENDCOLOR}"; 
                read col_name;
          done  
      
#-----------------------------append columns name and types in their files------#
          if [[ i -eq cols_num ]]; then
            echo  $col_name >>./$tableName;
            echo  $col_type >> ./$tableName.ct;

          else
            echo -n $col_name":" >> ./$tableName;
            echo -n $col_type":" >> ./$tableName.ct;
          fi

    done
      echo "$tableName has been created"
  fi    
  tableFunctionalities
}
#--------------------------- create insert functon --------------------#
function insert {


  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  read tableName
  if [[ -f ./$tableName ]]
  then
    typeset -i nf=`awk -F: '{if(NR==1){print NF}}' ./$tableName;`
    
    for (( i = 1; i <= $nf; i++ ))
    do
      col_name=`awk -F: -v"i=$i" '{if(NR==1){print $i}}' ./$tableName;`
      col_type=`awk -F: -v"i=$i" '{if(NR==1){print $i}}' ./$tableName.ct;`
      flag=0;
      while [[ $flag -eq 0 ]]
       do
        echo -e "${CYAN}Enter $col_name :${ENDCOLOR} \c" ;
        read col_value;
  
        if [[ ( $col_type = "int" && "$col_value" = +([0-9]) ) || ( $col_type = "string" && "$col_value" = +([a-zA-Z]) ) ]]; then
          if [[ $i != $nf ]]; then
            echo -n $col_value":" >> ./$tableName;
          else	
            echo $col_value >> ./$tableName;
          fi
          flag=1;
        fi
      done
    done
    
  else
    echo "$tableName doesn't exist";
  fi


tableFunctionalities
}







#---------------------------- create drop table function -------------------#
function dropTable 
{
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
   read tableName
  if [[ -f ./$tableName ]]
  then
    echo -e "${RED}Are you Sure You Want To drop${ENDCOLOR} ${YELLO}$tableName${ENDCOLOR} ${RED}table? y/n${ENDCOLOR}"
    read choice;
    case $choice in
      [Yy]* ) 
        rm ./$tableName
        rm ./$tableName.ct
        echo -e "${YELLO}$tableName ${ENDCOLOR} ${BLUE}has been deleted${ENDCOLOR}"
        ;;
      [Nn]* ) 
        echo -e "${BLUE}Operation Canceled${ENDCOLOR}"
        ;;
      * ) 
        echo -e "${BLUE}Invalid Input 0 tables effected${ENDCOLOR}"
        ;;
    esac
  else
    echo -e "${YELLO}$tableName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi

tableFunctionalities

}

tableFunctionalities
