FROM eclipse-temurin:21-jdk

WORKDIR /app

RUN useradd -ms /bin/bash lga

COPY target/*.jar app.jar

RUN chown lga:lga app.jar

USER lga

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]