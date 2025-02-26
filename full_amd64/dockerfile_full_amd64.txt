# BASE IMAGE
FROM sswiston/phylo_docker:slim_amd64

# DM-TREE
WORKDIR "/"
RUN git clone https://github.com/google-deepmind/tree.git
WORKDIR "/tree"
RUN sed -i 's/20220623.2/20240722.rc2/g' tree/CMakeLists.txt
RUN sed -i 's/773652c0fc276bcd5c461668dc112d0e3b6cde499600bfe3499c5fdda4ed4a5b/30c36fd3f54a1a2650b7e9a006139d6da24058e54a88bda21a221fba7ebf8838/g' tree/CMakeLists.txt
RUN python3 setup.py install

# PHYLOJUNCTION
# main branch commit f0f4eba (20240524)
WORKDIR "/"
RUN apk add mesa-gl hdf5-dev
RUN apk add py3-pyside6
RUN python -m pip install pysimplegui --break-system-packages
RUN git clone https://github.com/fkmendes/PhyloJunction.git
WORKDIR "/PhyloJunction/"
RUN python -m pip install --prefix /.local -e .
ENV PATH=/.local/bin:$PATH
ENV PYTHONPATH="/PhyloJunction/src"

# PYTHON PACKAGES
WORKDIR "/"
RUN apk add py3-biopython
RUN apk add py3-scipy
RUN apk add py3-seaborn
RUN apk add py3-tabulate
RUN apk add py3-matplotlib
RUN python -m pip install dendropy --break-system-packages --force-reinstall

# R PACKAGES
WORKDIR "/"
RUN apk add linux-headers libgit2-dev freetype-dev libxml2-dev fontconfig-dev harfbuzz-dev fribidi-dev libpng-dev tiff-dev jpeg-dev imagemagick-dev udunits-dev gdal-dev font-terminus font-noto font-noto-extra font-arabic-misc gmp-dev mpfr-dev gsl-dev proj-dev geos-dev texlive libpq-dev openssl-dev unixodbc-dev
# CORE
RUN mkdir /.R
RUN touch /.R/Makevars
RUN echo "PKG_CXXFLAGS += -D__MUSL__" >> /.R/Makevars
RUN echo "CXXFLAGS += -D__MUSL__" >> /.R/Makevars
RUN echo "CXX1XFLAGS += -D__MUSL__" >> /.R/Makevars
RUN cat /.R/Makevars
RUN R -e "install.packages('Rcpp',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools',dependencies=TRUE,repos='http://cran.rstudio.com/')"
# BASICS
RUN R -e "install.packages('rjson',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('data.table',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('reshape2',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('Rmpfr',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('sf',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('distributions3',dependencies=TRUE,repos='http://cran.rstudio.com/')"
# PHYLO
RUN R -e "install.packages('HDInterval',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ratematrix',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('diversitree',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('TreeSim',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(remotes); remotes::install_url(\"http://cran.nexr.com/src/contrib/TreePar_3.3.tar.gz\")"
RUN R -e "install.packages('corHMM',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('hisse',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('OUwie',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('castor',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('TESS',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('RPANDA',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(remotes); remotes::install_github(\"phenoscape/rphenoscape\")" 
RUN R -e "library(remotes); remotes::install_github(\"uyedaj/treeplyr\")"
RUN R -e "library(remotes); remotes::install_github(\"uyedaj/rphenoscate\")" 
RUN R -e "install.packages('paleobuddy',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('CRABS',dependencies=TRUE,repos='http://cran.rstudio.com/')"
# PLOTTING
RUN R -e "install.packages('cowplot',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tikzDevice',dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN R -e "library(BiocManager); BiocManager::install(\"ggtree\")"
RUN R -e "library(devtools); devtools::install_github(\"revbayes/RevGadgets\")"
RUN R -e "install.packages('FossilSim',dependencies=TRUE,repos='http://cran.rstudio.com/')"

# JULIA PACKAGES
WORKDIR "/"
RUN apk add lzo
RUN ln -s /usr/lib/libffi.so.8 /usr/lib/libffi.so.6
RUN ln -s /usr/lib/libbz2.so.1.0.8 /usr/lib/libbz2.so.1.0
RUN julia -e 'import Pkg; Pkg.update()'
RUN julia -e 'import Pkg; Pkg.add("StatsBase"); using StatsBase'
RUN julia -e 'import Pkg; Pkg.add("Combinatorics"); using Combinatorics'
RUN julia -e 'import Pkg; Pkg.add("PProf"); using PProf'
RUN julia -e 'import Pkg; Pkg.add("Distributions"); using Distributions'
RUN julia -e 'import Pkg; Pkg.add("Phylo"); using Phylo'
RUN julia -e 'import Pkg; Pkg.add("Optim"); using Optim'
RUN julia -e 'import Pkg; Pkg.add("RCall"); using RCall'
RUN julia -e 'import Pkg; Pkg.add(Pkg.PackageSpec(;name="Tapestree",version="0.3.0")); using Tapestree'
RUN julia -e 'import Pkg; Pkg.add("Parameters"); using Parameters'
RUN julia -e 'import Pkg; Pkg.add("StaticArrays"); using StaticArrays'
RUN julia -e 'import Pkg; Pkg.add("BenchmarkTools"); using BenchmarkTools'
RUN julia -e 'import Pkg; Pkg.add("SIMD"); using SIMD'
RUN julia -e 'import Pkg; Pkg.add("Setfield"); using Setfield'
RUN julia -e 'import Pkg; Pkg.add("KernelDensity"); using KernelDensity'
RUN julia -e 'import Pkg; Pkg.add("PDMats"); using PDMats'
RUN julia -e 'import Pkg; Pkg.add("SpecialFunctions"); using SpecialFunctions'
RUN julia -e 'import Pkg; Pkg.add("ExponentialUtilities"); using ExponentialUtilities'

# FINISHING
WORKDIR "/"
COPY dockerfile_full_amd64.txt /dockerfile_full_amd64.txt
COPY test.sh /test.sh
COPY start.sh /start.sh
ENV HOME="/"
CMD sleep infinity

# Command for building Docker image:
# cp Dockerfile dockerfile_full_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:full_amd64 . --progress=plain > full_amd64_build.log 2>&1