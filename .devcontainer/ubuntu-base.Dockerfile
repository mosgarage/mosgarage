FROM ubuntu:noble

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    TZ=Etc/GMT+3 \
    DEBIAN_FRONTEND=noninteractive \
    LANGUAGE=en_US:en \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install basic OS packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    git \
    nano \
    apt-utils \
    curl \
    zip \
    openssh-client \
    xz-utils \
    dirmngr \
    gnupg \
    sudo \
    locales \
    npm \
    sqlite3

# [Optional] Uncomment this section to install additional OS packages
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#     # list of <packages-here>

# Clean up package cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Generate locales for international support
RUN sed -i "/${LANG}/s/^# //g" /etc/locale.gen && locale-gen

# Create user and directories
RUN useradd -m --home-dir /home/user -s /bin/bash user && \
    echo "user:user" | chpasswd && \
    usermod -aG sudo user

# Create /opt directories for user-managed packages
RUN mkdir -p /opt && \
    chown -R user:user /opt

# Create workspace directory with proper permissions
RUN mkdir -p /mnt/workspace && \
    chown -R user:user /mnt/workspace

USER user

# Add global opt bin to PATH
ENV PATH="/opt/bin:$PATH"

# Configure npm to use /opt/npm for global packages
RUN npm config set prefix "/opt"

# Install Node.js version manager and upgrade Node.js
ENV N_PREFIX="/opt"
RUN npm install -g n && n 20

WORKDIR /mnt/workspace
