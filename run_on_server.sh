#!/bin/bash

if test -z "$1"
then
   echo "Usage $0 <email>"
   exit 0
fi



CURRENCY="xmr"
CORES=`nproc`
CORES_OFFSET=1
CORES_MINER=3
PID_FILE=/tmp/minergate_script.pid
CORES_USED=`uptime | cut -d':' -f5 | cut -d',' -f1`


if ! test -f $PID_FILE
then
   echo 999999 > $PID_FILE
fi

PID=`cat $PID_FILE`



# if minergate is running
if kill -0 $PID
then
   if [ "$CORES_USED" -ge $CORES ]
   then
      echo "[script: `date`] stop mining" >> /var/log/minergate.log 
      kill $PID
   fi
else
   if [ "$CORES_USED" -eq 0 ]
   then
      echo "[script: `date`] start mining" >> /var/log/minergate.log 
      minergate-cli -user $1 $CURRENCY $CORES_MINER 2&>> /var/log/minergate.log &
      PID=$!
      echo $PID > $PID_FILE
      disown
   fi
fi





