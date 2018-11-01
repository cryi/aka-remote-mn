#!/bin/bash

function script_usage() {
    cat << EOF
Usage:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colour             Disables colour output
    -cr|--cron                  Run silently unless we encounter an error
EOF
}

function parse_params() {
    local param
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h|--help)
                script_usage
                exit 0
                ;;
            -f|--force)
                force=true
                ;;
            -p|--path)
                path="$1"
                shift
                ;;
            *)
                echo "Invalid parameter was provided: $param"
                exit 2
                ;;
        esac
    done
}
parse_params "$@"

if [ ! -d "$path" ] && [ ! -f "$path" ]; then
        echo "Path '$1' not found!";
        exit;
fi;
uid=$(grep "dockremap" /etc/subuid)
uid=$(echo $uid | cut -d ":" -f 2)
uid=$(($uid + 1000))
if [ $force = true ]; then
    REPLY="y"
else
    read -p "Do you really make '$path' writable from containers (!!! do not use for system folders !!!)? (y/N) " -n 1 -r
    echo
fi
if [[ $REPLY =~ ^[Yy]$ ]]
then
    chown -R $uid:$uid $path &&  echo "Access permission to '$path' set to uid $uid (allows container to write into fs)"
    exit $?
fi
