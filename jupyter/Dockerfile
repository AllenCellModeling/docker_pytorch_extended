# From pytorch compiled from source
FROM rorydm/pytorch:master

# pytorch image comes with:
#   ubuntu: build-essential cmake git curl vim ca-certificates libjpeg-dev libpng-dev
#   python: numpy pyyaml scipy ipython mkl

# install more python stuff
RUN conda install -c conda-forge -y \
    jupyter \
    jupyterlab \
    ipywidgets \
    nodejs \
    natsort \
    matplotlib \
    scikit-learn \
    scikit-image \
    pandas \
    xlrd \
    tqdm \
    seaborn \
    bokeh \
    yapf \
    fire \
    numba \
    umap-learn \
    python-igraph \
    louvain \
    ipympl \
    glmnet \
    && conda clean -tipsy

# datashader plotting
conda install -c bokeh datashader

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

