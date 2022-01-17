FROM ubuntu:22.04

RUN apt-get update && apt-get install -y pandoc tzdata

# non-root
USER nobody

WORKDIR /src
ADD . /app
ENTRYPOINT [ "/app/bic"]
CMD [ "/src" ]
