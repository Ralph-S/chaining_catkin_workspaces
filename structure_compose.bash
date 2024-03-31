#!/bin/bash

export LOCATION=BER
export SYS_NAME=1-RS1R01
export XAUTH=/tmp/.docker.xauth
export ENVIRONMENT=develop

# Ubuntu 20 fix 
xhost +local:root

 Checking XAUTH session
 if [ ! -f $XAUTH ]
 then
     xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
     if [ ! -z "$xauth_list" ]
     then
         echo $xauth_list | xauth -f $XAUTH nmerge -
     else
         touch $XAUTH
     fi
     sudo chmod a+r $XAUTH
 fi

source /opt/ros/noetic/setup.bash

# Run Docker Compose 
gnome-terminal  --title "Docker Compose" --working-directory /home/q541740/Desktop/structure_research/docker -- docker-compose up
