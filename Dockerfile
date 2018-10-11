FROM alpine:3.8

ENV USER=cnr-server
ENV HOME=/${USER}
ENV PORT=5000
ENV DATABASE_URL=${HOME}/.appr/packages
ENV STORAGE=filesystem

RUN addgroup -g 1001 ${USER} && \
  adduser -h ${HOME} -D -u 1001 -G ${USER} ${USER}

RUN apk -Uuv add --update --no-cache \
      python2=2.7.15-r1 \
      python2-dev=2.7.15-r1 \
      py2-pip=10.0.1-r0 \
      git=2.18.0-r0 \
      build-base=0.5-r1 \
      libffi-dev=3.2.1-r4 \
      openssl-dev=1.0.2p-r0

WORKDIR ${HOME}

RUN git clone https://github.com/app-registry/appr && \
  cd appr && \
  pip install -e . && \
  pip install jsonnet && \
  pip install -r requirements_dev.txt -U && \
  pip install urllib3==1.21.1 && \
  chown -R 1001:1001 ${HOME}

USER ${USER}

ENTRYPOINT ["./appr/run-server.sh"]
