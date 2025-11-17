> [!IMPORTANT]
> We are no longer actively maintaining this repository. All active work by the Allen Institute for Cell Science is located under the **[AllenCell](https://github.com/AllenCell)** organization.

# PyTorch + Jupyter + GPUs

Creates a docker image for running PyTorch on NVIDIA GPUs with Jupyter notebook support

## Structure

- There's a "regular" dockerfile in the `jupyter` subdirectory.  It adds useful python libraries to the pytorch docker image.  This is sort of our "base" image.

- There are "fancy" versions in the `jupyter_R` and `jupyter_R_julia` subdirectories, which also have R and Julia installed and set up to work with Jupyter.  The `jupyter_R` version is built off of the `jupyter` image, and `jupyter_R_julia` is built off of `jupyter_R`.

- If you just want to run things and not build them yourself, use `docker pull rorydm/pytoch_extras:<tag>` where `<tag>` is (say) `jupyter_R_julia` to pull the prebuilt images from docker hub.

- To build any of the images yourself, from the main directory use `bash build_dockerfile.sh <subdir_name>`.

- Run any of them from the main directory by using `bash run_docker_image.sh <subdir_name> <port>`, where `<port>` is the port you're forwarding out of the docker container, e.g. 9699.


## Detailed Installlation Instructions
- On an Ubuntu system (e.g. aws) install current nvidia drivers:
  - `sudo add-apt-repository ppa:graphics-drivers/ppa`
  - `sudo apt-get update && sudo apt-get install nvidia-390`

- Install nvida docker (and docker): https://github.com/NVIDIA/nvidia-docker
  - `curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -`
  - `curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list`
  - `sudo apt-get update`
  - `sudo apt-get install -y nvidia-docker2`
  - `sudo pkill -SIGHUP dockerd`

- Install pytorch on docker: https://github.com/pytorch/pytorch
  - `git clone https://github.com/pytorch/pytorch.git`
  - `cd pytorch && docker build -t rorydm/pytorch:master .`

- Clone this repo next to the pytorch one and run the build script
  - `bash build_dockerfile.sh jupyter` to first build the minimally extended version
  - `bash build_dockerfile.sh jupyter_R` to next build the version with R
  - `bash build_dockerfile.sh jupyter_R_julia` to next build the version with R and Julia

- To run and start a jupyter server (maybe start a screen session first), from this directory:
  - `bash run_docker_image.sh <subdir_name> <port>`

- To enter the running docker container:
  - `docker exec -it <container_name> bash`

Note: the terminal inside docker sometimes acts funny. using the following seems to help:
- `docker exec -t <container_name> /bin/bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"`
