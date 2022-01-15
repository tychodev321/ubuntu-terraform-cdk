ARG org_name=replace
FROM registry.gitlab.com/${org_name}/gitlab-coe/images/cicd/ubi-nodejs:latest

LABEL maintainer=""

RUN npm install -g cdktf-cli
RUN cdktf --version

# USER 1001

CMD ["echo", "This is a 'Purpose Built Image', It is not meant to be ran directly"]
