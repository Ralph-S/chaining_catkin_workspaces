#!/bin/bash

set -euxo pipefail

apt-get update

# General dependencies for the python packages
apt install -y --no-install-recommends \
  python-tk \
  # ffmpeg \
  # terminator \
  # tmux \
  # vim \
  # gedit \
  # git \
  # openssh-client \
  # unzip \
  # htop \
  # libopenni-dev \
  # apt-utils \
  # usbutils \
  # dialog \
  # nvidia-settings \
  # cmake-curses-gui \
  # libyaml-dev


# Python packages
pip install \
  pyrsistent \
  # opencv-python \
  # plyfile \
  # pandas \
  # future \
  # typing \
  # requests \
  # matplotlib \
  # scipy \
  # scikit-image \
  # scikit-learn \
  # opencv-contrib-python \
  # PyYAML \
  # sphinx \
  # sphinx_rtd_theme \
  # sphinx_markdown_tables \
  # recommonmark \
  # pytest \
  # yacs \
  # jsonschema
