#!/bin/bash

# BARRIER_CLIENT_NAME=${HOSTNAME}
# BARRIER_SERVER=servername:24800
source $HOME/.config/barrier.cfg
if [ -z "$NAME"  ]; then
  BARRIER_CLIENT_NAME=${HOSTNAME}
fi

if [ -z "$BARRIER_SERVER" ]; then
  echo "Error: BARRIER_SERVER not set"
  exit 1
fi

which barrierc > /dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Error: barrierc not found - install barrier"
  exit 1
fi

while( true ); do
  echo "killing any existing barrierc clients"
  killall barrierc
  barrierc -f --no-tray --debug INFO --name ${BARRIER_CLIENT_NAME} --enable-crypto ${BARRIER_SERVER}
  echo 'barrierc crashed ... launching in 3'
  sleep 5
done
