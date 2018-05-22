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
RUN conda install -c tensorcomp tensor_comprehensions

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

