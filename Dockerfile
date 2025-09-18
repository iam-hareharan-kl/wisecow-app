FROM ubuntu:latest AS base

RUN apt-get update && apt-get install -y \
    cowsay \
    fortune-mod \
    netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:/usr/games"

WORKDIR /app

COPY wisecow.sh /app/wisecow.sh

RUN chmod +x /app/wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]