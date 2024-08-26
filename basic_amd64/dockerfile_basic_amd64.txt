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
RUN apk add gcc
RUN apk add g++
RUN apk add cmake
RUN apk add protoc
RUN apk add make
RUN apk add automake
RUN apk add autoconf
RUN apk add curl
RUN apk add curl-dev
RUN apk add gfortran
RUN apk add build-base

# PYTHON
WORKDIR "/"
RUN apk add python3 python3-dev
RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN apk add py3-pip

# R
WORKDIR "/"
RUN apk add --no-cache bzip2-dev ca-certificates pcre2-dev readline-dev xz-dev tzdata
RUN wget https://cran.r-project.org/src/base/R-4/R-4.4.0.tar.gz
RUN tar xfz R-4.4.0.tar.gz; rm R-4.4.0.tar.gz
WORKDIR "/R-4.4.0"
RUN ./configure --with-x=no --enable-R-shlib --enable-memory-profiling
RUN make -s ; make install
ENV PATH /R-4.4.0/bin:$PATH
ENV R_HOME /R-4.4.0
ENV R_LIBS_USER /R-4.4.0/library
ENV LD_LIBRARY_PATH /R-4.4.0/lib:$LD_LIBRARY_PATH

# JULIA
WORKDIR "/"
RUN wget https://julialang-s3.julialang.org/bin/musl/x64/1.10/julia-1.10.4-musl-x86_64.tar.gz
RUN tar xfz julia-1.10.4-musl-x86_64.tar.gz ; rm julia-1.10.4-musl-x86_64.tar.gz
ENV PATH=/julia-1.10.4/bin:$PATH
RUN ln -s /julia-1.10.4/bin/julia /usr/local/bin/julia
ENV JULIA_DEPOT_PATH=/julia-1.10.4/.julia

# FINISHING
WORKDIR "/"
COPY dockerfile_basic_amd64.txt /dockerfile_basic_amd64.txt
COPY test.sh /test.sh
ENV HOME="/"
CMD sleep infinity

# Command for building Docker image:
# cp Dockerfile dockerfile_basic_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:basic_amd64 . --progress=plain > basic_amd64_build.log 2>&1