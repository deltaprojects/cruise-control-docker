#!/bin/sh

if [ ! -f /target/cruise-control-${VERSION}/kafka-cruise-control-start.sh ]; then
  apk add --no-cache --virtual=.build-dependencies git curl ca-certificates && \
  curl -JL https://github.com/linkedin/cruise-control/archive/${VERSION}.tar.gz | tar xzf - -C /tmp && \
  cd /tmp/cruise-control-${VERSION} && \
  git config --global user.email root@localhost && git config --global user.name root && \
  git init && git add . && git commit -m "Init local repo." && git tag -a ${VERSION} -m "Init local version." && \
  ./gradlew jar && ./gradlew jar copyDependantLibs && \
  mkdir -p /target/cruise-control-${VERSION}/cruise-control/build && \
  mkdir -p /target/cruise-control-${VERSION}/cruise-control-core/build && \
  cp cruise-control-metrics-reporter/build/libs/cruise-control-metrics-reporter-${VERSION}.jar /target && \
  cp -a cruise-control/build/dependant-libs /target/cruise-control-${VERSION}/cruise-control/build && \
  cp -a cruise-control/build/libs /target/cruise-control-${VERSION}/cruise-control/build && \
  cp -a cruise-control-core/build/libs /target/cruise-control-${VERSION}/cruise-control-core/build && \
  cp -a config /target/cruise-control-${VERSION} && \
  cp -a kafka-cruise-control-start.sh /target/cruise-control-${VERSION} && \
  cd && apk del .build-dependencies && rm -rf /tmp/cruise-control-${VERSION}
fi

/target/cruise-control-${VERSION}/kafka-cruise-control-start.sh config/cruisecontrol.properties ${PORT}
