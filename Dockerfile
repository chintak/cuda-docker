# Start with Ubuntu base image
FROM ubuntu:14.04
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

RUN apt-get update && apt-get install -y \
  build-essential \
  wget

ENV CUDA_MAJOR 7.0
ENV CUDA_VERSION 7.0.28

# Change to the /tmp directory
RUN cd /tmp && \
# Download run file
  wget http://developer.download.nvidia.com/compute/cuda/$CUDA_MAJOR/Prod/local_installers/cuda_$CUDA_VERSION_linux.run && \
# Make the run file executable and extract
  chmod +x cuda_*_linux.run && ./cuda_*_linux.run -extract=`pwd` && \
# Install CUDA drivers (silent, no kernel)
  ./NVIDIA-Linux-x86_64-*.run -s --no-kernel-module && \
# Install toolkit (silent)
  ./cuda-linux64-rel-*.run -noprompt && \
# Clean up
  rm -rf *

# Add to path
ENV PATH=/usr/local/cuda/bin:$PATH \
  LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
