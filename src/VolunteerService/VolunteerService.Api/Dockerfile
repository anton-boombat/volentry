FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["src/VolunteerService/VolunteerService.Api/VolunteerService.Api.csproj", "src/VolunteerService/VolunteerService.Api/"]
COPY ["src/VolunteerService/VolunteerService.Application/VolunteerService.Application.csproj", "src/VolunteerService/VolunteerService.Application/"]
COPY ["src/Volentry.Core/Volentry.Core.csproj", "src/Volentry.Core/"]
COPY ["src/Volentry.Infrastructure/Volentry.Infrastructure.csproj", "src/Volentry.Infrastructure/"]

RUN dotnet restore "src/VolunteerService/VolunteerService.Api/VolunteerService.Api.csproj"

COPY . .

RUN dotnet build "src/VolunteerService/VolunteerService.Api/VolunteerService.Api.csproj" \
    -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
RUN dotnet publish "src/VolunteerService/VolunteerService.Api/VolunteerService.Api.csproj" \
    -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VolunteerService.Api.dll"]
