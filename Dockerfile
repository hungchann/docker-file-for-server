FROM gradle:jdk21-jammy as build

ADD services /home/gradle/services
ADD assets /home/gradle/assets

WORKDIR /home/gradle/services

RUN gradle build --no-daemon

RUN tar -xvf /home/gradle/services/build/distributions/services.tar

FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY --from=build /home/gradle/services/app-bundle/  ./app-bundle/
COPY --from=build /home/gradle/services/db ./services/db
COPY --from=build /home/gradle/styles ./services/styles
COPY --from=build /home/gradle/assets ./assets

CMD ./app-bundle/bin/server
