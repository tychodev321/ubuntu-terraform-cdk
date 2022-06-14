FROM registry.access.redhat.com/ubi9/ubi-minimal:9.0.0
# FROM redhat/ubi9/ubi-minimal:9.0.0

LABEL maintainer=""

ENV TERRAFORM_CDK_VERSION=0.11.2
ENV TERRAFORM_VERSION=1.2.2
ENV TERRAFORM_URL=https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip 

ENV PYTHON_VERSION=3 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV NODEJS_VERSION=16.14.0 \
    NPM_VERSION=8.3.1 \
    YARN_VERSION=1.22.19 \
    PATH=$HOME/.local/bin/:$PATH \
    npm_config_loglevel=warn \
    npm_config_unsafe_perm=true

# MicroDNF is recommended over YUM for Building Container Images
# https://www.redhat.com/en/blog/introducing-red-hat-enterprise-linux-atomic-base-image

# Install Terraform
RUN microdnf update -y \
    && microdnf install -y unzip \
    && microdnf install -y wget \
    && microdnf install -y git \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Download and install Terraform
RUN wget ${TERRAFORM_URL} \ 
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/terraform

RUN terraform --version && git --version

# Install Python 3
RUN microdnf update -y \
    && microdnf install -y python${PYTHON_VERSION} \
    && microdnf install -y python${PYTHON_VERSION}-pip \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

# Make sure to upgrade pip3
RUN pip3 install --upgrade pip && pip3 install poetry && pip3 install --user pipenv
RUN python3 --version && pip3 --version

# Install Node, NPM, and Terraform CDK
RUN microdnf update -y \
    && microdnf install -y nodejs-${NODEJS_VERSION} \
    && microdnf install -y npm-${NPM_VERSION} \
    && microdnf clean all \
    && rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

RUN npm install --global yarn@${YARN_VERSION} \
    && npm config set prefix /usr/local
    
RUN node --version \ 
    && npm --version \ 
    && yarn --version \
    && npm install -g cdktf-cli@${TERRAFORM_CDK_VERSION} \ 
    && cdktf --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
