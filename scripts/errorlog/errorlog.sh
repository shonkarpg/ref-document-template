#/bin/bash
# it will assign the conf file in filename variable.
FILENAME=$@
# Date command with date formate assign in date variable.
date=`/bin/date "+%Y.%m.%d.%H.%M.%S"`
# Assign count variable by 0 for count the line.
count=0
# While loop for read conf file Line by Line
while read LINE
do
# Assign counter variable by 0 after spliting the line it will read the word by array form 0.
counter=0
#  increase the count "After completting the task of first line it will go to 2nd line"
let count++
#echo "$count $LINE"
# Spiliting the line
for word in $LINE;
 do
# Assigning the word from array[0]
  array[counter++]=$word
#  echo "$word";
 done
#  before search keyword it will append message "start searching keyword" in Scriptlog with date.
echo -e "\n$date: start Serarching keyword" > /dev/null
# search keyword in logfile and assignd the search result in error variable.
errors=$(grep -i "${array[1]}"  "${array[0]}")
# Search result append to Scriptlog with date.
echo -e "$date:\n$errors" > /dev/null
#Overwrite the error variable contain in "current-errors.log" file.
echo "$errors" > "${array[3]}"
# It will check that "prior-errors.log" file is exist or not
if      [ -e "${array[4]}" ]
# if "prior-errors.log" file exists then it append the message in Scriptlog with date.
         then echo -e "\n$date:prior-errors.log Exists" > /dev/null
else
# if "prior-errors.log" file does not exists then it will create new blank "prior-error.log" file
touch "${array[4]}" | echo "" > "${array[4]}"
# it will append message "prior-error.log created" in Scriptlog with date.
echo -e "\n$date:\nPrior-errors.log created" > /dev/null
fi
# Before comparision . It will append message "start comparing prior and current log file" in Scriptlog.
echo -e "\n$date:Compare prior and current log file" > /dev/null
#Diffentiate the current error log file with previous error log file
newentries=$(diff --suppress-common-lines -u  "${array[4]}"  "${array[3]}")
# After comparision. It will append the compare result in Scriptlog with date.
echo -e "$date:\n$newentries" > /dev/null
# if compare result is not blank and error variable is blank then it will show No new error found
if
                test "$newentries" != "" && test "$errors" = ""
# if compare result is not blank and error variable is blank then it will append message" No new error found" in Scriptlog with date.
 then echo -e "\n $date:No New Errors found" > /dev/null
#else if compare result is not blank and also error variable is not blank then it will send email.
 elif test "$newentries" != ""
 then
echo -e "Subject:"${array[6]}" \n\n  $newentries" | /usr/sbin/sendmail -F "Casec-faceauth-batch" "${array[2]}"
# After send email. It will append message "Email send to the receipent" in Scriptlog with date.
     echo -e "\n$date:Email send to the receipent" > /dev/null
# It will overwrite the content of error variable in "prior-error.log" file
     echo "$errors" > "${array[4]}"
fi
#After that Script  end append to Scriptlog.
echo -e "\n$date:script end" > /dev/null
# Configuration file checking at the time of execution.
done < $FILENAME
