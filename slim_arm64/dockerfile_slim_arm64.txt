# BASE IMAGE
FROM sswiston/phylo_docker:basic_arm64

# BASE SOFTWARE
RUN apk add cmake
RUN apk add protoc
RUN apk add automake
RUN apk add autoconf
RUN apk add curl
RUN apk add libcurl
RUN apk add build-base
RUN apk add boost-dev
RUN apk add linux-headers
RUN apk add libgit2-dev
RUN apk add freetype-dev
RUN apk add libxml2-dev
RUN apk add fontconfig-dev
RUN apk add harfbuzz-dev
RUN apk add fribidi-dev
RUN apk add libpng-dev tiff-dev jpeg-dev
RUN apk add imagemagick-dev
RUN apk add udunits-dev
RUN apk add gdal-dev

# REVBAYES
# stochmap_tp_dirty_merge branch commit 55c8174 (20240509)
WORKDIR "/"
RUN git clone https://github.com/revbayes/revbayes.git /revbayes
WORKDIR "/revbayes/"
RUN git checkout stochmap_tp_dirty_merge
WORKDIR "/revbayes/projects/cmake/"
RUN ./build.sh
ENV PATH /revbayes/projects/cmake:$PATH
RUN ln -s /revbayes/projects/cmake/rb /usr/local/bin/rb

# TENSORPHYLO
# tree-inference branch commit daa0aed (20240516)
WORKDIR "/"
RUN git clone https://bitbucket.org/mrmay/tensorphylo.git /tensorphylo
WORKDIR "/tensorphylo/"
RUN git checkout tree-inference
WORKDIR "/tensorphylo/build/installer/"
RUN sed -i -e 's/configure --prefix=${ncl_folder}/configure --prefix=${ncl_folder} --build=aarch64-unknown-linux-gnu/g' install.sh
RUN bash install.sh
RUN mkdir /.plugins
RUN cp /tensorphylo/build/installer/lib/libTensorPhylo.so /.plugins/libTensorPhylo.so

# R PACKAGES
RUN R -e "install.packages('devtools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(devtools); devtools::install_github(\"revbayes/RevGadgets\")"
RUN R -e "install.packages('HDInterval',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rjson',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ape',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('coda',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('cowplot',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('data.table',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggtree',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('grid',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('gridExtra',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('igraph',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('reshape2',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('BiocManager',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(BiocManager); BiocManager::install(\"ggtree\")"

# FINISHING
WORKDIR "/"
COPY dockerfile_slim_arm64.txt /dockerfile_slim_arm64.txt
COPY test.sh /test.sh
ENV HOME "/"

# Command for building Docker image:
# cp Dockerfile dockerfile_slim_arm64.txt; docker buildx build --platform=linux/arm64 -t sswiston/phylo_docker:slim_arm64 . --progress=plain > slim_arm64_build.log 2>&1