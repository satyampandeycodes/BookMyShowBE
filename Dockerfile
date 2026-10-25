# Stage 1: Build Java 21 Spring Boot Application
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Copy all project files
COPY . .

# Ensure mvnw has execute permissions and build JAR without tests
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests

# Stage 2: Minimal Java 21 Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose default Spring Boot port
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
