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


function set_config() {
    has_config=$(grep -E "^$2:.*$" $1)
    if [[ ! -z $has_config ]]; then
        sed -i "s/^$2:.*$/$2: $3/g" $1
    else
        printf "\n$2: $3\n" >> $1
    fi
}

# Configure MySQL connection
INTER_CONFIG="$CONF_DIR/import/inter_conf.txt"

set_config $INTER_CONFIG login_server_ip $DB_HOST
set_config $INTER_CONFIG login_server_port $DB_PORT
set_config $INTER_CONFIG login_server_id $DB_USER
set_config $INTER_CONFIG login_server_pw $DB_PASS
set_config $INTER_CONFIG login_server_db $DB_NAME

set_config $INTER_CONFIG ipban_db_ip $DB_HOST
set_config $INTER_CONFIG ipban_db_port $DB_PORT
set_config $INTER_CONFIG ipban_db_id $DB_USER
set_config $INTER_CONFIG ipban_db_pw $DB_PASS
set_config $INTER_CONFIG ipban_db_db $DB_NAME

set_config $INTER_CONFIG char_server_ip $DB_HOST
set_config $INTER_CONFIG char_server_port $DB_PORT
set_config $INTER_CONFIG char_server_id $DB_USER
set_config $INTER_CONFIG char_server_pw $DB_PASS
set_config $INTER_CONFIG char_server_db $DB_NAME

set_config $INTER_CONFIG map_server_ip $DB_HOST
set_config $INTER_CONFIG map_server_port $DB_PORT
set_config $INTER_CONFIG map_server_id $DB_USER
set_config $INTER_CONFIG map_server_pw $DB_PASS
set_config $INTER_CONFIG map_server_db $DB_NAME

set_config $INTER_CONFIG web_server_ip $DB_HOST
set_config $INTER_CONFIG web_server_port $DB_PORT
set_config $INTER_CONFIG web_server_id $DB_USER
set_config $INTER_CONFIG web_server_pw $DB_PASS
set_config $INTER_CONFIG web_server_db $DB_NAME

set_config $INTER_CONFIG log_db_ip $DB_HOST
set_config $INTER_CONFIG log_db_port $DB_PORT
set_config $INTER_CONFIG log_db_id $DB_USER
set_config $INTER_CONFIG log_db_pw $DB_PASS
set_config $INTER_CONFIG log_db_db $DB_NAME

# Configure IP Addresses
set_config "$CONF_DIR/import/login_conf.txt" bind_ip "0.0.0.0"
set_config "$CONF_DIR/import/char_conf.txt" bind_ip "0.0.0.0"
set_config "$CONF_DIR/import/map_conf.txt" bind_ip "0.0.0.0"
set_config "$CONF_DIR/import/web_conf.txt" bind_ip "0.0.0.0"

if [[ ! -z $LOGIN_HOST ]]; then
    set_config "$CONF_DIR/import/char_conf.txt" login_ip "$LOGIN_HOST"
fi

if [[ ! -z $CHAR_HOST ]]; then
    set_config "$CONF_DIR/import/map_conf.txt" char_ip "$CHAR_HOST"
fi

if [[ ! -z $CHAR_PUBLIC_HOST ]]; then
    set_config "$CONF_DIR/import/char_conf.txt" char_ip "$CHAR_PUBLIC_HOST"
fi

if [[ ! -z $MAP_PUBLIC_HOST ]]; then
    set_config "$CONF_DIR/import/map_conf.txt" map_ip "$MAP_PUBLIC_HOST"
fi