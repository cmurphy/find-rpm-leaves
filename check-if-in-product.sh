#!/usr/bin/env bash

set -ux

# Hand-prune the list from find-leaves.sh for obviously wrong results
PRUNED_LEAVES=${PRUNED_LEAVES:-~/pruned-leaves.txt}

PROPOSAL_TO_REMOVE=${REMOVE:-~/remove.txt}

# Run from a directory containing all the relevant source code, eg all crowbar repos and/or all ardana repos
while read -r rpm ; do
    pkg=$(echo $rpm | sed -e 's/[0-9\.\-]*\(~dev.*\|+git.*\)*[0-9\.\-]*\.\(x86_64\|noarch\)\.rpm$//')
    if ! grep -r $pkg . ; then
        echo $rpm >> $PROPOSAL_TO_REMOVE
    fi
done < $PRUNED_LEAVES
