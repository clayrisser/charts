FROM alpine/helm:3.2.1

RUN apk add --no-cache \
  curl \
  git \
  jq \
  make \
  unzip
