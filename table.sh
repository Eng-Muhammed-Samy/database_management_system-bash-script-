RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLO="\e[33m"
ENDCOLOR="\e[0m"
CYAN="\e[96m"


#--------------- table menu --------------# 
function tableFunctionalities {
echo -e "\n\n${YELLO}*--------Tables Menu------------*${ENDCOLOR}"
echo -e " ${GREEN} 1. Display Existing Tables     ${ENDCOLOR} "
echo -e " ${GREEN} 2. ADD New Table               ${ENDCOLOR} "
echo -e " ${GREEN} 3. Insert Into Table           ${ENDCOLOR} "
echo -e " ${GREEN} 4. Select All Rows From Table  ${ENDCOLOR} "
echo -e " ${GREEN} 5. Select column               ${ENDCOLOR} "
echo -e " ${GREEN} 6. Select Rows With condition  ${ENDCOLOR} "
echo -e " ${GREEN} 7. Update Table                ${ENDCOLOR} "
echo -e " ${GREEN} 8. Delete From Table           ${ENDCOLOR} "
echo -e " ${GREEN} 9. Drop Table                  ${ENDCOLOR} "
echo -e " ${GREEN} 10. Back To DB Menu            ${ENDCOLOR} "
echo -e " ${GREEN} 11. Exit                       ${ENDCOLOR} "
echo -e "${YELLO}*-------------------------------*${ENDCOLOR}\n\n"
echo -e "${CYAN}Enter Choice:${ENDCOLOR} \c"
  read ch
  case $ch in
    1)  ls -I '*.*'; tableFunctionalities ;;
    2)  createTable ;;
    3)  insert;;
    4)  clear; selectAllRows;;
    5)  clear; selectColoumn;;
    6)  clear; allRowsWithCondition;;
    7)  updateTable;;
    8)  deleteFromTable;;
    9)  dropTable;;
    10) clear;cd ../../ ; ./db.sh 2>>./.error;;
    11) exit ;;
    *) echo -e "${RED} Wrong Choice ${ENDCOLOR}" tableFunctionalities;;
  esac
}


#------------------- create table function ---------------------#
function createTable {
 #-------------- ask user to enter table name ---#
   echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
   read tableName
   clear
 #-------------- check valid table name -----------------------#
    if [[ ! $tableName =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $tableName == '' ]]
    then
        echo -e "${RED}Not a Valid Name for Table${ENDCOLOR}"
        createTable 
  #-------------- check if table is exist----------------------#
    elif [[ -f ./$tableName ]]
    then
        echo -e "${YELLO}Table Already Exist${ENDCOLOR}"
        createTable 
    else
      
        touch ./$tableName
  #------------ ask user for columns numbers ----------------#
        echo -e "${CYAN}Enter No of columns : ${ENDCOLOR} \c"
        read cols_num
 #---------------- check if colnum > 2----------------------#
        until [[ $cols_num =~ ^[2-9]+$ ]]
        do
            echo -e "${RED}Table Should Have at Least Two Column, String not allowed${ENDCOLOR}\c"
            echo -e "${CYAN}Enter No of columns : ${ENDCOLOR} \c"
            read cols_num
            clear
        done
#--------------------- enter columns name ----------------#

        for (( i = 1; i <= cols_num; i++ )); 
        do
          echo -e "${CYAN}Enter column $i name :${ENDCOLOR} \c" ;
          read col_name;

#----------------------- check valid name column------------#
           while [[ ! $col_name =~  ^[a-zA-Z]+(.*)+[a-zA-Z0-9]*$ ]] || [[ $col_name == '' ]]
           do
                echo -e "${RED}Not a Valid Name for column${ENDCOLOR}"; 
                read col_name;
          done  
      
     
#------------------ask user for column type----------------------#
       echo -e "${CYAN}Enter column datatype :${ENDCOLOR} ${YELLO}[string/int]${ENDCOLOR} : \c";
        read  col_type;
#-------------------- check type entered correctly---------------#
          while [[ "$col_type" != *(int)*(string) || -z "$col_type" ]]
          do
            echo -e "${RED}Invalid datatype${ENDCOLOR}";
            echo -e "${CYAN}Enter column datatype :${ENDCOLOR} ${YELLO}[string/int]${ENDCOLOR} : \c";
            read  col_type;
          done
#----------------------- check valid name column----------------#
           while [[ ! $col_name =~  ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] || [[ $col_name == '' ]]
           do
                echo -e "${RED}Not a Valid Name for column${ENDCOLOR}"; 
                read col_name;
          done  
      
#----------------------- append columns name and types in their files------#
          if [[ i -eq cols_num ]]; then
            echo  $col_name >>./$tableName;
            echo  $col_type >> ./$tableName.ct;

          else
            echo -n $col_name":" >> ./$tableName;
            echo -n $col_type":" >> ./$tableName.ct;
          fi

    done
      echo -e "${YELLO}$tableName${ENDCOLOR} ${BLUE}has been created${ENDCOLOR}"
  fi    
  tableFunctionalities
}


#---------------------------  insert functon --------------------#
function insert {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #--------------------- ask user to enter table name -------------------------#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  read tableName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tableName ]]
  then
  #-------------------- catch the number of columns in the table -----------#
    typeset -i nf=`awk -F: '{if(NR==1){print NF}}' ./$tableName;`
  #--------------------- loop on the number of columns ---------------------# 
    for (( i = 1; i <= $nf; i++ ))
    do
  #----------------------- catch the column name and the type of this column in each itreration--------#
      col_name=`awk -F: -v"i=$i" '{if(NR==1){print $i}}' ./$tableName;`
      col_type=`awk -F: -v"i=$i" '{if(NR==1){print $i}}' ./$tableName.ct;`
  #--------------------- set flag to use it to out from while loop --------------------#
      flag=0;
      while [[ $flag -eq 0 ]]
       do
  #----------------------- ask user to insert the value of each column ---------------#
        echo -e "${CYAN}Enter $col_name :${ENDCOLOR} \c" ;
        read col_value;
  #-----------------------check the value match the type ---------------------------------#
        if [[ ( $col_type = "int" && "$col_value" = +([0-9]) ) || ( $col_type = "string" && "$col_value" = +([a-zA-Z]) ) ]]; then
  #---------------------- if the number of iteration not equal number of fields------------#
          if [[ $i != $nf ]]
          then
  #--------------------- insert the value in the column use -n to insert in the same row ----#
            echo -n $col_value":" >> ./$tableName;
          else	
  #-------------------- insert the value in the column if it is the last value -------------#
            echo $col_value >> ./$tableName;
          fi
  #------------------ set flag = 1 to out from the while loop if the insert process is correct----#
          flag=1;
        fi
      done
    done
    
  else
  #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tableName${ENDCOLOR} ${RED}doesn't exist${ENDCOLOR}";
  fi
tableFunctionalities
}



#--------------------------- delete from table functon --------------------#
function deleteFromTable {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #-------------- ask user to enter table name ---#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  #------------- catch the table entered in tname variable ----------------#
  read tName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tName ]]
  then
  #-------------------- show available columns in selected table -------------#
    echo -e "${CYAN}there are the columns available in the table : ${ENDCOLOR}"
    row=$(awk 'BEGIN{FS=":"}{if (NR==1) print $0}' ./$tName);
    echo -e "${YELLO}$row${ENDCOLOR}";
  #-------------- ask user to enter column name ---#
  echo -e "${CYAN}Enter column Name : ${ENDCOLOR} \c"
  #------------- catch the column name entered in field variable ----------------#
  read field
  #------------- catch the number of the column name enterd in the fid variable---------#
  fid=$(awk 'BEGIN{FS=":"}{if(NR==1)
  {for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' ./$tName)
  #-------------- if the fid is empty ----------------------------------------#
  if [[ $fid == "" ]]
  then
  #--------------- show message column name doesnot exist------------------#
    echo -e "${YELLO}$field${ENDCOLOR}${RED} column doesn't exist${ENDCOLOR}";
    tableFunctionalities
  else
  #------------- if the fid equal a number then ask the user to enter the value of the column name in the row he want to delete it ----#
    echo -e "${CYAN}Enter Value of columun to delete it's row: ${ENDCOLOR}\c"
  #------------- catch the column value entered in val variable ----------------# 
    read val
  #-------------- check the value entered exist in some row if exist catch the value in res variable------------------#
    res=$(awk 'BEGIN{FS=":"}{if ($'$fid'=="'$val'") print $'$fid'}' ./$tName 2>>../../.error)
  
    if [[ $res == "" ]]
    then
  #---------------- if res is empty show message value not found ---------------#
      echo -e "${RED}Value Not Found${ENDCOLOR}"
      tableFunctionalities
    else
  #--------------- catch the record number of the value to delete that row ----------#
      NR=$(awk 'BEGIN{FS=":"}{if ($'$fid'=="'$val'") print NR}' ./$tName 2>>../../.error)
  #-------------- delete the row using sed -----------------------------#
      sed -i ''$NR'd' ./$tName 2>>../../.error
  #-------------- after deleted success show message ------------------#
      echo -e "${BLUE}Row Deleted Successfully${ENDCOLOR}"
      tableFunctionalities
    fi
  fi
  else
  #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tableName${ENDCOLOR} ${RED}doesn't exist${ENDCOLOR}";
  fi
  tableFunctionalities
}




#----------------------------  drop table function -------------------#
function dropTable 
{
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #-------------- ask user to enter table name ---#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  #------------- catch the table entered in tableName variable ----------------#
  read tableName
   #-------------------- check if table  exists -----------------#
  if [[ -f ./$tableName ]]
  then
  #-------------- ask user if he sure to drop that table and ask him to enter yes if he sure and no if he didnot sure----------#
    echo -e "${RED}Are you Sure You Want To drop${ENDCOLOR} ${YELLO}$tableName${ENDCOLOR} ${RED}table? y/n${ENDCOLOR}"
  #------------- catch the input in choice variable------------------#
    read choice;
  #----------- case condition --------------------------#
    case $choice in
      [Yy]* ) 
      #----------- if yes delete the table enterd the file of data and type -----#
        rm ./$tableName
        rm ./$tableName.ct
        echo -e "${YELLO}$tableName ${ENDCOLOR} ${BLUE}has been deleted${ENDCOLOR}"
        ;;
      [Nn]* ) 
      #----------- if no dcanceled operation------------------#
        echo -e "${BLUE}Operation Canceled${ENDCOLOR}"
        ;;
      * ) 
        echo -e "${BLUE}Invalid Input 0 tables effected${ENDCOLOR}"
        ;;
    esac
  else
    #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tableName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi

tableFunctionalities

}

#---------------------- update table ----------------------------------#

function updateTable {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #-------------- ask user to enter table name -----------------#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  #------------- catch the table entered in tName variable ----------------#
  read tName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tName ]]
  then
    #-------------- ask user to enter the column name ----------------------#
      echo -e "${CYAN}Enter condition column Name : ${ENDCOLOR} \c"
    #--------------- receive the column name in the colName variable-------------#
      read colName
    #------------- check that the column name is exist and return the colName number in fid variable------------------#
      fid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' ./$tName)
    #--------------- if fid doesnot have value  then column name doesnot exist-------#
      if [[ $fid == "" ]]
      then
        echo -e "${YELLO}$field${ENDCOLOR}${RED} column doesn't exist${ENDCOLOR}";
        tableFunctionalities
      else
    #--------------- ask user to enter the column value of the column name he entered in the row he want to update it ----#
        echo -e "${CYAN}Enter condition column Value in specific row: ${ENDCOLOR}\c"
    #-------------- receive the column value in the val variable -------------------#
        read val
    #-------------check if the value entered by the user in the column he specify and catch the value in res variable -----#
        res=$(awk 'BEGIN{FS=":"}{if ($'$fid'=="'$val'") print $'$fid'}' ./$tName 2>>../../.error)
    #--------------- if res doesnot have value  then value not found-------#
        if [[ $res == "" ]]
        then
          echo -e "${RED}Value Not Found${ENDCOLOR}"
          tableFunctionalities
        else
    #----------------- else ask user to enter the column name he want to update-----#
          echo -e "${CYAN}Enter column name to update it: ${ENDCOLOR}\c"
    #----------------- receive the column name in setField variable ----------------#
          read setField
    #------------- check that the column name is exist and return the colName number in setFid variable------------------#
          setFid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$setField'") print i}}}' ./$tName)
    #--------------- if setFid doesnot have value  then column name doesnot exist-------#  
          if [[ $setFid == "" ]]
          then
            echo -e "${YELLO}$setField${ENDCOLOR}${RED} column doesn't exist${ENDCOLOR}";
            tableFunctionalities
          else
    #-------------- else catch the column type of the column name entered in col_type variable -----------#
          col_type=`awk -F: -v"i=$setFid" '{if(NR==1){print $i}}' ./$tName.ct;`
          flag=0;
          while [[ $flag -eq 0 ]]
          do
    #--------------- ask the user to enter the new value of the column name in the specified row which match the type of col_type-----#
            echo -e "${CYAN}Enter new Value of column in the row you want to update: ${ENDCOLOR}\c"
            read newValue
            if [[ ( $col_type = "int" && "$newValue" = +([0-9]) ) || ( $col_type = "string" && "$newValue" = +([a-zA-Z]) ) ]]
            then
    # -------------- catch the row he want to update ----------------------------------#
              NR=$(awk 'BEGIN{FS=":"}{if ($'$fid' == "'$val'") print NR}' ./$tName 2>>../../.error)
    #-------------- catch the old value -----------------------------------------------#
              oldValue=$(awk 'BEGIN{FS=":"}{if(NR=='$NR'){for(i=1;i<=NF;i++){if(i=='$setFid') print $i}}}' ./$tName 2>>../../.error)
              #echo $oldValue
    #---------------- replace the old value with the new value ---------#
              sed -i ''$NR's/'$oldValue'/'$newValue'/g' ./$tName 2>>../../.error
              echo -e "${BLUE}Row Updated Successfully${ENDCOLOR}"
              tableFunctionalities
              flag=1;
            fi
          done
          fi
        fi
      fi
  else
    #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi
  tableFunctionalities
}

#--------------------------- select all rows function ---------------------#
function selectAllRows {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #-------------- ask user to enter table name ---#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
    #------------- catch the table entered in tName variable ----------------#
  read tName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tName ]]
  then
  #column --> display the content in file
  # -t --> determine the number of column to display, -s --> defines columns delemeter
   allrow=$(column -t -s ':' ./$tName 2>>../../.error);
   echo -e "${YELLO}$allrow${ENDCOLOR}";
  else
    #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi

  tableFunctionalities
}

#--------------------------- select specific column function ---------------------#
function selectColoumn {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*';
  #-------------- ask user to enter table name ---#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  #------------- catch the table entered in tName variable ----------------#
  read tName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tName ]]
  then
  #-------------------- show available columns in selected table -------------#
    echo -e "${CYAN}there are the columns available in the table : ${ENDCOLOR}"
    row=$(awk 'BEGIN{FS=":"}{if (NR==1) print $0}' ./$tName);
    echo -e "${YELLO}$row${ENDCOLOR}";
  #---------------------- ask user to enter the column number that he want to select ----#
    echo -e "${CYAN}Enter Column Number: ${ENDCOLOR} \c"
    read colNum
    #------------- catch the number of columns in NF----------#
    NF=$(awk 'BEGIN{FS=":"}{if (NR==1) print NF}' ./$tName 2>>../../.error)
    #-------------- ask user to enter the column number again if he entered column number that isnot exist---#
    while [[ $colNum -gt $NF || $colNum -eq 0 ]]
    do
    echo -e "${CYAN}Enter Column Number: ${ENDCOLOR} \c"
     read colNum
     NR=$(awk 'BEGIN{FS=":"}{if (NR==1) print NF}' ./$tName 2>>../../.error)
    done
    #------------- print the column-----------------#
     col=$(awk 'BEGIN{FS=":"}{print $'$colNum'}' ./$tName)
      echo -e "${YELLO}$col${ENDCOLOR}"
  else
    #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi

  tableFunctionalities
  
}

#--------------------------- select rows with condition function ---------------------#

function allRowsWithCondition {
  #-------------------- show available tables in selected database -------------#
  echo -e "${CYAN}Available tables are: ${ENDCOLOR}"
  ls -I '*.*'; 
  #-------------- ask user to enter table name ------------------#
  echo -e "${CYAN}Enter Table Name : ${ENDCOLOR} \c"
  #------------- catch the table entered in tName variable ----------------#
  read tName
  #-------------------- check if table  exists -----------------#
  if [[ -f ./$tName ]]
  then
  #--------------------- display all column name -----------------#
    echo -e "${CYAN}there are the columns available in the table : ${ENDCOLOR}"
    row=$(awk 'BEGIN{FS=":"}{if (NR==1) print $0}' ./$tName);
    echo -e "${YELLO}$row${ENDCOLOR}";
  #-------------- ask user to enter column name ---#
    echo -e "${CYAN}Enter Column name: ${ENDCOLOR}\c"
  #------------- catch the column name in the colName variable----------#
    read colName
  #------------- check that the column name is exist and return the colName number in fid variable------------------#
    fid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' ./$tName)
  #--------------- if fid doesnot have value  then column name doesnot exist-------#
    if [[ $fid == "" ]]
    then
          echo -e "${YELLO}$colName${ENDCOLOR} ${RED}column doesn't exist${ENDCOLOR}";
    tableFunctionalities
    else
    #-------------------- ask user to enter the operation for condition-----------------#
      echo -e "\n${CYAN}select operator: [==, !=, >, <, >=, <=]: ${ENDCOLOR}\c"
    #--------------------- catch the condition in op variavble---------------------------#
      read op
      if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
      then
      #---------------- ask user to enter the value of the column name he entered---------#
        echo -e "\n${CYAN}Enter value : ${ENDCOLOR}\c"
        #------------------- catch the value in val variable-------------#
        read val
        #---------------- check that value entered valid and perform the condition correctly----#
        res=$(awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $0}' ./$tName 2>>../../.error |  column -t -s ':')
        #--------------- if res doesnot have value show error message---------------#
        if [[ $res == "" ]]
        then
          echo -e "${RED}Value Not Found${ENDCOLOR}"
          tableFunctionalities
        else
        
        #------------ print the result-------------#
          col=$(awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $0}' ./$tName 2>>../../.error |  column -t -s ':')
          echo -e "${YELLO}$col${ENDCOLOR}"
          tableFunctionalities
        fi
      else
        echo -e "${RED}Unsupported Operator\n${ENDCOLOR}"
        tableFunctionalities
      fi
    fi
  else
    #-------------------- if table doesnot exist tell user meaasage doexnot exist ----------#
    echo -e "${YELLO}$tName ${ENDCOLOR} ${BLUE} doesn't exist${ENDCOLOR}"
  fi
  tableFunctionalities
}

tableFunctionalities

