FROM registry.access.redhat.com/ubi9/ubi-minimal:9.0.0
# FROM redhat/ubi9/ubi-minimal:9.0.0

LABEL maintainer=""

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV NODEJS_VERSION=14 \
    PATH=$HOME/.local/bin/:$PATH \
    npm_config_loglevel=warn \
    npm_config_unsafe_perm=true

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

# Install Python 3
RUN microdnf update -y \
    && microdnf install -y python39 \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Make sure to upgrade pip3
RUN pip3 install --upgrade pip && pip3 install poetry
RUN python3 --version && pip3 --version

# Install Node, NPM, and Terraform CDK
RUN microdnf update -y \
    && microdnf module enable nodejs:14 \
    && microdnf install -y nodejs \
    && microdnf install -y npm \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

RUN npm install --global yarn \
    && npm config set prefix /usr/local
    
RUN node --version \ 
    && npm --version \ 
    && yarn --version \
    && npm install -g cdktf-cli \ 
    && cdktf --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
