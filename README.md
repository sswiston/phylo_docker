# phylo_docker

## Repository Description

(Hilariously messy notes that we will clean up.)

This repo contains Dockerfiles to configure and build Docker images for phylogenetic analyses. Each directory contains the required Dockerfile and supplementary files to build a different image. There are currently 8 images, plus 1 test image for instructional purposes.

Images are tagged based on the set of programs contained within the image ('basic', 'slim', 'full', or 'heavy') and which computer chips are supported ('amd64' or 'arm64'). Note that the 'amd64' images should function on most Intel or AMD machines regardless of operating system (Windows, Linux, or Mac OS). The 'arm64' image is for post-2019 Mac computers with Apple Silicon chips (M1, M2, etc.).

The images build on one another, so each image contains all of the programs from the previous image, plus additional programs. This is done so you don't have to download large images if you only need basic programs.

Basic Programs:
- Python 3.11.11
- R 4.4.0
- Julia 1.10.4

Slim Programs:
- All basic programs
- RevBayes stochmap_tp_dirty_merge branch commit d86165c (20241218)
- TensorPhylo tree-inference branch commit b326fbf (20250213)

Full Programs:
- All slim programs
- PhyloJunction main branch commit f0f4eba (20240524)
- Python packages
- R packages
- Julia packages

Heavy Programs:
- All full programs
- Java openjdk17
- BEAST2
- Beagle

## Directory Contents

Each image directory will contain several file types. For example, the test_amd64 image directory contains these files:

- Dockerfile: This is the actual recipe that Docker uses to build the image. The name of this file is always "Dockerfile" with a capital D and no file extension. It contains commands with instructions like RUN, ENV, and WORKDIR to build an image. These instructions tell Docker what commands to run in order to install your programs, similar to how you would install them on your own computer.

At the end of our Dockerfile, there will always be a "Finishing" section that copies certain files from the image repository into the image itself. If you run an image, you can find these files inside your container. There will also be a sleep command, which keeps a container running even if it doesn't have anything to do. Following this section, there is a comment giving a build command. This build command copies the contents of the Dockerfile into a text file to be included in the image, then builds the Docker image, piping output to a logfile in the image directory.

- dockerfile_test_amd64.txt: This is a text version of the Dockerfile, which will be included in the image itself.

- test.sh: This is a test shell script provided with each image. If you run an image and enter the command line for the container, running 'bash ./test.sh' will search for all of the programs that are supposed to be installed in the image, and state whether that program is correctly installed. Note that this script does not test whether the programs are fully functional.

- start.sh: Not all images have a start.sh script. This script is used on the RIS computing cluster, which resets some environmental variables when running an image. By running 'bash ./start.sh' after starting the container, the appropriate environmental variables will be set within the container, including paths to included programs.

- test_amd64_build.log: This is a build log for the image, showing how the build completed. It will not be included in the Docker image but can provide important information for debugging during the build process. Ideally, a complete version of the build log WITHOUT cache will be committed to the phylo_docker repository alongside every new image.

## Build Instructions

Example for test_amd64
- Start in the directory for the image you want to build, e.g. test_amd64/
- Update Dockerfile to have program you want containers to have
    - For example:
        ```
        WORKDIR "/"
        RUN apk add python3 python3-dev
        RUN ln -s /usr/bin/python3 /usr/local/bin/python
        RUN apk add py3-pip
        ```
    - Make sure to note branch/commit/version/date in the Dockerfile
    - Make sure to update the "Finishing" section and run command at the end of the Dockerfile to include the correct names for files, e.g. dockerfile_test_amd64.txt and test_amd64_build.log, plus the image name and tag
        ```
        WORKDIR "/"
        COPY dockerfile_test_amd64.txt /dockerfile_test_amd64.txt
        COPY test.sh /test.sh
        ENV HOME="/"
        CMD sleep infinity

        # Command for building Docker image:
        # cp Dockerfile dockerfile_test_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:test_amd64 . --progress=plain > test_amd64_build.log 2>&1
        ```
    - If you use the command at the end of the Dockerfile, the contents of the Dockerfile will be copied into container as (e.g.) dockerfile_test_amd64.txt. If not, you should do this manually - DockerHub does not keep track of the Dockerfiles that are used to create images!
- Update the test.sh script
    - This script checks to make sure the install works, so you should add commands that check for your new programs
        ```
        echo ""; echo "Checking for python..."; echo ""
        python --version
        ```
- Update the start.sh script (if there is one)
    - This script can be run to set environmental variables when containers are used on RIS, so make sure to add any new environmental variables from your Dockerfile to this script as well.
        ```
        export PATH=/usr/local/bin:/.local/bin:/usr/lib/python3.11/site-packages:$PATH
        export PYTHONPATH=/PhyloJunction/src
        ```
- Start up the Docker daemon by opening Docker Desktop
- Run the docker build command (provided in a comment at the end of the Dockerfile)
    - Instructions for the lab server:
        - For now you need sudo; ideally, we will give all users permission for this.
        - Create a tmux/screen session so that it continues building when you log off
        - The --no-cache flag will erase all previously built software/packages and give you a fresh install for the image. However, if there is a FROM command at the beginning of the Dockerfile, the build will use a local version of the FROM image (if it can find one). Make sure to pull your base image again!
        - You may want to disable --no-cache if you trust your current image and only want to add one new package, etc.
        - `cp Dockerfile dockerfile_slim_amd64.txt; docker build --no-cache -t sswiston/phylo_docker:test_amd64 . --progress=plain > test_amd64_build.log 2>&1`
- Test the image locally
    - First, open the build log in the image directory to verify that your build worked, e.g. test_amd64_build.log. Note that an image may successfully build, but software may not be installed correctly.
    - Run a container using the new image, either through Docker Desktop or via command line:
        - `sudo docker run --name test_container -it sswiston/phylo_docker:test_amd64 /bin/bash`
    - In the container's terminal, run `bash test.sh` to check if your container has all packages you expect it to have
- If you push the image to the phylo_docker repository on DockerHub, make sure to update the hub README to contain the new programs.
- If you are designing an image that you plan to use on RIS, make sure to ALSO test it on RIS, because containers function differently on the cluster. You will have to push the image to DockerHub before you can pull it for an RIS job.

IMPORTANT NOTE: If you are building an image for ARM64 on an AMD64 machine or vice versa, you will need to use buildx. This will probably require installing quemu.

For building an ARM64 image on an AMD64 machine:
# https://stackoverflow.com/questions/73253352/docker-exec-bin-sh-exec-format-error-on-arm64
`docker buildx ls`     # lists hardware buildx can emulate
`sudo apt-get install -y qemu qemu-user-static`        # installs Mac OS X emulation stuff
`sudo docker buildx prune`
`sudo docker buildx build --platform=linux/arm64 --no-cache -t sswiston/phylo_docker:test_arm64 . --progress=plain > test_arm64_build.log 2>&1`

WORKFLOW SUMMARY:
- Update Dockerfile to contain proper programs
- Update comments in Dockerfile to contain proper versions
- Update Dockerfile to copy correct test and startup scripts
- Update test script
- Update startup script (if there is one)
- Copy dockerfile to correct location before build (part of the build command at the bottom)
- Build the Docker image
- Test the Docker image locally
- Push the image to hub
- Update the hub README
- Test on RIS

RECOMMENDATIONS:
- The number of layers allowed in a Docker image is limited! New layers are created by each Docker command (RUN, ENV, WORKDIR, etc.), so try to combine commands using operations like &&