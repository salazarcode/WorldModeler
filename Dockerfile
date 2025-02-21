# Etapa 1: Build de la aplicación .NET (sin compilar assets de Node)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
ARG CONFIGURATION=Release

# Copiar la solución y proyectos necesarios
COPY WorldModeler.sln ./
COPY Presentation.BlazorServerClient/Presentation.BlazorServerClient.csproj Presentation.BlazorServerClient/
COPY Application.Services/Application.Services.csproj Application.Services/
COPY Domain.Core/Domain.Core.csproj Domain.Core/
COPY Infrastructure.Cache.Redis/Infrastructure.Cache.Redis.csproj Infrastructure.Cache.Redis/
COPY Infrastructure.Repository.MSSQL.EF/Infrastructure.Repository.MSSQL.EF.csproj Infrastructure.Repository.MSSQL.EF/

# Restaurar dependencias .NET
RUN dotnet restore

# Copiar el resto del código fuente
COPY . .

# Etapa 2: Build de assets con Node
FROM node:16-alpine AS nodebuild
WORKDIR /src/Presentation.BlazorServerClient
COPY --from=build /src/Presentation.BlazorServerClient/package*.json ./
RUN npm install
COPY --from=build /src/Presentation.BlazorServerClient .
RUN npm run buildcss

# Etapa 3: Incluir los assets generados en la compilación final
FROM build AS finalbuild
COPY --from=nodebuild /src/Presentation.BlazorServerClient/wwwroot/css/app.min.css Presentation.BlazorServerClient/wwwroot/css/app.min.css

# Publicar la aplicación .NET usando la configuración indicada (Debug para depuración)
RUN dotnet publish Presentation.BlazorServerClient/Presentation.BlazorServerClient.csproj -c $CONFIGURATION -o /app/out

# Etapa 4: Imagen de runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine3.21-composite-amd64 AS runtime
WORKDIR /app
COPY --from=finalbuild /app/out ./
EXPOSE 80
# Establecer el entorno en Development para que se genere información útil para la depuración
ENV ASPNETCORE_ENVIRONMENT=Development
ENTRYPOINT ["dotnet", "Presentation.BlazorServerClient.dll"]
