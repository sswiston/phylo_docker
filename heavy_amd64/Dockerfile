# BASE IMAGE
FROM sswiston/phylo_docker:full_amd64

# JAVA
WORKDIR "/"
RUN apk add --no-cache openjdk17
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# BEAST2
RUN apk add gcompat
WORKDIR "/"
RUN wget https://github.com/CompEvol/beast2/releases/download/v2.7.7/BEAST.v2.7.7.Linux.x86.tgz && \
    tar zxvf BEAST.v2.7.7.Linux.x86.tgz ; rm BEAST.v2.7.7.Linux.x86.tgz
ENV PATH /beast/bin:$PATH
RUN ln -s /beast/bin/beast /usr/local/bin/beast && \
    ln -s -f /usr/lib/jvm/java-17-openjdk/lib/libjimage.so /beast/jre/lib/libjimage.so
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-17-openjdk/jre/lib/server/

# BEAGLE
WORKDIR "/"
RUN git clone --depth=1 https://github.com/beagle-dev/beagle-lib.git
WORKDIR "/beagle-lib"
RUN mkdir build
WORKDIR "/beagle-lib/build"
RUN cmake .. ; make ; make install ; cpack .

# FINISHING
WORKDIR "/"
COPY dockerfile_heavy_amd64.txt /dockerfile_heavy_amd64.txt
COPY test.sh /test.sh
COPY start.sh /start.sh
ENV HOME="/"
CMD sleep infinity

# Command for building Docker image:
# cp Dockerfile dockerfile_heavy_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:heavy_amd64 . --progress=plain > heavy_amd64_build.log 2>&1