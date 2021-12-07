FROM registry.gitlab.com/tychodev1/gitlab-coe/images/cicd/ubi-nodejs:latest

LABEL maintainer="TychoDev <cloud.ops@tychodev.com>"

RUN npm install -g cdktf-cli
RUN cdktf --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
