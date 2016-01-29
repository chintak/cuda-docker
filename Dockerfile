# Start with Ubuntu base image
FROM ubuntu:14.04
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

RUN apt-get update && apt-get install -y \
  build-essential \
  wget \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

ENV CUDA_MAJOR 6_5
ENV CUDA_VERSION 6.5.14

# Change to the /tmp directory
RUN cd /tmp && \
# Download run file
  wget http://developer.download.nvidia.com/compute/cuda/$CUDA_MAJOR/rel/installers/cuda_${CUDA_VERSION}_linux_64.run && \
# Make the run file executable and extract
  chmod +x cuda_*.run && ./cuda_*.run -extract=`pwd` && \
# Install CUDA drivers (silent, no kernel)
  ./NVIDIA-Linux-x86_64-*.run -s --no-kernel-module && \
# Install toolkit (silent)
  ./cuda-linux64-rel-*.run -noprompt && \
# Clean up
  rm -rf *

# Add to path
ENV CUDA_HOME=/usr/local/cuda \
  PATH=${CUDA_HOME}/bin:$PATH \
  LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

WORKDIR /tmp/
ADD cudnn-6.5-linux-x64-v2.tgz .
RUN cp cud*/cudnn.h ${CUDA_HOME}/include/ && \
  cp cud*/libcudnn.so.7.0.64 ${CUDA_HOME}/lib64/ && \
  ln -s ${CUDA_HOME}/lib64/libcudnn.so.6.5.48 ${CUDA_HOME}/lib64/libcudnn.so.6.5 && \
  ln -s ${CUDA_HOME}/lib64/libcudnn.so.6.5 ${CUDA_HOME}/lib64/libcudnn.so && \
  rm -r cud*
