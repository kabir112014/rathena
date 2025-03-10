#!/usr/bin/env bash

# Set the following environment variables:
# DB_USER
# DB_PASS
# DB_HOST
# DB_PORT
# DB_NAME

function execute_sql() {
    echo "Executing $1"
    mysql -u $DB_USER --password=$DB_PASS -h $DB_HOST -P $DB_PORT -D $DB_NAME < $1
}

TABLE_EXISTS=$(echo -n "SHOW TABLES LIKE 'login'" | mysql -u $DB_USER --password=$DB_PASS -h $DB_HOST -P $DB_PORT -D $DB_NAME)

if [[ -z $TABLE_EXISTS ]]; then
    execute_sql "/sql-files/main.sql"
    execute_sql "/sql-files/logs.sql"
    execute_sql "/sql-files/roulette_default_data.sql"
    execute_sql "/sql-files/web.sql"
fi