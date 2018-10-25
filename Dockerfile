FROM python:3.6-alpine3.8
MAINTAINER Mike Holloway <mikeholloway+swarmstack@gmail.com>

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/swarmstack/errbot-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

COPY config.py requirements.txt /src/

RUN apk add --no-cache --virtual .build-deps \
     gcc \
     build-base \
     python3-dev \
     libffi-dev \
     openssl-dev \
     tzdata \
   && pip install --upgrade pip \
   && pip install -r /src/requirements.txt \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && mkdir /src/data \
   && apk del .build-deps

ENV ERR_PYTHON_VERSION 3
ENV ERR_PACKAGE err

COPY provisioners/base.sh /provision.sh
RUN /provision.sh && rm /provision.sh
COPY provisioners/app.sh /provision.sh
RUN /provision.sh && rm /provision.sh

WORKDIR /err
ENTRYPOINT ["errbot"]

EXPOSE 3141 3142
VOLUME ["/err/data/"]
