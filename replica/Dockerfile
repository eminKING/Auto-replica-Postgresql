FROM postgres:15

COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && chown -R postgres:postgres /etc/postgresql

USER postgres

ENTRYPOINT ["/entrypoint.sh"]
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf", "-c", "hba_file=/etc/postgresql/pg_hba.conf"]
