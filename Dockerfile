FROM alpine:edge
MAINTAINER Cinder Roxley <cinder@sdf.org>

ENV VERSION 0.6

RUN apk add --update build-base autoconf automake shared-mime-info libc-dev \
    libevent-dev curl-dev libressl-dev libxml2-dev fuse-dev glib-dev musl-dev \ 
    libexecinfo-dev bsd-compat-headers tar curl

RUN mkdir /usr/src && \
    curl -L https://github.com/skoobe/riofs/archive/v${VERSION}.tar.gz | tar zxv -C /usr/src

# Add patches to make RioFS 0.6 build under Alpine Linux.
# In 0.7 this will hopefully be unnecessary.
ADD portability.patch /tmp/portability.patch
ADD misc.patch /tmp/misc.patch
RUN cd /usr/src/riofs-${VERSION} && \
    patch -p1 < /tmp/portability.patch && \
    patch -p1 < /tmp/misc.patch

RUN cd /usr/src/riofs-${VERSION} && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install 

RUN rm -rf /var/cache/apk/* && rm /tmp/portability.patch && rm /tmp/misc.patch

CMD ["/bin/bash"]

