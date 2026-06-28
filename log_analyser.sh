#Log Analyser script
#! /bin/bash

LOG_FILE=$1

#checking if not passing any command line argument or 0 argument
if [ $# -ne 1 ]
then
    echo "This file does not exist !"
    exit 1
fi

#check log file path exist or not

if [ ! -f $LOG_FILE]
then
    echo " Log file does not exist"
    exit 1
fi

#report generation

REPORT_DIR=./report
REPORT_FILE="$REPORT_DIR/report-$(date +%Y-%m-%d_%H-%M-%S).txt"

mkdir -p $REPORT_DIR

echo "-------Check count errors-----------"
count_error=$(grep -c "COUNT" "$LOG_FILE")
count_warning=$(grep -c "WARNING" "$LOG_FILE")
count_info=$(grep -c "INFO" "$LOG_FILE")
total_count=$(wc -l < $LOG_FILE)
file_size=$(du -h "$LOG_FILE" | awk '{print $1}')

#generate report
{
echo "----------------------------"
echo "-------Report Generation---------"
echo "Report Generated on : $date"
echo "Log file name : $LOG_FILE"
echo "File size : $file_size"

echo "-------counts--------"
echo "Error Count : $count_error"
echo "Warning Count : $count_warning"
echo "Info Count : $count_info"

echo 
echo "------------Top 10 Errors------------"
grep "ERROR" "$LOG_FILE" | sort | uniq -c | sort -nr | head -10 
grep "ERROR" "$LOG_FILE" | tail -5
} > "$REPORT_FILE"

echo "Report file generated successfully at location : $REPORT_FILE"
