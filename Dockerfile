FROM nvcr.io/nvidia/pytorch:20.12-py3

ENV https_proxy http://proxy.itc.kansai-u.ac.jp:8080
ENV http_proxy http://proxy.itc.kansai-u.ac.jp:8080

# Specify number of CPUs can be used while building Tensorflow and OpenCV.
ARG NUM_CPUS_FOR_BUILD=4

# Install sudo
RUN apt-get update && apt-get install -y sudo

RUN apt-get update -y
RUN apt-get install -y libgl1-mesa-dev

RUN apt-get -y clean all
RUN rm -rf /var/lib/apt/lists/*

# Install some useful and machine/deep-learning-related packages for Python3.
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install -r ./requirements.txt

ENV USER student
ENV HOME /home/${USER}
ENV SHELL /bin/bash
ENV DISPLAY :10

RUN groupadd -g 1002 student
RUN useradd -g 1002 -u 1002 -m -s /bin/bash ${USER}

RUN gpasswd -a ${USER} sudo

RUN echo "${USER}:student" | chpasswd

RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo '${USER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER student
