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

JAVA="$JAVA_HOME/bin/java JmxGetClient"
HOST=${3-"localhost"}
PORT=${4-"7091"}

ATTR=`echo $2 | cut -d. -f1`
ELT=`echo $2 | cut -d. -f2`

result=`$JAVA $HOST $PORT $1 $ATTR`

if [ "$ATTR" != "$ELT" ]; then
	result=`echo $result| cut -d{ -f2 | sed -e 's/})//' -e 's/ //g' -e 's/,/\n/g'| grep $ELT | cut -d= -f2`
fi

echo "$2:$result"
