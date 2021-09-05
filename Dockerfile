FROM registry.access.redhat.com/ubi8:latest

#LABEL maintainer="The CentOS Project"

#LABEL com.redhat.component="centos-stream-container" \
#      name="centos-stream" \
#      version="8"

#LABEL com.redhat.license_terms="https://centos.org/legal/licensing-policy/"

#LABEL summary="Provides a CentOS Stream container based on the Red Hat Universal Base Image"
#LABEL description="CentOS Stream is a continuously delivered distro that tracks just ahead of Red Hat Enterprise Linux development. This image takes the Red Hat UBI and layers on content from CentOS Stream"
#LABEL io.k8s.display-name="CentOS Stream 8"
#LABEL io.openshift.expose-services=""
#LABEL io.openshift.tags="base centos centos-stream"


RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_8/home:ganapathi.repo \
	&& yum install -y dnf-plugins-core \
#	&& yum config-manager --set-enabled powertools \
	&& rpm -ivh --replacefiles http://centos.excellmedia.net/8/BaseOS/x86_64/os/Packages/centos-linux-release-8.4-1.2105.el8.noarch.rpm \
				http://centos.excellmedia.net/8/BaseOS/x86_64/os/Packages/centos-linux-repos-8-2.el8.noarch.rpm \
                           http://centos.excellmedia.net/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-2.el8.noarch.rpm \
    && rpm -e redhat-release \
    && yum config-manager --set-enabled powertools \
    && yum install -y epel-release \
   && rpm -ivh https://pkgs.dyn.su/el8/base/x86_64/raven-release-1.0-1.el8.noarch.rpm \
    && dnf --setopt=tsflags=nodocs --setopt=install_weak_deps=false -y distro-sync \
    && dnf install -y rpm-build rpmdevtools gcc make coreutils-common gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel which autoconf git mysql-devel sqlite-devel \
    && dnf install -y --allowerasing  qt-devel \
    && curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz \
    && tar --strip-components 1 -xvf node-v* -C /usr/local \
    && npm install --production \
    && dnf remove -y epel-release \
    && dnf remove -y subscription-manager dnf-plugin-subscription-manager \
    && dnf clean all \
    && rm -f /etc/yum.repos.d/*.repo

# Copying all contents of rpmbuild repo inside container
COPY . .

#Custom Repository
#RUN curl -o /etc/yum.repos.d/ganapathi.repo https://download.opensuse.org/repositories/home:/ganapathi/CentOS_8/home:ganapathi.repo

#RUN yum install -y dnf-plugins-core

#RUN yum config-manager --set-enabled powertools

# Installing tools needed for rpmbuild ,
# depends on BuildRequires field in specfile, (TODO: take as input & install)
#RUN dnf install -y rpm-build rpmdevtools gcc make coreutils-common gcc-c++ openssl-devel lksctp-tools-devel doxygen-doxywizard postgresql-devel speex-devel alsa-lib-devel amrnb-devel gsm-devel dahdi-tools-devel which autoconf git

# Setting up node to run our JS file
# Download Node Linux binary
#RUN curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz

# Extract and install
#RUN tar --strip-components 1 -xvf node-v* -C /usr/local

# Install all dependecies to execute main.js
#RUN npm install --production

# All remaining logic goes inside main.js ,
# where we have access to both tools of this container and
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
