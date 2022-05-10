# Docker config:
# 1. Ubuntu 20.04
# 2. ROS Melodic
# 3. Python 3

FROM ubuntu:20.04


RUN mkdir /root/tmp_code
RUN mkdir /root/tmp_thirdparty

WORKDIR /root/tmp_code

RUN mkdir /root/.ssh/

# Locale
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# install basic system stuff
COPY ./docker/install_scripts/install_basic.sh /tmp/install_basic.sh
RUN chmod +x /tmp/install_basic.sh
RUN /tmp/install_basic.sh

# install python3
COPY ./docker/install_scripts/install_python3.sh /tmp/install_python3.sh
RUN chmod +x /tmp/install_python3.sh
RUN /tmp/install_python3.sh

# install ROS stuff
ENV ROS_DISTRO noetic
COPY ./docker/install_scripts/install_ros.sh /tmp/install_ros.sh
RUN chmod +x /tmp/install_ros.sh
RUN /tmp/install_ros.sh

# bootstrap rosdep
RUN rosdep init && rosdep update
RUN echo "source /opt/ros/noetic/setup.bash"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# # create catkin workspace (root)
ENV CATKIN_WS=/root/robot_msg_ws

# clone repositories into workspace and build
WORKDIR ${CATKIN_WS}

# install useful python stuff
COPY ./docker/install_scripts/install_python_packages.sh /tmp/install_python_packages.sh
RUN chmod +x /tmp/install_python_packages.sh
RUN /tmp/install_python_packages.sh

# Copy the robot software (e.g., from the repository)
COPY ./robot_msg_ws /root/robot_msg_ws

# Catkin build on the robot workspace
WORKDIR ${CATKIN_WS}
RUN catkin init
RUN catkin clean -y
RUN catkin config --extend /opt/ros/$ROS_DISTRO \
    --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
RUN catkin build
RUN echo "source /root/robot_msg_ws/devel/setup.bash"

WORKDIR /

# Exposing the ports
EXPOSE 11311

# setup entrypoint
COPY ./docker/entrypoint_robot_msg.sh /

ENTRYPOINT ["./entrypoint_robot_msg.sh"]
CMD ["bash"]
