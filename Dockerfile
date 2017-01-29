FROM ubuntu:latest
MAINTAINER Joel @val314159 Ward <jward@gmail.com>
ENV HOME /root
# Install dependencies from Debian repositories
RUN apt-get update && apt-get install -y make wget bzip2 build-essential git python emacs-nox openssh-server && apt-get clean
# Install SBCL from the tarball binaries.
RUN wget http://sourceforge.net/projects/sbcl/files/sbcl/1.3.14/sbcl-1.3.14-x86-64-linux-binary.tar.bz2/download -O /tmp/sbcl.tar.bz2 && \
mkdir /tmp/sbcl && \
    tar jxvf /tmp/sbcl.tar.bz2 --strip-components=1 -C /tmp/sbcl/ && \
    cd /tmp/sbcl && \
    sh install.sh && \
    cd /tmp \
    rm -rf /tmp/sbcl/

WORKDIR /tmp/
ADD install.lisp /tmp/install.lisp
RUN wget http://beta.quicklisp.org/quicklisp.lisp && sbcl --non-interactive --load install.lisp

RUN useradd -ms /bin/bash newuser
#RUN apt-get install -y openssh-server
#RUN echo -e 'hello\\nhello' | passwd newuser
#USER newuser
#WORKDIR /home/newuser

#RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN echo 'newuser:noo'     | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 80 8080 8088 22 2222

CMD ["/usr/sbin/sshd", "-D"]
