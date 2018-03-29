#!/usr/bin/env bash

set -ux

OUT_OF_THE_WAY=${JAIL:~/jail}
mkdir -p $OUT_OF_THE_WAY

LEAVES=${LEAVES:-~/leaves.txt}

NFS_ROOT=${NFS_ROOT:-/srv/www/suse-12.3/x86_64/repos}
PRIMARY_XML="repodata/*-primary.xml.gz"
DEPENDENCIES="${NFS_ROOT}/SLES12-SP3-Pool/${PRIMARY_XML} ${NFS_ROOT}/SLES12-SP3-Updates/${PRIMARY_XML}"

# sanity check
test -f repodata/repomd.xml || { echo "Must be run either from the root of an rpm-md repo or from the suse/ directory" ; exit 1 ; }

for arch in noarch x86_64 ; do
    for rpm in ${arch}/*.rpm ; do
        mv $rpm $OUT_OF_THE_WAY
        createrepo -v --update .
        installcheck x86_64 ./${PRIMARY_XML} --nocheck $DEPENDENCIES
        if [ $? -eq 0 ] ; then
            basename $rpm >> $LEAVES
        fi
        mv $OUT_OF_THE_WAY/$(basename $rpm) ${arch}/
    done
done

