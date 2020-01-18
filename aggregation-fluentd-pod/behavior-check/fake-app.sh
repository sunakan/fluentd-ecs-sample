#!/bin/bash

sleep 2
gracefull_exit() {
  echo "====[ TRAPPED TERM SIGNAL, gracefull exit ]"
  exit 0
}
trap gracefull_exit TERM

echo count 300
for i in {0..300}; do
  echo pizza-${i}/300;
  sleep ${INTERVAL_SEC:-1};
done;
