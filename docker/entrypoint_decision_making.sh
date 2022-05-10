#!/bin/bash
set -e

# launching state machine...
echo 'Decision making...'

sleep 5

source /root/decision_making_ws/devel/setup.bash

python3 /root/decision_making_ws/src/dm/src/talker.py

eval "bash"