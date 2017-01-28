FROM ubuntu:latest
MAINTAINER Joel @val314159 Ward <jward@gmail.com>

ENV HOME /root

# Install dependencies from Debian repositories
RUN apt-get update && apt-get install -y make wget bzip2 build-essential && apt-get clean

# Install SBCL from the tarball binaries.
RUN wget http://sourceforge.net/projects/sbcl/files/sbcl/1.3.14/sbcl-1.3.14-x86-64-linux-binary.tar.bz2/download -O /tmp/sbcl.tar.bz2 && \
mkdir /tmp/sbcl && \
    tar jxvf /tmp/sbcl.tar.bz2 --strip-components=1 -C /tmp/sbcl/ && \
    cd /tmp/sbcl && \
    sh install.sh && \
    cd /tmp \
    rm -rf /tmp/sbcl/

WORKDIR /tmp/
RUN wget http://beta.quicklisp.org/quicklisp.lisp
ADD install.lisp /tmp/install.lisp
RUN sbcl --non-interactive --load install.lisp

WORKDIR /root
