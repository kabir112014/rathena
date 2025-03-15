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


# Prepare the config/import directory
if [[ -z $CONF_DIR ]]; then
    CONF_DIR=/rathena/conf
fi

if [[ ! -d  "$CONF_DIR/import" ]]; then
    mkdir -p "$CONF_DIR/import"
fi

function copy_tmpl() {
    if [[ ! -f "$CONF_DIR/import/$1" && -f "$CONF_DIR/import-tmpl/$1" ]]; then
        cp "$CONF_DIR/import-tmpl/$1" "$CONF_DIR/import/$1"
    fi
}

for conf_file in "$CONF_DIR/import-tmpl/*"
do
    conf_file_name=$(basename $conf_file)
    copy_tmpl $conf_file_name
done

# Configure MySQL connection
INTER_CONFIG="$CONF_DIR/import/inter_conf.txt"

function set_config() {
    has_config=$(grep -E "^$1:.*$" $INTER_CONFIG)
    if [[ ! -z $has_config ]]; then
        sed -i "s/^$1:.*$/$1: $2/g" $INTER_CONFIG
    else
        printf "\n$1: $2" >> $INTER_CONFIG
    fi
}

set_config login_server_ip $DB_HOST
set_config login_server_port $DB_PORT
set_config login_server_id $DB_USER
set_config login_server_pw $DB_PASS
set_config login_server_db $DB_NAME

set_config ipban_db_ip $DB_HOST
set_config ipban_db_port $DB_PORT
set_config ipban_db_id $DB_USER
set_config ipban_db_pw $DB_PASS
set_config ipban_db_db $DB_NAME

set_config char_server_ip $DB_HOST
set_config char_server_port $DB_PORT
set_config char_server_id $DB_USER
set_config char_server_pw $DB_PASS
set_config char_server_db $DB_NAME

set_config map_server_ip $DB_HOST
set_config map_server_port $DB_PORT
set_config map_server_id $DB_USER
set_config map_server_pw $DB_PASS
set_config map_server_db $DB_NAME

set_config web_server_ip $DB_HOST
set_config web_server_port $DB_PORT
set_config web_server_id $DB_USER
set_config web_server_pw $DB_PASS
set_config web_server_db $DB_NAME

set_config log_db_ip $DB_HOST
set_config log_db_port $DB_PORT
set_config log_db_id $DB_USER
set_config log_db_pw $DB_PASS
set_config log_db_db $DB_NAME