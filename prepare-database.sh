#!/usr/bin/env bash
PGDATA=/var/lib/postgresql
if [ "$(id -u)" = '0' ]; then
    echo "Running root part"
    echo "export PATH=$PATH:/usr/lib/postgresql/9.6/bin" > /etc/profile.d/postgresql.sh
    chmod +x /etc/profile.d/postgresql.sh
    mkdir -p $PGDATA
    chown postgres:postgres $PGDATA
    exec su - postgres -c $BASH_SOURCE
    exit
fi
echo running postgres part
initdb --username gnaf --pwfile=<(echo gnaf) --auth=md5 -D "$PGDATA/gnafdatabase"
{
	echo
	echo "host all all all md5"
} >> "$PGDATA/gnafdatabase/pg_hba.conf"
pg_ctl -D /var/lib/postgresql/gnafdatabase -w start
PGPASSWORD=gnaf psql -U gnaf postgres -c "create database gnafdata"
PGPASSWORD=gnaf psql -U gnaf gnafdata -f /data/AUG18_GNAF_PipeSeparatedValue_20180827115521/G-NAF/Extras/GNAF_TableCreation_Scripts/create_tables_ansi.sql
for i in /app/*; do export CLASSPATH=$CLASSPATH:$i; done
java -Xmx4G  cesa.enterprise.address.loader.Main -u gnaf -p gnaf -f /data/ -j jdbc:postgresql://localhost/gnafdata
PGPASSWORD=gnaf psql -U gnaf gnafdata -f /data/AUG18_GNAF_PipeSeparatedValue_20180827115521/G-NAF/Extras/GNAF_TableCreation_Scripts/add_fk_constraints.sql
pg_ctl -D /var/lib/postgresql/gnafdatabase stop