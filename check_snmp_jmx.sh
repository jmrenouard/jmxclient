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
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4
if [ $# -ne "6" ]; then
	echo "option problem"
	exit $STATE_UNKNOWN
fi

PORT_OID=$1
VALUE=`snmpget $2 -c $3 -v $4 $PORT_OID -Oq | cut -d' ' -f 2 | sed -e 's!"!!g' -e 's!;! !g'| cut -d: -f2`

#echo "$1 => $VALUE"
[ "$VALUE" -lt "$5" ] && echo "$1 : $VALUE < $5 : OK" && exit $STATE_OK
[ "$VALUE" -lt "$6" ] && echo "$1 : $5 < $VALUE < $6 : WARNING" && exit $STATE_WARNING

echo "$1 => $6 < $VALUE  : CRITICAL"
exit $STATE_CRITICAL
