FROM python:3.6-alpine3.8
LABEL maintainer="mikeholloway+swarmstack@gmail.com"

COPY config.py requirements.txt /src/
COPY plugins /src/plugins
COPY backends /src/backends

RUN apk add --no-cache --virtual .build-deps \
     gcc \
     build-base \
     python-dev \
     libffi-dev \
     openssl-dev \
     tzdata \
#   && apk add --no-cache docker \
   && pip install --upgrade pip \
   && pip install -r /src/requirements.txt \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && mkdir /src/data \
   && apk del .build-deps

ENV ERRBOT_BASE_DIR /src

WORKDIR /src
ENTRYPOINT ["errbot"]


