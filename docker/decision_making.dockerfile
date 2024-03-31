# Docker config:
# 1. Ubuntu 20.04
# 2. ROS Melodic
# 3. Python 3

FROM ubuntu:20.04

RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ssh git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /root/tmp_code
RUN mkdir /root/tmp_thirdparty

WORKDIR /root/tmp_code

RUN mkdir /root/.ssh/

# make sure your domain is accepted
# RUN touch /root/.ssh/known_hosts
# RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

### second stage ###
# RUN echo 'Europe/Berlin' > /etc/timezone && \
#     ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
#     apt-get update && \
#     apt-get install -q -y --no-install-recommends tzdata && \
#     rm -rf /var/lib/apt/lists/*

# Locale
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Replacing shell with bash for later docker build commands
# RUN mv /bin/sh /bin/sh-old && \
#   ln -s /bin/bash /bin/sh

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
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.bashrc
RUN echo "source /opt/ros/noetic/setup.zsh" >> /root/.zshrc
RUN echo "export ROSLAUNCH_SSH_UNKNOWN=1" >> /root/.zshrc

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# create catkin workspace (root)
ENV CATKIN_WS=/root/catkin_ws
RUN source /opt/ros/$ROS_DISTRO/setup.bash
RUN mkdir -p $CATKIN_WS/src
WORKDIR ${CATKIN_WS}
RUN catkin init
RUN catkin config --extend /opt/ros/$ROS_DISTRO \
    --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
WORKDIR $CATKIN_WS/src


# clone repositories into workspace and build
WORKDIR ${CATKIN_WS}/src

# install useful python stuff
COPY ./docker/install_scripts/install_python_packages.sh /tmp/install_python_packages.sh
RUN chmod +x /tmp/install_python_packages.sh
RUN /tmp/install_python_packages.sh


# Catkin build
WORKDIR ${CATKIN_WS}
RUN catkin build
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

# Install State Machine dependencies
COPY ./docker/install_scripts/install_state_machine.sh /tmp/install_state_machine.sh
RUN chmod +x /tmp/install_state_machine.sh
RUN /tmp/install_state_machine.sh

# Copy the robot software (e.g., from the repository)
RUN mkdir /home/pickbot_10s
COPY ./pickbot_10s_ws /home/pickbot_10s/pickbot_10s_ws
ENV ROBOT_CATKIN_WS=/home/pickbot_10s/pickbot_10s_ws

# Catkin build on the robot workspace
WORKDIR ${ROBOT_CATKIN_WS}
RUN catkin init
RUN catkin clean -y
RUN catkin config --extend /opt/ros/$ROS_DISTRO \
    --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
RUN catkin build
RUN echo "source ${ROBOT_CATKIN_WS}/devel/setup.bash" >> /root/.bashrc

WORKDIR /

# Exposing the ports
EXPOSE 11311

# setup entrypoint
COPY ./docker/entrypoint_state_machine.sh /

ENTRYPOINT ["./entrypoint_state_machine.sh"]
CMD ["bash"]