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
 
JAVA="$JAVA_HOME/bin/java JmxClient"
HOST="localhost"
PORT="7091"
ATTR="$2"

ATTR=`echo $2 | cut -d. -f1`
ELT=`echo $2 | cut -d. -f2`

for mbean in `cat $1`; do
	SUGAR_NAME=${mbean##*=}	
	echo -en "Invocation de '$2' sur le bean : '$SUGAR_NAME' : "
	$JAVA $HOST $PORT $mbean $ATTR 2>/dev/null
	if [ "$?" -ne "0" ];then
		echo -e "FAIL"
	else
		echo -e "  DONE"
	fi
done
