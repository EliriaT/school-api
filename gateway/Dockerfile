FROM bitwalker/alpine-elixir:latest as build
 
ENV MIX_ENV=prod

EXPOSE 8080

WORKDIR /app

COPY . .

RUN mix deps.get

RUN mix escript.build


CMD "/app/gateway"