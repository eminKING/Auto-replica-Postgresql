CREATE DATABASE test_db;

\c test_db

CREATE TABLE test_replication (
    id SERIAL PRIMARY KEY,
    message TEXT
);

INSERT INTO test_replication(message) VALUES ('Hello from master!');

CREATE ROLE replica_user WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'replica_pass';
