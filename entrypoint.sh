#!/bin/sh -xe

# digdag server起動
digdag server -c /etc/digdag_postgres.conf -b 0.0.0.0 \
  -P /etc/development.yml \
  -O logs/task \
  -A logs/access
  -L logs/server.log > logs/digdag_out.log 2> logs/digdag_err.log