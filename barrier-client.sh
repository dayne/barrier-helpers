#!/bin/bash

# Uses BARRIER_CLIENT_NAME and BARRIER_SERVER environment variables
#   BARRIER_CLIENT_NAME=${HOSTNAME}
#   BARRIER_SERVER=servername:24800
#   BARRIER_CLIENT_RELAUNCH=true

BDIR=$HOME/.local/share/barrier/

BCFG=$BDIR/barrier.cfg
# precident given to barrier.cfg.$HOSTNAME if it is found
test -f $BDIR/barrier.cfg.${HOSTNAME} && BCFG=$_
if [ -f $BCFG ]; then
  echo "Loading $BCFG"
  source $BCFG
fi

if [ -z "$NAME"  ]; then
  BARRIER_CLIENT_NAME=${HOSTNAME}
fi

if [ -z "$BARRIER_SERVER" ]; then
  echo "Error: BARRIER_SERVER not set"
  echo "Set BARRIER_SERVER environment variable or add to ${BCFG}"
  exit 1
fi

which barrierc > /dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Error: barrierc not found - install barrier"
  exit 1
fi

if [ -z "$BARRIER_CLIENT_RELAUNCH" ]; then
  BARRIER_CLIENT_RELAUNCH=true
fi

while( true ); do
  echo "Killing any existing barrierc clients"
  killall barrierc
  echo "Launching: barrierc -f --no-tray --debug INFO --name ${BARRIER_CLIENT_NAME} --enable-crypto ${BARRIER_SERVER}"
  barrierc -f --no-tray --debug INFO --name ${BARRIER_CLIENT_NAME} --enable-crypto ${BARRIER_SERVER}
  echo 'Warning: barrierc crashed/exited'
  if [ "${BARRIER_CLIENT_RELAUNCH}" != 'true' ]; then
    exit $?
  fi
  echo "BARRIER_CLIENT_RELAUNCH=true - restarting barrierc in 5 seconds"
  sleep 5
done
