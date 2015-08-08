#!/bin/bash

read -p "Enter a title in English: "
#echo $REPLY
rake new_post["$REPLY"]
DATE_STR=`date -d today +"%Y-%m-%d"` > /dev/null
KEY_WD=`echo $REPLY | awk '{ print $1; }'` > /dev/null
SRC_FILE=`printf "source/_posts/%s-%s*.markdown" "$DATE_STR" "$KEY_WD"` > /dev/null
#echo $SRC_FILE

atom $SRC_FILE
