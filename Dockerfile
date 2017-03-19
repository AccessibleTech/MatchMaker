# base-image for python on any machine using a template variable,
# see more about dockerfile templates here:http://docs.resin.io/pages/deployment/docker-templates
FROM resin/edison-python:3.5

# use apt-get if you need to install dependencies,
RUN apt-get update && apt-get install -yq bluez \
                                          bluez-tools \
                                          cmake \
																					libbluetooth-dev \
																					libboost-python-dev \
                                          libboost-thread-dev \
                                          libglib2.0-dev \
                                          rfkill && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Keep device discoverable
ADD main.conf /etc/bluetooth/main.conf

# Build SWIG
ENV SWIG_VERSION 3.0.12
RUN curl -sSL https://downloads.sourceforge.net/project/swig/swig/swig-$SWIG_VERSION/swig-$SWIG_VERSION.tar.gz \
		| tar -C /usr/src -xz && \
    cd /usr/src/swig-$SWIG_VERSION && \
    ./configure && \
    make && \
    make install && \
    rm -rf /usr/src/swig-$SWIG_VERSION

# Build UPM
ENV UPM_VERSION 1.1.0
RUN curl -sSL https://github.com/intel-iot-devkit/upm/archive/v$UPM_VERSION.tar.gz | tar -C /usr/src -xz && \
    cd /usr/src/upm-$UPM_VERSION && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILDSWIGNODE=OFF && \
    make && \
    make install && \
		rm -rf /usr/src/upm-$UPM_VERSION

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY ./requirements.txt /requirements.txt

# pip install python deps from requirements.txt on the resin.io build server
RUN pip install -r /requirements.txt

# This will copy all files in our root to the working  directory in the container
COPY . ./

# switch on systemd init system in container
ENV INITSYSTEM on

# main.py will run when container starts up on the device
CMD ["python", "app.py"]
