# From pytorch compiled from source
FROM rorydm/pytorch:master

# pytorch image comes with:
#   ubuntu: build-essential cmake git curl vim ca-certificates libjpeg-dev libpng-dev
#   python: numpy pyyaml scipy ipython mkl

# install more python stuff
RUN /opt/conda/bin/conda install -c conda-forge -y \
    jupyter \
    jupyterlab \
    jupyter_contrib_nbextensions \
    ipywidgets \
    nodejs \
    natsort \
    matplotlib \
    scikit-learn \
    scikit-image \
    pandas \
    xlrd \
    h5py \
    tqdm \
    seaborn \
    yapf \
    fire \
    py-xgboost && \
    conda clean -tipsy

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

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# set matplitlib backend
RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc

# expose port for ipython (9999)
EXPOSE 9999

# move to home dir for root
WORKDIR "/root" 

