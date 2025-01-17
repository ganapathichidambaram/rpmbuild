# Using CentOS 7 as base image to support rpmbuild (packages will be Dist el7)
FROM centos:7

# Copying all contents of rpmbuild repo inside container
COPY . .

#Custom Repository
#RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_7/home:ganapathi.repo

# Installing tools needed for rpmbuild ,
# depends on BuildRequires field in specfile, (TODO: take as input & install)
RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_7/home:ganapathi.repo \
    && yum install -y rpm-build rpmdevtools gcc make coreutils python gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel which autoconf git qt-devel mysql-devel sqlite-devel

# Setting up node to run our JS file
# Download Node Linux binary
RUN yum clean all \
    && curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz \
    && tar --strip-components 1 -xvf node-v* -C /usr/local \
    && npm install --production

# Extract and install
#RUN tar --strip-components 1 -xvf node-v* -C /usr/local

# Install all dependecies to execute main.js
#RUN npm install --production

# All remaining logic goes inside main.js ,
# where we have access to both tools of this container and
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
