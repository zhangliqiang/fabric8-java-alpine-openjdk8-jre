FROM alpine:3.16.2

MAINTAINER https://github.com/zhangliqiang/fabric8-java-alpine-openjdk8-jre

USER root

RUN mkdir -p /deployments \
 && apk add tzdata \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \ 
 && echo "Asia/Shanghai" > /etc/timezone

# JAVA_APP_DIR is used by run-java.sh for finding the binaries
ENV JAVA_APP_DIR=/deployments \
    JAVA_MAJOR_VERSION=8 \
    JAVA_OPTIONS=-Dfile.encoding=utf-8 \
    LOG4J_FORMAT_MSG_NO_LOOKUPS=true

# /dev/urandom is used as random source, which is perfectly safe
# according to http://www.2uo.de/myths-about-urandom/
RUN apk add --update \
    curl \
    openjdk8-jre-base=8.345.01-r0 \
 && apk add --no-cache nss  \
 && rm /var/cache/apk/* \
 && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security

# Add run script as /deployments/run-java.sh and make it executable
COPY run-java.sh /deployments/
RUN chmod 755 /deployments/run-java.sh

CMD [ "/deployments/run-java.sh" ]
