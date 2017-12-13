#!/bin/bash

if test -z "$1"
then
   echo "Usage $0 <email>"
   exit 0
fi



CURRENCY="xmr"
CORES_MINER=3
MS_IDLE_TO_START=60000
MS_IDLE_TO_STOP=60000
PID_FILE=/tmp/minergate_script.pid
IDLE_MS=`xprintidle`


if ! test -f $PID_FILE
then
   echo 999999 > $PID_FILE
fi

PID=`cat $PID_FILE`

#echo "[script: `date`] pid=$PID" >> /var/log/minergate.log 
#echo "[script: `date`] idle ms=$IDLE_MS" >> /var/log/minergate.log 

# if minergate is running
if kill -0 $PID 2&> /dev/null
then
   if [ "$IDLE_MS" -lt $MS_IDLE_TO_STOP ]
   then
      echo "[script: `date`] stop mining" >> /var/log/minergate.log 
      kill $PID
   fi
else
   if [ "$IDLE_MS" -gt $MS_IDLE_TO_START ]
   then
      echo "[script: `date`] start mining" >> /var/log/minergate.log 
      minergate-cli -user $1 $CURRENCY $CORES_MINER 2&>> /var/log/minergate.log &
      PID=$!
      echo $PID > $PID_FILE
      disown
   fi
fi





