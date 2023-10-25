FROM bitwalker/alpine-elixir:latest as build
 
ENV MIX_ENV=prod

EXPOSE 4040

WORKDIR /app

COPY . .

RUN mix deps.get

RUN mix escript.build


CMD "/app/service_discovery"