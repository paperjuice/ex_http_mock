FROM elixir:1.9.0-alpine

MAINTAINER Dragos Dumitru

WORKDIR /opt/ex_http_mock

COPY . /opt/ex_http_mock

RUN apk update && \
    apk --no-cache add bash && \
    apk --no-cache add vim

RUN mix local.hex --force && \
    mix local.rebar --force

EXPOSE 9997

VOLUME /mocks

CMD iex -S mix
