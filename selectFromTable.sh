
function selectMenu {
  echo -e "\n\n+---------------Select Menu--------------------+"
  echo "| 1. Select All Columns of a Table              |"
  echo "| 2. Select Specific Column from a Table        |"
  echo "| 3. Select From Table under condition          |"
  echo "| 4. Aggregate Function for a Specific Column   |"
  echo "| 5. Back To Tables Menu                        |"
  echo "| 6. Back To Main Menu                          |"
  echo "| 7. Exit                                       |"
  echo "+----------------------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) selectAllRows ;;
    2) selectColoumn ;;
    3) clear; selectWithCondition ;;
    # 4) ;;
    # 5) clear; tablesMenu ;;
    # 6) clear; cd ../.. 2>>./.error.log; mainMenu ;;
    7) exit ;;
    *) echo " Wrong Choice " ; selectMenu;
  esac
}

function selectAllRows {
  echo -e "Enter Table Name: \c"
  read tName
  column -t -s ':' ./$tName 2>>./.error
  if [[ $? != 0 ]]
  then
    echo "Error Displaying Table $tName"
  fi
  selectMenu
}

function selectColoumn {
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter Column Number: \c"
  read colNum
  awk 'BEGIN{FS=":"}{print $'$colNum'}' ./$tName
  selectMenu
}

function selectWithCondition {
  echo -e "\n\n+--------Select Under Condition Menu-----------+"
  echo "| 1. Select All Columns Matching Condition    |"
  echo "| 2. Select Specific Column Matching Condition|"
  echo "| 3. Back To Selection Menu                   |"
  echo "| 4. Back To Main Menu                        |"
  echo "| 5. Exit                                     |"
  echo "+---------------------------------------------+"
  echo -e "Enter Choice: \c"
  read ch
  case $ch in
    1) clear; allColumnsWithCondition ;;
    # 2) clear; specCond ;;
     3) clear; selectWithCondition ;;
    4) clear; cd ../.. 2>>./.error; selectMenu ;;
    5) exit ;;
    *) echo " Wrong Choice " ; selectWithCondition;
  esac
}

function allColumnsWithCondition {
  echo -e "Select all columns from TABLE Where FIELD(OPERATOR)VALUE \n"
  echo -e "Enter Table Name: \c"
  read tName
  echo -e "Enter required FIELD name: \c"
  read field
  fid=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' ./$tName)
  if [[ $fid == "" ]]
  then
    echo "Not Found"
    selectWithCondition
  else
    echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
    read op
    if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
    then
      echo -e "\nEnter required VALUE: \c"
      read val
      res=$(awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $0}' ./$tName 2>>./.error.log |  column -t -s ':')
      if [[ $res == "" ]]
      then
        echo "Value Not Found"
        selectWithCondition
      else
        awk 'BEGIN{FS=":"}{if ($'$fid$op$val') print $0}' ./$tName 2>>./.error |  column -t -s ':'
        selectWithCondition
      fi
    else
      echo "Unsupported Operator\n"
      selectWithCondition
    fi
  fi
}

# function speciificCond {
#   echo -e "Select specific column from TABLE Where FIELD(OPERATOR)VALUE \n"
#   echo -e "Enter Table Name: \c"
#   read tName
#   echo -e "Enter required FIELD name: \c"
#   read field
#   fid=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field'") print i}}}' $tName)
#   if [[ $fid == "" ]]
#   then
#     echo "Not Found"
#     selectCon
#   else
#     echo -e "\nSupported Operators: [==, !=, >, <, >=, <=] \nSelect OPERATOR: \c"
#     read op
#     if [[ $op == "==" ]] || [[ $op == "!=" ]] || [[ $op == ">" ]] || [[ $op == "<" ]] || [[ $op == ">=" ]] || [[ $op == "<=" ]]
#     then
#       echo -e "\nEnter required VALUE: \c"
#       read val
#       res=$(awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>./.error.log |  column -t -s '|')
#       if [[ $res == "" ]]
#       then
#         echo "Value Not Found"
#         selectCon
#       else
#         awk 'BEGIN{FS="|"; ORS="\n"}{if ($'$fid$op$val') print $'$fid'}' $tName 2>>./.error.log |  column -t -s '|'
#         selectCon
#       fi
#     else
#       echo "Unsupported Operator\n"
#       selectCon
#     fi
#   fi
# }

selectMenu