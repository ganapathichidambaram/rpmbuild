# Using CentOS 8 as base image to support rpmbuild (packages will be Dist el8)
FROM centos:8

# Copying all contents of rpmbuild repo inside container
COPY . .

#Custom Repository
RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_8_Stream/home:ganapathi.repo

RUN yum install dnf-plugins-core

RUN yum config-manager --set-enabled PowerTools

# Installing tools needed for rpmbuild ,
# depends on BuildRequires field in specfile, (TODO: take as input & install)
RUN yum install -y rpm-build rpmdevtools gcc make coreutils python gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel which autoconf

# Setting up node to run our JS file
# Download Node Linux binary
RUN curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz

# Extract and install
RUN tar --strip-components 1 -xvf node-v* -C /usr/local

# Install all dependecies to execute main.js
RUN npm install --production

# All remaining logic goes inside main.js ,
# where we have access to both tools of this container and
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
