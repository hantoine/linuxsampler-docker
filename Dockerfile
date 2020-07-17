FROM ubuntu:latest AS build

# Used instructions from http://linuxsampler.org/debian.html

RUN apt-get update && \
    TZ="America/Toronto" DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
	build-essential g++ debhelper pkg-config automake libtool fakeroot \
	subversion libsndfile1-dev doxygen uuid-dev libjack-dev dssi-dev \
	lv2-dev libsqlite3-dev flex bison libxml-parser-perl wget \
	ca-certificates unzip unrar && \
    rm -rf /var/lib/apt/lists/

WORKDIR /workdir

# Use ADD to prevent using cached sources if there is a new revision (=commit)
ADD https://svn.linuxsampler.org/svn/libgig/ libgig.html
RUN svn co https://svn.linuxsampler.org/svn/libgig/trunk/ libgig
RUN cd libgig && dpkg-buildpackage -rfakeroot -b
RUN dpkg -i libgig*.deb

# Use ADD to prevent using cached sources if there is a new revision (=commit)
ADD https://svn.linuxsampler.org/svn/linuxsampler/ linuxsampler.html
RUN svn co https://svn.linuxsampler.org/svn/linuxsampler/trunk/ linuxsampler
RUN cd linuxsampler && dpkg-buildpackage -rfakeroot -b
RUN rm *-dev_*.deb

# Download soundfonts
RUN wget http://member.keymusician.com/Member/FluidR3_GM/FluidR3_GM.zip && \
    unzip FluidR3_GM.zip && rm FluidR3_GM.zip
RUN wget http://download.linuxsampler.org/instruments/pianos/maestro_concert_grand_v2.rar &&\
    unrar e maestro_concert_grand_v2.rar && rm maestro_concert_grand_v2.rar

# Preparation of small final image
FROM ubuntu:latest 

WORKDIR /workdir
COPY --from=build /workdir/*.deb ./
COPY --from=build /workdir/*.sf2 ./
COPY --from=build /workdir/*.gig ./
RUN apt-get update && \
    TZ="America/Toronto" DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
	libasound2 libjack-jackd2-0 libsndfile1 libsqlite3-0 jackd2 netcat && \
    rm -rf /var/lib/apt/lists/ && \
    dpkg -i *.deb && \
    mkdir /usr/lib/ladspa
COPY entrypoint.sh .
COPY initial_channels.lsp .
EXPOSE 8888
ENTRYPOINT ./entrypoint.sh 
