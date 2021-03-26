#!/bin/bash

if [ -d /code-server-entrypoint.d ]; then
  for I in $(ls /code-server-entrypoint.d)
  do
    . /code-server/entrypoint.d/$I
  done
fi

code-server --bind-addr 0.0.0.0:8080

