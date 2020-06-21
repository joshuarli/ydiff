#!/usr/bin/env bash

# SIGINT will only stop 1 loop iter, we want to abort entire test script
trap 'exit' INT

for t in tests/*; do
    echo
    echo "test ${t}"
    # XXX: can't rely on -w0 for fixture generation
    # assume -w80 for now
    ./ydiff.py -c always -w80 --wrap -s < "${t}/in.diff" > /tmp/out
    cmp "${t}/out" /tmp/out || diff "${t}/out" /tmp/out
done
