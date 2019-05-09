FROM python:3.6-alpine3.9
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
COPY local_plugins /err/local_plugins/
COPY local_backends /err/local_backends/

RUN apk upgrade --no-cache
RUN apk add --no-cache --virtual .build-deps \
     gcc \
     build-base \
     libffi-dev \
     openssl-dev \
     tzdata \
   && pip install --upgrade pip \
   && pip install -r /err/requirements.txt \
   && rm -f /err/requirements.txt \
   && cp /usr/share/zoneinfo/America/Chicago /etc/localtime \
   && /base.sh \
   && rm -f /base.sh \
   && /app.sh \
   && rm -f /app.sh \
   && apk del .build-deps

EXPOSE 3141 3142
VOLUME ["/err/data/"]

#Add HEALTHCHECK after enabling errbot webserver
#HEALTHCHECK --interval=25s --timeout=2s --start-period=30s CMD /usr/bin/curl -s -I -X GET http://localhost:3141

WORKDIR /err
ENTRYPOINT ["errbot", "-c", "/err/config.py"]
