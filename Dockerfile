FROM alpine:edge
ARG UID=0
ARG GID=0
ARG USER=root
ARG GROUP=root
ARG WORKDIR=/
ENV LD_LIBRARY_PATH=/lib:/usr/lib
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/lib/racket/bin:/usr/lib/jvm/java-11-openjdk/bin
RUN apk upgrade --no-cache && \
  wget -O /glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
  apk add --allow-untrusted --no-cache \
    /glibc.apk \
    yarn nodejs npm \
    clang binutils gcc libc-dev \
    openjdk11 php7 python2 python3 rust cargo luajit go \
    make curl git bash && \
  rm /glibc.apk && \
  wget -O - https://download.racket-lang.org/releases/7.4/installers/racket-minimal-7.4-x86_64-linux.tgz | tar -xzv -C /usr/local/lib/
RUN raco pkg install --binary-lib --no-cache --batch --installation --deps force racket-doc ; \
  raco pkg install --binary-lib --no-cache --batch --installation --deps force scribble-doc ; \
  raco pkg install --binary-lib --no-cache --batch --installation --auto scribble-lib && \
  raco pkg install --binary-lib --no-cache --batch --installation --auto make && \
  raco pkg install --no-cache --batch --installation --auto rash
RUN echo "$GROUP:x:$GID:" > /etc/group && \
  echo "$USER:x:$UID:$GID:Linux User,,,:$HOME:/bin/bash" > /etc/passwd && \
  echo "$USER:!::0:::::" > /etc/shadow
USER "$UID:$GID"
WORKDIR "$WORKDIR"
