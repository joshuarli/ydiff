#!/usr/bin/env bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)"

mkdir -p "${HERE}/tests"

cd "$1"
[[ ! -d ".git" ]] && {
    echo "${1} doesn't seem to be a git repository."
    echo "usage: ${0} path/to/git/repo [# commits from head]"
    exit 1
}

d="${HERE}/tests/$(basename $PWD)"
mkdir -p "$d"

if [[ -z "$2" ]]; then
    read -n1 -p "You're about to generate a massive test from repo ${1}. Are you sure? (ENTER) "
    mkdir "${d}/1"
    git log --patch > "${d}/1/in.diff"
    YDIFF_WIDTH=130 "${HERE}/ydiff" -s < "${d}/1/in.diff" > "${d}/1/out"
    exit
fi

for i in $(seq 1 "$2"); do
    mkdir -v "${d}/${i}"
    git show --no-ext-diff "HEAD~${i}" > "${d}/${i}/in.diff"
    YDIFF_WIDTH=130 "${HERE}/ydiff" -s < "${d}/${i}/in.diff" > "${d}/${i}/out"
done

# TODO: git log --patch on smallish sample repos to generate HUGE diffs,
# could be useful for perf testing
