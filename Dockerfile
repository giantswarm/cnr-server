FROM alpine:3.7

ENV USER=cnr-server
ENV HOME=/${USER}
ENV PORT=5000
ENV DATABASE_URL=${HOME}/.appr/packages
ENV STORAGE=filesystem

RUN addgroup -g 1001 ${USER} && \
  adduser -h ${HOME} -D -u 1001 -G ${USER} ${USER}

RUN apk -Uuv add --update --no-cache \
      python2=2.7.14-r2 \
      python2-dev=2.7.14-r2 \
      py2-pip=9.0.1-r1 \
      git=2.15.0-r1 \
      build-base=0.5-r0 \
      libffi-dev=3.2.1-r4 \
      openssl-dev=1.0.2n-r0

WORKDIR ${HOME}

RUN git clone https://github.com/app-registry/appr && \
  cd appr && \
  pip install -e . && \
  pip install jsonnet && \
  pip install -r requirements_dev.txt -U && \
  chown -R 1001:1001 ${HOME}

USER ${USER}

ENTRYPOINT ["./appr/run-server.sh"]
