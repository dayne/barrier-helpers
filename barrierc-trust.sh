#!/bin/bash

# USAGE: bash barrierc-trust.sh server-ip:24800

TRUSTED=${HOME}/.local/share/barrier/SSL/Fingerprints/TrustedServers.txt

function trust_server 
{
  BARRIER_SERVER=$1
  finger_dir=$(dirname $TRUSTED)
  echo "checking for $finger_dir"
  if [ ! -d $finger_dir ]; then
    echo "creating directory: $finger_dir"
    mkdir -p $finger_dir
  fi
  if [ ! -f $finger_dir/TrustedServers.txt ]; then
    echo "no TrustedServers.txt exists yet"
  else
    echo "warning, an existing TrustedServers.txt file exists - backing up to TrustedServer.txt.backup"
    backup_file=${finger_dir}/TrustedServers.txt.backup
    if [ ! -f $backup_file ]; then
      cp $finger_dir/TrustedServers.txt $backup_file
    else
      echo "Error: A backup file already exists. Move or remove it and re-run to proceed"
      echo "$backup_file"
      echo "not updating the existing TrustedServer.txt file"
      return 1 
    fi
  fi
  SERVER=`echo $BARRIER_SERVER | awk -F ':' '{print $1}'`
  PORT=`echo $BARRIER_SERVER | awk -F ':' '{print $2}'`
  nc -z $SERVER $PORT > /dev/null
  if [ $? -ne 0 ];then
    echo "FATAL: Unable to connect to $SERVER at port $PORT"
    echo "$ nc -z $SERVER $PORT"
    exit
  else
    echo "Verified ability to connect to $SERVER at port $PORT"
  fi
  echo "Getting $BARRIER_SERVER fingerprint and storing into TrustedServer.txt"
  echo -n | openssl s_client -connect $BARRIER_SERVER 2> /dev/null | openssl x509 -noout -fingerprint | cut -f2 -d'=' > $TRUSTED
  if [ $? -eq 0 ]; then
    echo "updated: $TRUSTED with"
    cat $TRUSTED
    return 0
  else
    echo "failed to get fingerprint from $BARRIER_SERVER"
    return 1
  fi
}

if [ ! -d $TRUSTED ]; then
  echo trusting $1
  trust_server $1
fi
