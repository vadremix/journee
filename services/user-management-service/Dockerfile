# Build the service
FROM maven:3.9-amazoncorretto-17 AS build
WORKDIR /app

COPY src /app/src
COPY pom.xml /app

RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package

# Set up runtime environment
FROM ubuntu/jre:17-22.04_edge

WORKDIR /app/tmp
WORKDIR /app

COPY --from=build /app/target/*.jar /app/app.jar

EXPOSE 8080

CMD ["-Djava.io.tmpdir=/app/tmp", "-jar", "app.jar"]