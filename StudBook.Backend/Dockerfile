# FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
# WORKDIR /src
# COPY . .
# RUN dotnet restore
# RUN dotnet publish -c Release -o /app

# FROM mcr.microsoft.com/dotnet/aspnet:10.0
# WORKDIR /app
# COPY --from=build /app .
# ENV ASPNETCORE_URLS=http://+:8080
# EXPOSE 8080
# ENTRYPOINT ["dotnet", "Web/StudBook.Web.dll"]

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY Core/Domain/StudBook.Domain.csproj Core/Domain/
COPY Core/Application/StudBook.Application.csproj Core/Application/
COPY Infrastructure/StudBook.Infrastructure.csproj Infrastructure/
COPY Web/StudBook.Web.csproj Web/
RUN dotnet restore Web/StudBook.Web.csproj

COPY . .
RUN dotnet publish Web/StudBook.Web.csproj -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "StudBook.Web.dll"]