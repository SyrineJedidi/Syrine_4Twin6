# Stage 1: build with Maven
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN mvn -B -f pom.xml -q dependency:go-offline

COPY src ./src
RUN mvn -B -f pom.xml -DskipTests package

# Stage 2: runtime
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
