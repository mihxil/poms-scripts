#!/bin/bash

if [ -z "$1" ] ; then
    echo use "$0 <id>"
    exit
fi

SOURCE=$(readlink  $BASH_SOURCE)
if [[ -z "$SOURCE" ]] ; then
    SOURCE=$BASH_SOURCE
fi
source $(dirname ${SOURCE[0]})/creds.sh
source $(dirname ${SOURCE[0]})/functions.sh


if [[ -z "$FOLLOW_MERGES" ]] ; then
    FOLLOW_MERGES=true
fi


target=$(getUrl media/$(rawurlencode "$1"))?followMerges=$FOLLOW_MERGES

echo $user >&2

echo $target >&2

$CURL  -s --insecure -f  -o- --user $user --header "Content-Type: application/xml" -X GET \
    ${target} | xmllint -format -

status=${PIPESTATUS[0]}
if [ $status = 22 ] ; then
    echo "Error code > 400" >&2
fi
