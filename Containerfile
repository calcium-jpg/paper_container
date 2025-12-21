FROM alpine:latest

ARG JAVA_VERSION="21"
ENV MEMORY="4G"

EXPOSE 25565/tcp

RUN apk add --no-cache openjdk${JAVA_VERSION}-jre

RUN adduser -D user
RUN mkdir /data
RUN chown user /data

WORKDIR /data

COPY --chown=user build/server.jar ./
COPY build/eula.txt ./

USER user

VOLUME ["/data"]

ENTRYPOINT ["sh", "-c", "exec java -Xmx$MEMORY -jar ./server.jar --nogui"]
