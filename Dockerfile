FROM ubuntu:xenial

# Add the official ARM PPA and extra official repos to the apt sources
RUN echo "deb http://ppa.launchpad.net/team-gcc-arm-embedded/ppa/ubuntu xenial main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F64D33B0 && \
    sed -ri 's/^# deb /deb /g' /etc/apt/sources.list && \
    apt update

# Install toolchain and associated requirements
RUN apt install -y build-essential git-core ca-certificates libltdl-dev \
    python python-pip python-dev \
    gcc-multilib pkg-config libffi-dev qemu-system gcc-mingw-w64 \
    autoconf autotools-dev automake autogen libtool m4 realpath gettext
    
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 10

RUN pip install -U pip setuptools wheel

RUN apt install -y gcc-arm-embedded

# Print out installed version
RUN VERSION=$(dpkg -s gcc-arm-embedded | grep '^Version:' | sed -rn 's/Version: ([0-9]+\.?[0-9]?-[0-9]+q[0-9])-.*$/\1/p'); \
   echo "VERSION=$VERSION"

# Install common mbed tools and requirements
RUN pip install -U pyserial prettytable mbed-cli colorama PySerial \
    PrettyTable Jinja2 IntelHex junit-xml pyYAML requests mbed-ls \
    mbed-host-tests mbed-greentea beautifulsoup4 fuzzywuzzy


# Set mbed GCC_ARM toolchain path
RUN mbed config --global GCC_ARM_PATH "$(dirname $(which arm-none-eabi-gcc))"
RUN mbed config --list

# Clean up cache
RUN rm -rf /var/cache/apk/*
