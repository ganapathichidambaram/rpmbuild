FROM registry.access.redhat.com/ubi8:latest

RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_8/home:ganapathi.repo \
      && yum install -y dnf-plugins-core \
      && yum config-manager --set-enabled powertools \
      && rpm -ivh --replacefiles http://centos.excellmedia.net/8/BaseOS/x86_64/os/Packages/centos-linux-release-8.4-1.2105.el8.noarch.rpm \
                            http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-linux-repos-8-2.el8.noarch.rpm \
                            http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-2.el8.noarch.rpm \
    && rpm -e redhat-release \
    && dnf --setopt=tsflags=nodocs --setopt=install_weak_deps=false -y distro-sync \
    && dnf install -y rpm-build rpmdevtools gcc make coreutils-common gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel mysql-devel sqlite-devel which autoconf git \
    && dnf remove -y subscription-manager dnf-plugin-subscription-manager\
    && dnf clean all \
    && rm -f /etc/yum.repos.d/ubi.repo

# Copying all contents of rpmbuild repo inside container
COPY . .

#Custom Repository
#RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_8_Stream/home:ganapathi.repo

#RUN yum install -y dnf-plugins-core

#RUN yum config-manager --set-enabled powertools

# Installing tools needed for rpmbuild ,
# depends on BuildRequires field in specfile, (TODO: take as input & install)
#RUN dnf install -y rpm-build rpmdevtools gcc make coreutils-common gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel which autoconf git

# Setting up node to run our JS file
# Download Node Linux binary
RUN curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz \
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
