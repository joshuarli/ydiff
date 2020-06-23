#!/usr/bin/env bash

# SIGINT will only stop 1 loop iter, we want to abort entire test script
trap 'exit' INT

for t in tests/**/*; do
    echo "test ${t}: ydiff"
    YDIFF_WIDTH=130 time ./ydiff < "${t}/in.diff" > /tmp/out
    cmp "${t}/out" /tmp/out || diff "${t}/out" /tmp/out

    echo "test ${t}: ydiff-bin"
    YDIFF_WIDTH=130 time ./ydiff-bin < "${t}/in.diff" > /tmp/out
    cmp "${t}/out" /tmp/out || diff "${t}/out" /tmp/out
done


