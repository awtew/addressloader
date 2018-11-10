#!/usr/bin/env bash
PGDATA=/var/lib/postgresql
su - postgres -c "postgres -c listen_addresses='*' -D $PGDATA/gnafdatabase"