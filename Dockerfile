FROM python:3.6-alpine3.8
MAINTAINER Mike Holloway <mikeholloway+swarmstack@gmail.com>

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/swarmstack/errbot-docker.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"

COPY config.py requirements.txt /err/
COPY provisioners/base.sh /base.sh
COPY provisioners/app.sh /app.sh

RUN apk upgrade --no-cache
RUN apk add --no-cache --virtual .build-deps \
     gcc \
     build-base \
     libffi-dev \
     openssl-dev \
     tzdata \
   && pip install --upgrade pip \
   && pip install -r /err/requirements.txt \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && /base.sh \
   && rm -f /bash.sh \
   && /app.sh \
   && rm -f /app.sh \
   && apk del .build-deps

WORKDIR /err
ENTRYPOINT ["errbot"]

EXPOSE 3141 3142
VOLUME ["/err/data/"]
