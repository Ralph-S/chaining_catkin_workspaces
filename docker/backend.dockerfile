# Initialize Image Ubuntu
FROM ros:noetic

# Set Author
LABEL author="Spexal LLC"

# Setup Distro Env
ENV ROS_DISTRO noetic

# Include ROS in .bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

# Backend Port
ENV PORT=5000

# Beirut Timezone
# Change Accordingly for any region, example Germany GMT-1
ENV TZ=GMT-2
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing python dependencies and packages
COPY ./requirements.txt /root/backend/
RUN apt-get update && apt install -y python3-pip
RUN pip3 install --no-cache-dir --upgrade -r /root/backend/requirements.txt

# Expose Backend Port
EXPOSE 5000

# Init Workspace Dir
WORKDIR /root/robot_ws

#set Robot_ws_env
ENV ROBOT_WS_ENV /root/robot_ws

COPY ./robotWS /root/robot_ws/
COPY ./config.yaml /root/robot_ws/src/backend_scripts/src
COPY ./data.json /root/robot_ws/src/backend_scripts/src
COPY ./database.py /root/robot_ws/src/backend_scripts/src
COPY ./generic_robot.py /root/robot_ws/src/backend_scripts/src
COPY ./launch_backend.bash /root/robot_ws/src/backend_scripts/src
COPY ./main_fastapi.py /root/robot_ws/src/backend_scripts/src
COPY ./requirements.txt /root/robot_ws/src/backend_scripts/src
COPY ./robot.py /root/robot_ws/src/backend_scripts/src

WORKDIR /root/robot_ws/
RUN catkin init
RUN catkin clean -y
RUN catkin config --extend /opt/ros/$ROS_DISTRO --cmake-args -DCMAKE_BUILD_TYPE=Release -DCATKIN_ENABLE_TESTING=False
RUN catkin build
RUN echo "source /root/robot_ws/devel/setup.bash" >> /root/.bashrc

# Run FAST API Backend
WORKDIR /root/robot_ws/src/backend_scripts/src

#COPY ./launch_backend.bash .

ENTRYPOINT ./launch_backend.bash