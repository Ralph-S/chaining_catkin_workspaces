#!/bin/bash

set -euxo pipefail

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

apt-get update

apt-get install -q -y --no-install-recommends  \
  python3-rosdep \
  python3-rosinstall-generator \
  python3-vcstool \
  build-essential \
  ros-noetic-ros-core=1.5.0-1* \
  ros-noetic-ros-comm \
  ros-noetic-control-msgs \
  ros-noetic-qt-gui-cpp \
  ros-noetic-ros-control \
  ros-noetic-control-toolbox \
  ros-noetic-realtime-tools \
  ros-noetic-ros-controllers \
  ros-noetic-xacro \
  ros-noetic-tf-conversions \
  python3-pykdl \
  liborocos-kdl-dev \
  ros-noetic-diagnostic-updater \
  ros-noetic-kdl-parser-py \
  ros-noetic-kdl-parser \
  ros-noetic-robot-state-publisher \
  ros-noetic-rgbd-launch \
  ros-noetic-rqt-image-view \
  ros-noetic-rviz \
  ros-noetic-ddynamic-reconfigure \
  && rm -rf /var/lib/apt/lists/*


pip install rospkg==1.3.0
pip install "git+https://github.com/catkin/catkin_tools.git#egg=catkin_tools"

apt-get update