FROM ubuntu:xenial

# Add the official ARM PPA and extra official repos to the apt sources
RUN echo "deb http://ppa.launchpad.net/team-gcc-arm-embedded/ppa/ubuntu xenial main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F64D33B0 && \
    sed -ri 's/^# deb /deb /g' /etc/apt/sources.list && \
    apt update

# Install toolchain and associated requirements
RUN apt install -y build-essential git-core ca-certificates libltdl-dev \
    python python-pip python-dev python3 python3-pip python3-dev \
    gcc-multilib pkg-config libffi-dev qemu-system gcc-mingw-w64 \
    autoconf autotools-dev automake autogen libtool m4 realpath gettext
RUN pip install -U pip setuptools wheel && \
    pip3 install -U pip setuptools wheel && \
    pip3 install cpp-coveralls

RUN apt install -y gcc-arm-embedded

# Print out installed version
RUN VERSION=$(dpkg -s gcc-arm-embedded | grep '^Version:' | sed -rn 's/Version: ([0-9]+\.?[0-9]?-[0-9]+q[0-9])-.*$/\1/p'); \
   echo "VERSION=$VERSION"

# Clean up cache
RUN rm -rf /var/cache/apk/*
