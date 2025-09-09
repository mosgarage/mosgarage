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

# [Optional] Install additional OS packages for Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Python environment and build tools
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    python3-wheel \
    python3-setuptools \
    build-essential \
    # PostgreSQL client and development libraries
    postgresql-client \
    libpq-dev \
    postgresql-contrib \
    # XML/HTML processing libraries
    libxml2-dev \
    libxslt1-dev \
    # Image processing libraries
    libjpeg-dev \
    libjpeg8-dev \
    liblcms2-dev \
    libtiff5-dev \
    libfreetype6-dev \
    libopenjp2-7-dev \
    libpng-dev \
    libwebp-dev \
    # LDAP and authentication libraries
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    # Mathematical and scientific libraries
    libblas-dev \
    libatlas-base-dev \
    liblapack-dev \
    # Additional development libraries
    libffi-dev \
    libmysqlclient-dev \
    zlib1g-dev \
    libzip-dev \
    # Node.js and frontend tools for RTL support
    nodejs \
    node-less \
    # Font and localization support
    fontconfig \
    # System monitoring and debugging tools
    htop \
    vim \
    wget \
    ca-certificates \
    # Additional Python packages often needed (Ubuntu Noble compatible)
    python3-babel \
    python3-dateutil \
    python3-decorator \
    python3-docutils \
    python3-feedparser \
    python3-pil \
    python3-jinja2 \
    python3-ldap \
    python3-lxml \
    python3-num2words \
    python3-openid \
    python3-passlib \
    python3-phonenumbers \
    python3-pillow \
    python3-psutil \
    python3-psycopg2 \
    python3-pyparsing \
    python3-qrcode \
    python3-renderpm \
    python3-reportlab \
    python3-requests \
    python3-serial \
    python3-tz \
    python3-usb \
    python3-vobject \
    python3-werkzeug \
    python3-xlrd \
    python3-xlwt \
    python3-yaml

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

# Install Node.js packages for frontend development
RUN npm install -g less less-plugin-clean-css rtlcss

# Install UV directly to /opt/bin for system-wide access
RUN curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="/opt/bin" sh

WORKDIR /mnt/workspace
