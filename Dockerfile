FROM centos:7

# Update yum and install wget
RUN yum -y update && \
    yum -y install git

COPY ./scripts /version-update/scripts

WORKDIR /version-update

ENV GIT_LOCATION="github.com/manas86/"
