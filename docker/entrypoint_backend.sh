#!/bin/bash
set -e

# launching state machine...
echo 'Backend Workspace...'

sleep 5

source /root/backend_ws/devel/setup.bash

python3 /root/backend_ws/src/backend/src/listener.py

eval "bash"