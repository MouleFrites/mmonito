#!/bin/bash
#MoulesFrites 2023

ENDPOINT_FILE="./endpoint.conf"
MODE="normal"
MAIL_FILE="./mail.conf"

function print_usage()
{
  echo "Usage :"
  echo "$0 [ -e ENDPOINT_FILE] [ -m MODE (light/normal/hard)]"
  echo "µmonito can simply monitor your endpoint or ip adress"
  echo " "
  echo "Default values :"
  echo "    ENDPOINT_FILE : $ENDPOINT_FILE"
  echo "    MODE : $MODE"
  echo "    MAIL_FILE : $MAIL_FILE"
}

function https_test()
{
    RETURN_CODE=$(curl -k -s -o /dev/null -I -w "%{http_code}" $1)
    if ! [[ $RETURN_CODE == 3* ]] || [[ $RETURN_CODE == 2* ]]; then
        send_alert $1 $2
    fi
}

function ping_test()
{
    RESULT=true
    ping -w 5 $1 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        RESULT=true
    else
        RESULT=false
    fi
    if [ $RESULT == false ]; then
        send_alert $1 $2
    fi
}

function send_alert(){

    cat $MAIL_FILE | while read line || [[ -n $line ]];
    do
        if [[ "$line" =~ ^#.* ]]; then
            false
        else
            for i in $line;
            do
                {
                    echo "Error in your system :"
                    echo "  $1 is unrechable via $2"
                    echo " "
                    echo "Please watch your system"
                } | mail -s "$1 is unreachable" $i
            done
        fi
    done
}

while getopts e:m:h option
do
  case $option in
    f)  FILE=$OPTARG ;;
    m)  MODE=$OPTARG ;;
    h)  print_usage ;;
    ?)  print_usage ;;
  esac
done



cat $ENDPOINT_FILE | while read line || [[ -n $line ]];
do
    if [[ "$line" =~ ^#.* ]]; then
        false
    else
        TARGET=$(echo $line | cut -d , -f1)
        METHOD=$(echo $line | cut -d , -f2)
        case $METHOD in
            https)  https_test $TARGET $METHOD;;
            ping)   ping_test $TARGET $METHOD;;
        esac
    fi
done