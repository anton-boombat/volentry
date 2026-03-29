FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

COPY ["src/AdminService/AdminService.Api/AdminService.Api.csproj", "src/AdminService/AdminService.Api/"]
COPY ["src/AdminService/AdminService.Application/AdminService.Application.csproj", "src/AdminService/AdminService.Application/"]
COPY ["src/Volentry.Core/Volentry.Core.csproj", "src/Volentry.Core/"]
COPY ["src/Volentry.Infrastructure/Volentry.Infrastructure.csproj", "src/Volentry.Infrastructure/"]

RUN dotnet restore "src/AdminService/AdminService.Api/AdminService.Api.csproj"

COPY . .

RUN dotnet build "src/AdminService/AdminService.Api/AdminService.Api.csproj" \
    -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
RUN dotnet publish "src/AdminService/AdminService.Api/AdminService.Api.csproj" \
    -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AdminService.Api.dll"]
