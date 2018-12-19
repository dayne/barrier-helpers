#!/bin/bash

tmux list-sessions | grep barrierc > /dev/null > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "a barrierc session already started - killing it"
  tmux kill-session -t barrierc
fi

tmux new-session -d -s barrierc -n term
tmux send-keys -t barrierc:term "$HOME/.bin/barrier-client.sh" Enter
