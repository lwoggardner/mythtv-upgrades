FROM ubuntu:10.04

MAINTAINER Grant Gardner <grant@lastweekend.com.au>

# Set correct environment variables.
ENV HOME /root

RUN apt-get update

# Install MYSQL
ADD mysql.debconf /root/mysql.debconf
RUN debconf-set-selections /root/mysql.debconf
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
# Install --bootstrap patched MythTV from local debs

##Add multiverse repo
RUN echo "deb http://archive.ubuntu.com/ubuntu/ lucid multiverse" | tee -a /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y build-essential liblircclient-dev libasound2-dev libdts-dev libdvdnav-dev \
 libxv-dev libxxf86vm-dev transcode libmp3lame-dev qt4-dev-tools libqt4-dev libsamplerate0 \
 libxvidcore4 liba52-0.7.4-dev libfame-dev libcdio-dev libasound2-doc libmad0-dev \
 libid3tag0-dev libvorbis-dev libflac-dev libcdaudio-dev libcdparanoia0-dev fftw3-dev libfaad-dev \
 libsmpeg-dev libmp4v2-dev libtag1-dev mysql-server libvisual-0.4-dev libexif-dev libxvmc-dev \
 libxinerama-dev libfreetype6-dev yasm

# This downloads a couple of hundred Mb
ADD https://api.github.com/repos/lwoggardner/mythtv/tarball/bootstrap-0.24 /root/bootstrap-0.24.tar.gz
RUN mkdir /root/bootstrap-0.24
RUN tar -xvzf /root/bootstrap-0.24.tar.gz -C /root/bootstrap-0.24 --strip-components 1
# If you want to avoid repeatedly downloading, then download once into this directory, comment the 3 lines above
# and uncomment the one below
#ADD bootstrap-0.24.tar.gz /root


RUN ls -l /root/bootstrap-0.24

WORKDIR /root/bootstrap-0.24/mythtv


RUN ./configure
RUN make
RUN make install

WORKDIR /
RUN rm -r /root/bootstrap-0.24
RUN apt-get purge -y lib*dev  build-essential qt4-dev-tools
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /root/.mythtv
ADD mysql.txt /root/.mythtv/mysql.txt

# Prepare MYSQL - remove default db
RUN rm -rf /var/lib/mysql/*
RUN mkdir -p /var/lib/mysql

# Add MySQL configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf
#ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts

ADD mysql /root/mysql
ADD mythtv /root/mythtv
ADD migrate.sh /migrate.sh
ADD migrate_corrupted.sh /migrate_corrupted.sh

# We expect to see backups in /var/lib/mythtv/backups
VOLUME /var/lib/mythtv

EXPOSE 3306
CMD ["/migrate.sh"]

#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mythtv-backend

#ADD mythtv.debconf /root/mythtv.debconf
#ADD debs/mythtv-backend_0.27.0~master.20140907.682f5b5-0ubuntu1_amd64.deb /root/mythtv-backend.deb
#ADD debs/mythtv-common_0.27.0~master.20140907.682f5b5-0ubuntu1_amd64.deb /root/mythtv-common.deb
#ADD debs/libmyth-0.28-0_0.27.0~master.20140907.682f5b5-0ubuntu1_amd64.deb /root/libmyth.deb
#ADD debs/mythtv-transcode-utils_0.27.0~master.20140907.682f5b5-0ubuntu1_amd64.deb /root/mythtv-transcode-utils.deb

#RUN debconf-set-selections /root/mythtv.debconf
#RUN gdebi -n /root/libmyth.deb 
#RUN gdebi -n /root/mythtv-common.deb
#RUN gdebi -n /root/mythtv-transcode-utils.deb
#RUN gdebi -n /root/mythtv-backend.deb
#
#TODO after compile
#RUN apt-get purge -y lib*-dev
