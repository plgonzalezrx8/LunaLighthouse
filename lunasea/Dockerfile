# Build
FROM --platform=$BUILDPLATFORM debian:latest as build

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"
RUN apt-get update 
RUN apt-get install -y curl git wget unzip
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN flutter channel stable
RUN flutter upgrade

RUN mkdir /lunarr/
COPY . /lunarr/
WORKDIR /lunarr/
RUN flutter build web

# Runtime
FROM --platform=$TARGETPLATFORM nginx:alpine
LABEL org.opencontainers.image.source="https://github.com/pedrogonzalez/Lunarr"
COPY --from=build /lunarr/build/web /usr/share/nginx/html
