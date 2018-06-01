# From pytorch compiled from source
FROM rorydm/pytorch:master

# pytorch image comes with:
#   ubuntu: build-essential cmake git curl vim ca-certificates libjpeg-dev libpng-dev
#   python: numpy pyyaml scipy ipython mkl
RUN apt-get update
RUN apt-get install texlive-xetex pandoc -y

# install more python stuff -- basics like jupyter, i/o, numerics, scikits, plotting
RUN conda install -c conda-forge -y \
    numba \
    natsort \
    pandas \
    scikit-learn \
    scikit-image \
    jupyter \
    jupyterlab \
    ipywidgets \
    nodejs \
    matplotlib \
    seaborn \
    bokeh \
    ipympl \
    xlrd \
    tqdm \
    yapf \
    fire

# install more specialized libraries
RUN conda install -c conda-forge -y \
    umap-learn \
    python-igraph \
    louvain \
    glmnet \
    && conda clean -tipsy

# datashader plotting
RUN conda install -c bokeh datashader

# tensor comprehensions
RUN apt-get update && \
    apt-get install -y \
    libgoogle-glog-dev \
    curl \
    build-essential \
    cmake \
    git \
    automake \
    libgmp3-dev \
    libtool \
    ssh \
    libyaml-dev \
    realpath \
    wget \
    valgrind \
    software-properties-common \
    unzip \
    libz-dev \
    libxml2-dev

ENV CC=/usr/bin/gcc \
    CXX=/usr/bin/g++ \
    CORES=64 \
    LLVM_SOURCES=$HOME/llvm_sources-tapir5.0 \
    CLANG_PREFIX=$HOME/clang+llvm-tapir5.0 \
    CMAKE_VERSION=cmake

RUN mkdir -p $LLVM_SOURCES && cd $LLVM_SOURCES && \
    git clone --recursive https://github.com/wsmoses/Tapir-LLVM llvm && \
    mkdir -p ${LLVM_SOURCES}/llvm_build && cd ${LLVM_SOURCES}/llvm_build

RUN cd ${LLVM_SOURCES}/llvm_build && \
    ${CMAKE_VERSION} -DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_OCAMLDOC=OFF -DLLVM_INSTALL_OCAMLDOC_HTML_DIR=/tmp -DLLVM_OCAML_INSTALL_PATH=/tmp -DCMAKE_INSTALL_PREFIX=${CLANG_PREFIX} -DLLVM_TARGETS_TO_BUILD=X86 -DCOMPILER_RT_BUILD_CILKTOOLS=OFF -DLLVM_ENABLE_CXX1Y=ON -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_BUILD_TESTS=OFF -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON  -DLLVM_ENABLE_RTTI=ON ../llvm/
RUN cd ${LLVM_SOURCES}/llvm_build && \
    make -j $CORES -s && make install -j $CORES -s
RUN cd $HOME && rm -rf $LLVM_SOURCES
RUN ln -s /clang+llvm-tapir5.0/bin/llvm-config /usr/local/bin/llvm-config

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/targets/x86_64-linux/lib/stubs/:$LD_LIBRARY_PATH
ENV PATH=/usr/local/bin:/usr/local/cuda/bin:$PATH

RUN mkdir -p /tmp/proto-install && \
    cd /tmp/proto-install && \
    wget --quiet https://github.com/google/protobuf/archive/v3.4.0.zip -O proto.zip && \
    unzip -qq proto.zip -d . && \
    cd protobuf-3.4.0 && \
    ./autogen.sh && ./configure && make -j 8 && make install && ldconfig

RUN git clone https://github.com/facebookresearch/TensorComprehensions.git --recursive /opt/TensorComprehensions && \
    cd /opt/TensorComprehensions && \
    git submodule update --init --recursive
ENV TC_DIR='/opt/TensorComprehensions'

RUN cd /opt/TensorComprehensions && \
    BUILD_TYPE=Release INSTALL_PREFIX=$CONDA_PREFIX WITH_CAFFE2=OFF CLANG_PREFIX=$(llvm-config --prefix) ./build.sh --all

# pip install since conda version out of date
RUN pip install tensorflow tensorboard

# theis lab deep count autoencoder and scanpy
RUN pip install dca scanpy

# pip install since conda version downgrades numpy which breaks pytorch
RUN jupyter serverextension enable --py jupyterlab --sys-prefix
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@0.35

# deep count autoencoder and single-cell data stuff
RUN pip install h5py

# add tensorboardx from source
RUN pip install git+https://github.com/lanpa/tensorboard-pytorch

# add our aicsimage repo
RUN git clone https://github.com/AllenCellModeling/aicsimage.git /opt/aicsimage && \
    cd /opt/aicsimage && \
    pip install -r requirements.txt && \
    pip install -e .

# install the simd fork of pillow -- aicsimage installs pillow
RUN pip uninstall -y pillow
RUN pip install pillow-simd

# add pytorch learning tools
RUN git clone https://github.com/AllenCellModeling/pytorch_learning_tools.git /opt/pytorch_learning_tools && \
    cd /opt/pytorch_learning_tools && \
    git checkout dataframeDP && \
    pip install -e .

# install multi-core tnse
RUN git clone https://github.com/DmitryUlyanov/Multicore-TSNE.git /opt/Multicore-TSNE && \
    cd /opt/Multicore-TSNE && \
    pip install -e .

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/
RUN jupyter serverextension enable --py jupyterlab --sys-prefix
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@0.35
RUN jupyter labextension install jupyterlab_bokeh

# set matplotlib backend
RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc

# expose port for ipython (9999)
EXPOSE 9999
EXPOSE 6006

# move to home dir for root
WORKDIR "/root" 

