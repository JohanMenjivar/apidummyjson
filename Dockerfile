# Use a Maven image with OpenJDK 17
FROM maven:3.9.5-sapmachine-17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project files
COPY . /app

# Build the Maven project
RUN mvn clean package -DskipTests
# Set the entry point for the application
ENTRYPOINT ["java", "-jar", "target/dummyjson-0.0.1-SNAPSHOT.jar"]
