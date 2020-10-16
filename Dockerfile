FROM ubuntu:16.04


RUN apt-get upgrade -y
RUN apt-get update
RUN apt-get install -y sudo ssh
#RUN ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts
RUN apt-get install -y  autoconf cmake  libssl-dev build-essential python3-dev python3-pip gcc-4.9 g++-4.9 libbz2-dev libdb++-dev libdb-dev openssl libreadline-dev autoconf libtool git ntp wget vim

WORKDIR /opt
RUN wget https://nchc.dl.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2
RUN tar xf boost_1_60_0.tar.bz2
WORKDIR /opt/boost_1_60_0
RUN ./bootstrap.sh --prefix=/usr/local --with-libraries=all --libdir=/usr/local/lib --includedir=/usr/local/include
RUN ./b2 install

WORKDIR /opt
RUN mkdir -p SounDAC

WORKDIR /opt/SounDAC

RUN git clone -b test-0.6.0 https://github.com/polispay/polis.git
WORKDIR /opt/SounDAC/SounDAC-Source
RUN git submodule update --init --recursive


RUN cmake -DBOOST_ROOT="$BOOST_ROOT" -DCMAKE_BUILD_TYPE=Release .
RUN make mused cli_wallet

RUN make install



WORKDIR /usr/local/bin/
