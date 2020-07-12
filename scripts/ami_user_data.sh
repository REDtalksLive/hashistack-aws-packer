#!/bin/sh
TOKEN=`cat ~/token.txt`
git clone https://${TOKEN}@github.com/REDtalks/webserver-basic.git
