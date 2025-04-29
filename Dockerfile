
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    gnupg2 \
    lsb-release \
    locales \
    python3-pip \
    bash \
    git \
    cmake \
    vim \
    nano \
    openssh-server \
    sshpass \
    iputils-ping \
    tmux \
    x11-utils \
    x11-apps \
    xvfb \
    gnome-terminal \
    && locale-gen en_US en_US.UTF-8 && update-locale

# Add ROS 2 repository and key
RUN add-apt-repository universe && \
    apt-get update && apt-get install -y curl && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS 2 Jazzy and dev tools
RUN apt-get update && \
    apt-get install -y ros-dev-tools && \
    apt-get upgrade -y && \
    apt-get install -y ros-jazzy-desktop ros-jazzy-ros-base

# Install colcon and rosdep
RUN pip3 install --break-system-packages -U colcon-common-extensions rosdep


RUN rosdep init && rosdep update

# Source ROS setup
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc

COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh

WORKDIR /root/ros2_ws

