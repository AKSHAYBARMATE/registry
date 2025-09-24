# syntax=docker/dockerfile:1

# ======================
# Build stage
# ======================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Pre-download dependencies for layer caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build the application
COPY src ./src
RUN mvn clean package -DskipTests -B

# ======================
# Run stage
# ======================
FROM eclipse-temurin:17.0.8_7-jdk-jammy as runtime
# Alternatively: FROM gcr.io/distroless/java17-debian11

WORKDIR /app

# Copy the fat JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Eureka server port
EXPOSE 8761

# JVM options:
# - Disables metrics that trigger CgroupInfo bug
# - Improves startup time with tiered compilation
ENTRYPOINT ["java", 
  "-XX:+TieredCompilation", 
  "-Dspring.autoconfigure.exclude=org.springframework.boot.actuate.autoconfigure.metrics.SystemMetricsAutoConfiguration", 
  "-Dmanagement.metrics.export.defaults.enabled=false", 
  "-jar", "app.jar"]
