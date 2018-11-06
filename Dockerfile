FROM debian:stretch
RUN apt-get update && apt-get install -y postgresql postgresql-client postgresql-common postgresql-contrib
RUN mkdir /var/postgresql && chown postgres:postgres /var/postgresql
RUN echo "export PATH=$PATH:/usr/lib/postgresql/9.6/bin" > /etc/profile.d/postgress.sh; chmod +x /etc/profile.d/postgress.sh; \
    echo "gnaf" > ~postgres/password; chown postgres ~postgres/password; \
    su - postgres -c "initdb --user=gnaf --pwfile=password -D /var/postgresql/gnafdata"
COPY startimage.sh /usr/local/bin
RUN chmod +x /usr/local/bin/startimage.sh
EXPOSE 5432
ENTRYPOINT [ "startimage.sh" ]
