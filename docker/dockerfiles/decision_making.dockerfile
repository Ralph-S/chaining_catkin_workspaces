# Docker config:
# 1. Ubuntu 20.04
# 2. ROS Melodic
# 3. Python 3

FROM robot_msg:test_1

# # create catkin workspace (root)
ENV CATKIN_WS=/root/decision_making_ws

# clone repositories into workspace and build
WORKDIR ${CATKIN_WS}

# Copy the robot software (e.g., from the repository)
COPY ./decision_making_ws /root/decision_making_ws

# Catkin build on the robot workspace
WORKDIR ${CATKIN_WS}
RUN echo "source /root/robot_msg_ws/devel/setup.bash"
RUN catkin init
RUN catkin clean -y
RUN catkin config --extend /root/robot_msg_ws/devel \
    --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
RUN catkin build
RUN echo "source /root/decision_making_ws/devel/setup.bash"

WORKDIR /

# Exposing the ports
EXPOSE 11311

# setup entrypoint
COPY ./docker/entrypoint_decision_making.sh /

ENTRYPOINT ["./entrypoint_decision_making.sh"]
CMD ["bash"]
