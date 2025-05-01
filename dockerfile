# Use mambaforge as base image
FROM condaforge/mambaforge:latest

# Set environment for noninteractive apt installs
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install system dependencies for R packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libgit2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy environment.yml and create conda environment
COPY environment.yml .
RUN mamba env create -f environment.yml && \
    mamba clean -afy

# Use bash for SHELL commands
SHELL ["/bin/bash", "-c"]

# Activate env in shell sessions
RUN echo "source activate sc-r-env" >> ~/.bashrc

# Install synapser (Seurat is already in conda env)
RUN source activate sc-r-env && \
    export RETICULATE_PYTHON="/opt/conda/envs/sc-r-env/bin/python" && \
    R --no-save -e "\
    #   options(repos = c(SYNAPSE = 'http://ran.synapse.org', CRAN = 'https://cloud.r-project.org')); \
      install.packages('synapser', repos = 'http://ran.synapse.org'); \
    "

# Copy .Rprofile and entrypoint script
COPY .Rprofile /etc/R/Rprofile.site
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Entrypoint handles creating .Renviron from env vars
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Enter working directory
WORKDIR /workspace

# Start in conda env with radian
CMD ["/bin/bash", "-c", "source activate sc-r-env && radian"]
