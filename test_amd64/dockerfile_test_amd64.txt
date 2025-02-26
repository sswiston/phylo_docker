# BASE IMAGE
FROM alpine:3.19.1

# BASE SOFTWARE
WORKDIR "/"
RUN apk update
RUN apk upgrade
RUN apk add bash
RUN apk add git
RUN apk add unzip
RUN apk add vim

# PYTHON
WORKDIR "/"
RUN apk add python3 python3-dev
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN apk add py3-pip

# FINISHING
WORKDIR "/"
COPY dockerfile_test_amd64.txt /dockerfile_test_amd64.txt
COPY test.sh /test.sh
COPY start.sh /start.sh
ENV HOME="/"
CMD sleep infinity

# Command for building Docker image:
# cp Dockerfile dockerfile_test_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:test_amd64 . --progress=plain > test_amd64_build.log 2>&1