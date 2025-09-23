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

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Eureka port
EXPOSE 8761

# ✅ Disable system metrics to avoid CgroupInfo NPE in Docker
ENTRYPOINT ["java", "-Dspring.autoconfigure.exclude=org.springframework.boot.actuate.autoconfigure.metrics.SystemMetricsAutoConfiguration", "-jar", "app.jar"]

