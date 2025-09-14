# FROM --platform=linux/amd64 ubuntu:22.04
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    gcc \
    gdb \
    gdb-multiarch \
    python3 \
    python3-pip \
    python3-dev \
    git \
    vim \
    curl \
    wget \
    file \
    strace \
    ltrace \
    binutils \
    netcat-openbsd \
    netcat-traditional \
    nmap \
    socat \
    tmux \
    tree \
    unzip \
    ssh \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# pwntools, ROPgadget
RUN pip3 install pwntools
RUN pip3 install ROPgadget

# pwndbg
RUN git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg && \
    cd /opt/pwndbg && \
    ./setup.sh

WORKDIR /root

COPY /home/jun/.vimrc /root/.vimrc

CMD ["/bin/bash"]
