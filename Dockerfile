FROM ubuntu:20.04

RUN apt-get update && apt-get install -y pandoc tzdata
WORKDIR /src
ADD . /app
ENTRYPOINT [ "/app/bic"]
CMD [ "/src" ]
