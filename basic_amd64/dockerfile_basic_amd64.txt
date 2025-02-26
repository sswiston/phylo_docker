# BASE IMAGE
FROM alpine:3.19.1

# BASE SOFTWARE
WORKDIR "/"
RUN apk update && \
    apk upgrade && \
    apk add bash git unzip vim gcc g++ cmake protoc make automake autoconf curl curl-dev gfortran build-base

# PYTHON
WORKDIR "/"
RUN apk add python3 python3-dev && \
    ln -s /usr/bin/python3 /usr/local/bin/python && \
    apk add py3-pip

# R
WORKDIR "/"
RUN apk add --no-cache bzip2-dev ca-certificates pcre2-dev readline-dev xz-dev tzdata
RUN wget https://cran.r-project.org/src/base/R-4/R-4.4.0.tar.gz && \
    tar xfz R-4.4.0.tar.gz; rm R-4.4.0.tar.gz
WORKDIR "/R-4.4.0"
RUN ./configure --with-x=no --enable-R-shlib --enable-memory-profiling && \
    make -s ; make install
ENV PATH /R-4.4.0/bin:$PATH
ENV R_HOME /R-4.4.0
ENV R_LIBS_USER /R-4.4.0/library
ENV LD_LIBRARY_PATH /R-4.4.0/lib:$LD_LIBRARY_PATH

# JULIA
WORKDIR "/"
RUN wget https://julialang-s3.julialang.org/bin/musl/x64/1.10/julia-1.10.4-musl-x86_64.tar.gz && \
    tar xfz julia-1.10.4-musl-x86_64.tar.gz ; rm julia-1.10.4-musl-x86_64.tar.gz
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