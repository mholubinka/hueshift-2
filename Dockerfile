FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

COPY HueShift2/HueShift2/*.csproj ./

WORKDIR /app
RUN dotnet restore

COPY HueShift2/HueShift2/. ./
WORKDIR /app
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS runtime
WORKDIR /app

RUN mkdir -p config
VOLUME /config

RUN mkdir -p log
VOLUME /log

ENV UDPPORT 6454
EXPOSE ${UDPPORT}
EXPOSE ${UDPPORT}/udp

COPY --from=build-env /app/out ./

ENTRYPOINT ["dotnet", "HueShift2.dll", "--config-file", "/config/hueshift2-config.json"]