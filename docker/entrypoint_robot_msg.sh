#!/bin/bash
set -e

# launching state machine...
echo 'Robot Workspace...' 

source /root/robot_msg_ws/devel/setup.bash

roscore

eval "bash"