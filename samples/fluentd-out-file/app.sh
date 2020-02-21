#!/bin/bash

for i in {0..23}; do
  printf "2019-01-01T%02d:%02d:01+09:00\n" "${i}" "${i}"
done
