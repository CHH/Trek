
vendor_execute() {
    local query=$(cat)

    if [ -z "$version" ]; then
        version=3
    fi

    local bin="sqlite$version"

    "$bin" "$database" "$query"
}

vendor_map_type() {
    case "$1" in
        unsigned)
            echo
            ;;
        "INT(11)")
            echo "INTEGER"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

vendor_table_exists() {
    local table="$1"
    local sql="SELECT name FROM sqlite_master WHERE name='$table';"

    local result=$(trek-query <<< "$sql")

    if [ -n "$result" ]; then
        return 0
    else
        return 1
    fi
}

vendor_autoincrement_expression() {
    echo "AUTOINCREMENT"
}
