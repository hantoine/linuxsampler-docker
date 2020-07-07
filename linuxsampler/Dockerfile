FROM ubuntu:latest AS build

# Used instructions from http://linuxsampler.org/debian.html

RUN apt-get update && \
    TZ="America/Toronto" DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
	build-essential g++ debhelper pkg-config automake libtool fakeroot \
	subversion libsndfile1-dev doxygen uuid-dev libjack-dev dssi-dev \
	lv2-dev libsqlite3-dev flex bison libxml-parser-perl && \
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

# Preparation of small final image
FROM ubuntu:latest 

COPY --from=build /workdir/*.deb /workdir/
RUN apt-get update && \
    TZ="America/Toronto" DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y --no-install-recommends \
	libasound2 libjack-jackd2-0 libsndfile1 libsqlite3-0 jackd2 && \
    rm -rf /var/lib/apt/lists/ && \
    dpkg -i /workdir/*.deb && \
    mkdir /usr/lib/ladspa
COPY entrypoint.sh /usr/local/bin
EXPOSE 8888
ENTRYPOINT entrypoint.sh 
