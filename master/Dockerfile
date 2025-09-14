FROM postgres:15

COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf
COPY init-replica-user.sql /docker-entrypoint-initdb.d/

RUN chown -R postgres:postgres /etc/postgresql 

USER postgres

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf", "-c", "hba_file=/etc/postgresql/pg_hba.conf"]
