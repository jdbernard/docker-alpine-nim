FROM alpine:3.9

RUN apk update && apk upgrade \
  && apk add \
    build-base g++ git bsd-compat-headers pcre-dev \
    libressl2.7-libcrypto libressl2.7-libssl \
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
  ./koch nimble && \
  ln -s "/lib/libcrypto.so.43" "/lib/libcrypto.so" && \
  ln -s "/opt/Nim/bin/nim" "/usr/local/bin/nim" && \
  ln -s "/opt/Nim/bin/nimble" "/usr/local/bin/nimble" && \
  \
  apk del build-dependencies
