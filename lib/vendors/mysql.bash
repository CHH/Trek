# MySQL Specifics

# Execute the sql query given as input stream
# All variables defined by the user's dbconfig are available
vendor_execute() {
    query="$(cat)"
    options=

    if [ -n "$username" ]; then
        options="$options --user=$username"
    fi

    if [ -n "$password" ]; then
        options="$options --password=$password"
    fi

    if [ -n "$hostname" ]; then
        options="$options --host=$hostname"
    fi

    if [ -n "$port" ]; then
        options="$options --port=$port"
    fi

    if [ -n "$socket" ]; then
        options="$options --socket=$socket"
    fi

    mysql $options --skip-column-names $database <<< "$query"
}

# Maps types from table definitions to actual MySQL Types
vendor_map_type() {
    echo "$1"
}

vendor_table_exists() {
    local result=$(trek-query <<< "SHOW TABLES LIKE '$1';")

    if [ -z "$result" ]; then
        return 1
    fi
}

vendor_autoincrement_expression() {
    echo "AUTO_INCREMENT"
}
