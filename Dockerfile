FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Yocto SDK dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential locales wget curl git xz-utils cpio diffstat python3 python3-pip \
    python3-pexpect chrpath socat libsdl1.2-dev xterm unzip sudo vim file \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Work in /opt
WORKDIR /opt

# Copy LFS SDK installer
COPY *.sh /tmp/sdk-installer.sh

# Install SDK
RUN chmod +x /tmp/sdk-installer.sh \
    && yes | /tmp/sdk-installer.sh  \
    && rm /tmp/sdk-installer.sh

# Source environment for all shells
RUN echo ". /opt/y//opt/y/environment-setup-cortexa9t2hf-neon-poky-linux-gnueabi" >> /etc/bash.bashrc

# Create a user
RUN useradd -ms /bin/bash devuser && echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER devuser

WORKDIR /workspace
CMD ["/bin/bash"]
