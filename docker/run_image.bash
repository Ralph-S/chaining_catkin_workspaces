# run from parent directory

# Parameters
IMAGE=robot_msg:test_1
XAUTH=/tmp/.docker.xauth
ENVIRONMENT=develop
LOCATION=MUC
SYS_NAME=structure_research
VISION_MODE=${LOCATION}_${SYS_NAME}
ROBOT_CATKIN_WS=/home/q541740/Desktop/structure_research/robot_msg_ws

# Ubuntu 20 fix
xhost local:root

docker run -it \
    --ipc=host \
    -v /dev/bus/usb:/dev/bus/usb \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --env="LOCATION=$LOCATION" \
    --env="SYS_NAME=$SYS_NAME" \
    --env="ENVIRONMENT=$ENVIRONMENT" \
    --volume="$XAUTH:$XAUTH" \
    --env="TZ=Europe/Berlin" \
    --volume="/home/robotics/.ros/log:/root/.ros/log" \
    --privileged \
    --net=host \
    ${IMAGE}


