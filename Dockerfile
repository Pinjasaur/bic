FROM ubuntu:20.04

ENV PANDOC_VERSION=2.17.0.1

RUN apt-get update && apt-get install -y curl tzdata && \
  curl -sL https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-1-amd64.deb -o pandoc-$PANDOC_VERSION.deb && \
  dpkg -i pandoc-$PANDOC_VERSION.deb && \
  rm -f pandoc-$PANDOC_VERSION.deb

# non-root
USER nobody

WORKDIR /src
ADD . /app
ENTRYPOINT [ "/app/bic"]
CMD [ "/src" ]
