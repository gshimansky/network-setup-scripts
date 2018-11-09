#!/bin/bash

if [ -z "${NFF_GO}" ]
then
    echo "You need to define NFF_GO variable which points to root of built NFF_GO repository."
    exit 1
fi

PKTGEN_DIR="${NFF_GO}/dpdk"
PKTGEN="${PKTGEN_DIR}/pktgen"

if [ -z "$1" ]
then
    PORTS=2
elif [[ $1 == "-h" || $1 == "-help" || $1 == "--help" ]]
then
     echo "Usage: runpktgen.sh [number of ports]"
     exit 0
else
    PORTS=$1
fi

echo Running pktgen with first ${PORTS} ports

c=1
m=""
for p in $(seq 0 "$((PORTS-1))")
do
    m="${m}[${c}:$((c+1))].${p}"
    if (( p < PORTS-1 ))
    then
        m+=,
    fi
    c=$((c+2))
done

CMD="${PKTGEN} -c 0xff -n 4 -- -P -m \"${m}\" -T"

echo Running pktgen with following command line: ${CMD}

(cd "${PKTGEN_DIR}"; eval sudo ${CMD})
rc=$?
if [[ $rc == 0 ]]
then
    reset
fi
