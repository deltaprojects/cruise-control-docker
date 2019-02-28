FROM openjdk:8-jdk-alpine

ENV VERSION=0.1.38
ENV PORT 9090

EXPOSE 9090/tcp

RUN apk add --no-cache bash && ln -s /target/cruise-control-${VERSION}/config /etc/cruise-control

ADD run.sh /run.sh

VOLUME /target

CMD /run.sh
