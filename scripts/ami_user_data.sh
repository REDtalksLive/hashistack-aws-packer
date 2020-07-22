#!/bin/sh
TOKEN=`cat ~/token.txt`
cd /home/ubuntu
git clone https://${TOKEN}@github.com/REDtalks/webserver-basic.git
