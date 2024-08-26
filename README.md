# phylo_docker

(Hilariously messy notes that we will clean up.)

This repo contains Dockerfiles to configure and build Docker images for phylogenetic analyses.


Docker types

basic
slim
full
heavy


## Build instructions


Example for slim_amd64
- Be in directory for image you want to build
- Dockerfile: actual recipe Docker uses to build
    - Update Dockerfile to have program you want containers to have
    - For example:
        ```
        WORKDIR "/"
        RUN git clone https://github.com/revbayes/revbayes.git /revbayes
        WORKDIR "/revbayes/"
        RUN git checkout stochmap_tp_dirty_merge
        WORKDIR "/revbayes/projects/cmake/"
        RUN ./build.sh
        ```
    - Make note branch/commit/version/date in Dockerfile
    - Contents of Dockerfile are copied into container as (e.g.) dockerfile_slim_amd64.txt

- test.sh
    - checks to make sure the install works
    - shell script that calls software that is supposed to be installed
    - run `bash test.sh` to know if your container has all packages you expect it to have

- start.sh (full has one)
    - set up RIS filesystem stuff, etc.
    - RIS will UNSET may of your container's environmental variables 
    - this will restore what you want


- To build:
    - (for now, need sudo; ideally, give all users permission for this)
    - Create a tmux/screen session so that it continues building when you log off
    - The --no-cache flag will erase all previously built software/packages and give you a fresh install for the image.
    - You may want to disable --no-cache if you trust your current image and only want to add one new package, etc.
    - sudo docker build --no-cache -t sswiston/phylo_docker:basic_amd64_test . --progress=plain

- Test container:
    - Open build log to verify
    - Create container from new image:
        `sudo docker run --name phylodocker_demo -it sswiston/phylo_docker:basic_amd64_test /bin/bash`
    - Run test.sh within container
        `bash /test.sh`



For ARM64:
# https://stackoverflow.com/questions/73253352/docker-exec-bin-sh-exec-format-error-on-arm64
docker buildx ls     # lists hardware buildx can emulate
sudo apt-get install -y qemu qemu-user-static        # installs Mac OS X emulation stuff


sudo docker buildx prune
sudo docker buildx build --platform=linux/arm64 --no-cache -t sswiston/phylo_docker:basic_arm64_test . --progress=plain
