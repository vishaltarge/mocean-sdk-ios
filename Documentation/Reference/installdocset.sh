#!/usr/bin/env bash

DIR="$( cd "$( dirname "$0" )" && pwd )"

sudo rm -rf  "/Library/Developer/Shared/Documentation/DocSets/AdMobile SDK Documentation.docset"
sudo cp -r "${DIR}/AdMobile SDK Documentation.docset" "/Library/Developer/Shared/Documentation/DocSets/"