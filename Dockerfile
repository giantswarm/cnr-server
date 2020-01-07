FROM alpine:3.11

ENV USER=cnr-server
ENV HOME=/${USER}
ENV PORT=5000
ENV DATABASE_URL=${HOME}/.appr/packages
ENV STORAGE=filesystem

RUN addgroup -g 1001 ${USER} && \
  adduser -h ${HOME} -D -u 1001 -G ${USER} ${USER}

RUN apk -Uuv add --update --no-cache \
      python2=2.7.16-r3 \
      python2-dev=2.7.16-r3 \
      py2-pip=18.1-r0 \
      git=2.24.1-r0 \
      build-base=0.5-r1 \
      libffi-dev=3.2.1-r6 \
      openssl-dev=1.1.1d-r3

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
