FROM debian:stretch
RUN apt-get update && apt-get install -y postgresql postgresql-client postgresql-common postgresql-contrib \
    openjdk-8-jdk maven; mkdir /app
COPY startimage.sh /usr/local/bin
COPY prepare-database.sh /usr/local/bin
COPY data /data
COPY *.jar /app/
RUN chmod +x /usr/local/bin/startimage.sh; \
    chmod +x /usr/local/bin/prepare-database.sh ; \
    prepare-database.sh
EXPOSE 5432
ENTRYPOINT [ "startimage.sh" ]
