FROM openjdk:8-jdk-alpine
EXPOSE 8080
ADD target/hello-world-1.0-SNAPSHOT.jar hello-world.jar
ENTRYPOINT ["java", "-jar", "/hello-world.jar"]
