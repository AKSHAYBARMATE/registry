# syntax=docker/dockerfile:1

# ======================
# Build stage
# ======================
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src src
RUN mvn clean package -DskipTests

# ======================
# Run stage
# ======================
FROM openjdk:17-jdk-slim
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8761

# Disable system metrics (fix the NPE)
ENTRYPOINT ["java", "-Dmanagement.metrics.binders.system.enabled=false", "-jar", "app.jar"]
