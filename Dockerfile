FROM openjdk:8-jdk-alpine

ENV VERSION=0.1.39
ENV PORT 9090

EXPOSE 9090/tcp

RUN apk add --no-cache bash

ADD run.sh /run.sh

VOLUME /etc/cruise-control

CMD /run.sh
