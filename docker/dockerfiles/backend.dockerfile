# Docker config:
# 1. Ubuntu 20.04
# 2. ROS Melodic
# 3. Python 3

FROM robot_msg:test_1

# # create catkin workspace (root)
ENV CATKIN_WS=/root/backend_ws

# clone repositories into workspace and build
WORKDIR ${CATKIN_WS}

# install useful python stuff
COPY ./docker/install_scripts/install_python_packages.sh /tmp/install_python_packages.sh
RUN chmod +x /tmp/install_python_packages.sh
RUN /tmp/install_python_packages.sh

# Copy the robot software (e.g., from the repository)
COPY ./backend_ws /root/backend_ws

# Catkin build on the robot workspace
WORKDIR ${CATKIN_WS}
RUN echo "source /root/robot_msg_ws/devel/setup.bash"
RUN catkin init
RUN catkin clean -y
RUN catkin config --extend /root/robot_msg_ws/devel \
    --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
RUN catkin build
RUN echo "source /root/backend_ws/devel/setup.bash"

WORKDIR /

# Exposing the ports
EXPOSE 11311

# setup entrypoint
COPY ./docker/entrypoint_backend.sh /

ENTRYPOINT ["./entrypoint_backend.sh"]
CMD ["bash"]
