ARG OPENJDK_VERSION=17

# Stage 1: build+verify
FROM maven:3.9.5-eclipse-temurin-${OPENJDK_VERSION}-focal as build
LABEL maintainer="titouan.veauvy@pm.me"

WORKDIR /build
COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src /build/src
RUN mvn package
RUN mvn verify

# Stage 2: install
FROM openjdk:22-ea-${OPENJDK_VERSION}-slim
LABEL maintainer="titouan.veauvy@pm.me"

COPY --from=build /build/target/orderservice.jar /app/orderservice.jar

ENTRYPOINT ["java", "-jar", "/app/orderservice.jar"]