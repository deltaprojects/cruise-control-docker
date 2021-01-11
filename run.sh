#!/bin/sh

if [ ! -f /target/cruise-control-${VERSION}/kafka-cruise-control-start.sh ]; then
  apk add --no-cache --virtual=.build-dependencies git curl wget ca-certificates && \
  curl -JLs https://github.com/linkedin/cruise-control/archive/${VERSION}.tar.gz | tar xzvf - -C /tmp && \
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
  (printf "https://github.com" && \
  (curl -sL https://github.com/linkedin/cruise-control-ui/releases/latest | \
  grep "download.*cruise-control-ui-.*tar.gz" | cut -d '"' -f 2)) | \
  wget -q -i - -O - | tar xzvf - -C /target --strip-components 1 && \
  mv /target/dist /target/cruise-control-ui && \
  cd && apk del .build-dependencies && rm -rf /tmp/cruise-control-${VERSION}
fi

if [ -f /etc/cruise-control/ui-config.csv ]; then
  rm -f /target/cruise-control-ui/static/config.csv && ln -s /etc/cruise-control/ui-config.csv /target/cruise-control-ui/static/config.csv
fi

if [ -f /etc/cruise-control/cruise_control_jaas.conf ]; then
  ln -sf /etc/cruise-control/cruise_control_jaas.conf /target/cruise-control-${VERSION}/config/cruise_control_jaas.conf
fi

/target/cruise-control-${VERSION}/kafka-cruise-control-start.sh /etc/cruise-control/cruisecontrol.properties ${PORT}
