FROM python:3.6-alpine3.8
LABEL maintainer="mikeholloway+swarmstack@gmail.com"

COPY config.py requirements.txt /src/

RUN apk add --no-cache --virtual .build-deps \
     gcc \
     build-base \
     python-dev \
     libffi-dev \
     openssl-dev \
     tzdata \
   && pip install --upgrade pip \
   && pip install -r /src/requirements.txt \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && mkdir /src/data \
   && apk del .build-deps

ENV ERRBOT_BASE_DIR /src

WORKDIR /src
ENTRYPOINT ["errbot"]


