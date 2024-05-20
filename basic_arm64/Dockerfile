# BASE IMAGE
FROM alpine

# BASE SOFTWARE
WORKDIR "/"
RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add git
RUN apk add unzip
RUN apk add vim
RUN apk add gcc
RUN apk add g++

# PYTHON
WORKDIR "/"
RUN apk add 'python3=3.11.9-r0' 'python3-dev=3.11.9-r0'
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN apk add py3-pip

# R
WORKDIR "/"
RUN echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add 'R@community=4.4.0-r0' 'R-dev@community=4.4.0-r0'

# FINISHING
WORKDIR "/"
COPY dockerfile_basic_arm64.txt /dockerfile_basic_arm64.txt
COPY test.sh /test.sh
ENV HOME "/"

# Command for building Docker image:
# cp Dockerfile dockerfile_basic_arm64.txt; docker buildx build --platform=linux/arm64 -t sswiston/phylo_docker:basic_arm64 . --progress=plain > basic_arm64_build.log 2>&1