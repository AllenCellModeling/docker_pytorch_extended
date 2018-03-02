# From pytorch compiled from source
FROM rorydm/pytorch:master

# pytorch image comes with:
#   ubuntu: build-essential cmake git curl vim ca-certificates libjpeg-dev libpng-dev
#   python: numpy pyyaml scipy ipython mkl (in the pytorch-py$PYTHON_VERSION conda environment)


## first we augment python with more libraries

# install more python stuff
RUN conda install -y --name pytorch-py$PYTHON_VERSION \
    jupyter \
    natsort \
    matplotlib \
    scikit-learn \
    scikit-image \
    pandas \
    xlrd \
    h5py \
    tqdm \
    seaborn \
    py-xgboost && \
    conda clean -tipsy

# including packages not in the main repo
RUN pip install \
    yapf \
    fire

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

## Now set up jupyter

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# install contributed notebook extensions
RUN pip install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master && \
    jupyter contrib nbextension install --system && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable spellchecker/main

# install vim bindings (but not enabled by default)
RUN jupyter nbextension install https://github.com/lambdalisue/jupyter-vim-binding/archive/master.tar.gz --system && \
    mkdir -p /root/.jupyter/custom
COPY custom.js /root/.jupyter/custom

# set matplitlib backend
RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc

# expose port for ipython (9999)
EXPOSE 9999

# move to home dir for root
WORKDIR "/root" 

