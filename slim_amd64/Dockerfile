# BASE IMAGE
FROM sswiston/phylo_docker:basic_amd64

# BASE SOFTWARE
RUN apk add boost-dev

# REVBAYES
# stochmap_tp_dirty_merge branch commit d86165c (20241218)
WORKDIR "/"
RUN git clone https://github.com/revbayes/revbayes.git /revbayes
WORKDIR "/revbayes/"
RUN git checkout stochmap_tp_dirty_merge
WORKDIR "/revbayes/projects/cmake/"
RUN ./build.sh
ENV PATH=/revbayes/projects/cmake:$PATH
RUN ln -s /revbayes/projects/cmake/rb /usr/local/bin/rb

# TENSORPHYLO
# tree-inference branch commit b326fbf (20250213)
WORKDIR "/"
RUN git clone https://bitbucket.org/mrmay/tensorphylo.git /tensorphylo
WORKDIR "/tensorphylo/"
RUN git checkout tree-inference
WORKDIR "/tensorphylo/build/installer/"
RUN bash install.sh && \
    mkdir /.plugins && \
    cp /tensorphylo/build/installer/lib/libTensorPhylo.so /.plugins/libTensorPhylo.so

# FINISHING
WORKDIR "/"
COPY dockerfile_slim_amd64.txt /dockerfile_slim_amd64.txt
COPY test.sh /test.sh
ENV HOME="/"
CMD sleep infinity

# Command for building Docker image:
# cp Dockerfile dockerfile_slim_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:slim_amd64 . --progress=plain > slim_amd64_build.log 2>&1