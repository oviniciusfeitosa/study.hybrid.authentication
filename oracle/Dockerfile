FROM gvenzl/oracle-xe:21-slim

ENV ORACLE_PASSWORD=oracle
ENV ORACLE_DATABASE=XEPDB1
ENV APP_USER=app_user
ENV APP_USER_PASSWORD=app_password

COPY init.sql /container-entrypoint-initdb.d/

EXPOSE 1521
