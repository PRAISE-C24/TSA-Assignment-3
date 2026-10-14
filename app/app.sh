#!/usr/bin/env bash
set -u

print_help() {
    echo "=========================================="
    echo "          BASH CLI TOOLKIT                "
    echo "=========================================="
    echo "Usage: $0 <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  system-info                Display system information"
    echo "  check-host <host>          Resolve and check a host"
    echo "  check-port <host> <port>   Validate port and check TCP connectivity"
    echo "  help                       Display this help message"
    echo "=========================================="
}

CMD="${1:-help}"
shift || true

case "$CMD" in
    system-info)
        echo "Hostname: $(hostname)"
        echo "User:     $(whoami)"
        echo "Kernel:   $(uname -r)"
        echo "Uptime:   $(uptime -p 2>/dev/null || uptime)"
        ;;
    check-host)
        HOST="${1:-}"
        if [ -z "$HOST" ]; then
            echo "Error: Host argument is required." >&2
            exit 2
        fi
        echo "Resolving host: $HOST"
        getent hosts "$HOST" 2>/dev/null || nslookup "$HOST" 2>/dev/null || ping -c 1 -W 2 "$HOST" 2>/dev/null
        ;;
    check-port)
        HOST="${1:-}"
        PORT="${2:-}"
        if [ -z "$HOST" ] || [ -z "$PORT" ]; then
            echo "Error: Both host and port arguments are required." >&2
            exit 2
        fi
        # Validate port number (1-65535)
        if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
            echo "Error: Invalid port '$PORT'. Must be an integer between 1 and 65535." >&2
            exit 2
        fi
        echo "Checking TCP port $PORT on $HOST..."
        if nc -z -w 3 "$HOST" "$PORT" &>/dev/null; then
            echo "Status: Port $PORT is OPEN."
        else
            echo "Status: Port $PORT is CLOSED or filtered."
            exit 1
        fi
        ;;
    help)
        print_help
        ;;
    *)
        echo "Error: Unknown command '$CMD'." >&2
        print_help
        exit 2
        ;;
esac