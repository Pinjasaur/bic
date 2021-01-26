FROM ubuntu:20.10

RUN apt-get update && apt-get install -y pandoc tzdata
WORKDIR /src
ADD . /app
ENTRYPOINT [ "/app/bic"]
CMD [ "/src" ]
