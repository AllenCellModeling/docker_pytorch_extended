# From pytorch compiled from source
FROM rorydm/pytorch_extras:jupyter_R

# Julia install
RUN conda install -c conda-forge julia

# Julia packages
RUN julia -e 'Pkg.init()' && \
    julia -e 'Pkg.update()' && \
    julia -e 'Pkg.add("HDF5")' && \
    julia -e 'Pkg.add("Gadfly")' && \
    julia -e 'Pkg.add("RDatasets")' && \
    julia -e 'Pkg.add("IJulia")' && \
    julia -e 'using HDF5' && \
    julia -e 'using Gadfly' && \
    julia -e 'using RDatasets' && \
    julia -e 'using IJulia'

# Plotting and backends:
RUN julia -e 'Pkg.add("Plots")' && \
    julia -e 'Pkg.add("PyPlot")' && \
    julia -e 'Pkg.add("GR")' && \
    julia -e 'Pkg.add("UnicodePlots")' && \
    julia -e 'Pkg.add("PlotlyJS")' && \
    julia -e 'Pkg.add("StatPlots")' && \
    julia -e 'Pkg.add("PlotRecipes")' && \
    julia -e 'using Plots' && \
    julia -e 'using PyPlot' && \
    julia -e 'using GR' && \
    julia -e 'using UnicodePlots' && \
    julia -e 'using PlotlyJS' && \
    julia -e 'using StatPlots' && \
    julia -e 'using PlotRecipes'
