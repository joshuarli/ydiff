#!/usr/bin/env bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)"

mkdir -p "${HERE}/tests"

cd "$1"
[[ ! -d ".git" ]] && {
    echo "${1} doesn't seem to be a git repository."
    echo "usage: ${0} path/to/git/repo"
    exit 1
}

d="${HERE}/tests/$(basename $PWD)"
mkdir -p "$d"
for i in {1..10}; do
    mkdir -v "${d}/${i}"
    git show --no-ext-diff "HEAD~${i}" > "${d}/${i}/in.diff"
    YDIFF_WIDTH=130 "${HERE}/ydiff" -s < "${d}/${i}/in.diff" > "${d}/${i}/out"
done

# TODO: git log --patch on smallish sample repos to generate HUGE diffs,
# could be useful for perf testing
