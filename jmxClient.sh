#!/bin/sh
#------------------------------------------------------------------------------
#
# MyRPM - Rpm Utilities
# Copyright (c) Jean-Marie RENOUARD 2014 - LightPath
# Contact : Jean-Marie Renouard <jmrenouard at gmail.com>
#
# This program is open source, licensed under the Artistic Licence v2.0.
#
# Artistic Licence 2.0
# Everyone is permitted to copy and distribute verbatim copies of
# this license document, but changing it is not allowed.
#
#------------------------------------------------------------------------------

TMP_DIR=/tmp
MD5_SUM=$(echo "$1_$2" | md5sum | cut -d' ' -f 1)

TMP_FILE="$TMP_DIR/$MD5_SUM.dat"

if [ -e "$TMP_FILE" ]; then
	DATE_TMP_FILE=$(stat -c '%Y' $TMP_FILE)
	DATE=$(date +%s)
	
	DIFF_DATE=$(echo "$DATE-$DATE_TMP_FILE"|bc)
	
	if [ "$DIFF_DATE" -lt "200" ]; then
		echo "$2:`cat $TMP_FILE`"
		exit 0
	fi
fi
#Recherche de la derniere version  d'un repertoire
echo_last_installed_version() {
        echo `ls -1tr -d $1/* | grep $2 | tail -n 1`
}


JAVA="$JAVA_HOME/bin/java JmxClient"
HOST="localhost"
PORT="7091"
ATTR="$2"

ATTR=`echo $2 | cut -d. -f1`
ELT=`echo $2 | cut -d. -f2`

result=`$JAVA $HOST $PORT $1 $ATTR`

if [ "$ATTR" != "$ELT" ]; then
	result=`echo $result| cut -d{ -f2 | sed -e 's/})//' -e 's/ //g' -e 's/,/\n/g'| grep $ELT | cut -d= -f2`
fi

echo "$result" > $TMP_FILE
echo "$2:$result"
