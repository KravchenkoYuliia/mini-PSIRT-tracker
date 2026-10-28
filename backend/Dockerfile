# build image with Maven

FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /backend
COPY pom.xml .
RUN mvn -q dependency:go-offline      #install dependencies during Docker image build 
COPY src ./src
RUN mvn -q package -DskipTests          # build the project(compile) and creates .jar archive in target/tracker-0.1.0.jar


# run, only JRE, without Maven

FROM eclipse-temurin:21-jre
WORKDIR /backend
RUN useradd --system backend_user                       # more secure than root
COPY --from=build /backend/target/*.jar backend.jar     
USER backend_user
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "backend.jar"]