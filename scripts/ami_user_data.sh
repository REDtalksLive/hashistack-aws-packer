#!/bin/sh
TOKEN=`cat /home/ubuntu/token.txt`
cd /home/ubuntu
git clone https://${TOKEN}@github.com/REDtalks/webserver-basic.git
