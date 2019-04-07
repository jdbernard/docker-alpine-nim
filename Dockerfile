FROM alpine

RUN apk update && apk upgrade \
  && apk add g++ git \
  && rm -rf /var/cache/apk/* \
  && apk add --no-cache --virtual=build-dependencies ca-certificates && \
  \
  mkdir -p "/opt" && \
  cd "/opt" && \
  git clone -b master --depth 1 https://github.com/nim-lang/nim Nim && \
  cd Nim && \
  git clone -b master --depth 1 https://github.com/nim-lang/csources csources && \
  cd csources && \
  sh build.sh && \
  cd .. &&\
  rm -rf "./csources" "./tests" && \
  bin/nim c koch && \
  ./koch boot -d:release && \
  ln -s "/opt/Nim/bin/nim" "/usr/local/bin/nim" && \
  \
  apk del build-dependencies
