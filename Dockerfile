FROM --platform=$TARGETPLATFORM debian:11

COPY ./app /app

WORKDIR /app

RUN apt update \
    && apt install -y curl wget cron git cmake build-essential \
    && git clone https://github.com/flow2000/lookbusy.git \
    && curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash \
    && apt install -y speedtest \
    && cd lookbusy && chmod +x ./configure && ./configure && make && make install \
    && mv /usr/local/bin/lookbusy /usr/local/bin/jenkins-java \
    && rm -rf /app/lookbusy && chmod +x /app/*.sh \
    && apt autoremove -y && apt autoclean && apt remove -y && apt clean

CMD [ "/app/docker-entrypoint.sh" ]

USER root
