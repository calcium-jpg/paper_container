FROM alpine:latest

ARG JAVA_VERSION="21"

ENV EULA="false"
ENV LOADER="PAPER"
ENV MINECRAFT_VERSION="1.21"
ENV MEMORY="4G"

EXPOSE 25565/tcp

RUN apk add --no-cache openjdk${JAVA_VERSION}-jre jq curl

RUN adduser -D user
RUN mkdir /data
RUN chown user /data
COPY --chown=user --chmod=744 ./build/run.sh /data/run.sh

WORKDIR /data

USER user

VOLUME ["/data"]

ENTRYPOINT ["./run.sh"]
