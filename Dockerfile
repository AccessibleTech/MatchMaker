# base-image for python on any machine using a template variable,
# see more about dockerfile templates here:http://docs.resin.io/pages/deployment/docker-templates
FROM resin/edison-python:3.5

# use apt-get if you need to install dependencies,
RUN add-apt-repository ppa:mraa/mraa && \
    apt-get update && apt-get install -yq bluez \
                                          bluez-tools \
																					libbluetooth-dev \
																					libboost-python-dev \
                                          libboost-thread-dev \
                                          libglib2.0-dev \
                                          libupm-dev \
                                          python-upm \
                                          python3-upm \
                                          rfkill \
                                          upm-examples && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Keep device discoverable
ADD main.conf /etc/bluetooth/main.conf

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
CMD ["python","src/main.py"]
