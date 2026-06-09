#!/usr/bin/env bash

# Manage Docker container like in vagrant using the folder you are in CWD for start/stop/etc
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

LABEL="dagrant.dir=$DIR"
PROJ="$(basename "$DIR")"

mode() {
    for f in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
        [ -f "$DIR/$f" ] && echo compose && return
    done
    [ -f "$DIR/Dockerfile" ] && echo dockerfile && return
    echo none
}

dcomp() {
    if docker compose version &>/dev/null; then
        docker compose "$@"
    elif command -v docker-compose &>/dev/null; then
        docker-compose "$@"
    else
        echo "Error: docker compose not found" >&2; exit 1
    fi
}

cid()        { docker ps -a --filter "label=$LABEL" -q | head -1; }
cid_running() { docker ps --filter "label=$LABEL" -q | head -1; }

shell_into() {
    docker exec -it "$1" bash 2>/dev/null || docker exec -it "$1" sh
}

cmd_start() {
    local m=$(mode)
    case "$m" in
        compose)
            dcomp up -d
            ;;
        dockerfile)
            local c=$(cid)
            if [ -n "$c" ]; then
                docker start "$c"
            else
                docker build -t "${PROJ}-dagrant" "$DIR"
                docker run -d --label "$LABEL" --name "${PROJ}-dagrant" "${PROJ}-dagrant"
            fi
            ;;
        none)
            echo "No Dockerfile or compose file found in $DIR" >&2
            exit 1
            ;;
    esac
}

cmd_stop() {
    local m=$(mode)
    case "$m" in
        compose)  dcomp stop ;;
        dockerfile)
            local c=$(cid_running)
            [ -n "$c" ] && docker stop "$c" || echo "Not running"
            ;;
    esac
}

cmd_logs() {
    local m=$(mode)
    case "$m" in
        compose)  dcomp logs -f ;;
        dockerfile)
            local c=$(cid)
            if [ -n "$c" ]; then
                docker logs -f "$c"
            else
                echo "No container found" >&2; exit 1
            fi
            ;;
    esac
}

cmd_bash() {
    local m=$(mode) c
    case "$m" in
        compose)
            c=$(dcomp ps -q 2>/dev/null | head -1)
            if [ -n "$c" ]; then
                shell_into "$c"
            else
                echo "No running container" >&2; exit 1
            fi
            ;;
        dockerfile)
            c=$(cid_running)
            if [ -n "$c" ]; then
                shell_into "$c"
            else
                echo "Not running" >&2; exit 1
            fi
            ;;
    esac
}

cmd_status() {
    local m=$(mode)
    case "$m" in
        compose)  dcomp ps ;;
        dockerfile)
            local c=$(cid)
            if [ -n "$c" ]; then
                docker ps -a --filter "label=$LABEL" \
                    --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
            else
                echo "No container for $DIR"
            fi
            ;;
    esac
}

cmd_destroy() {
    local m=$(mode)
    case "$m" in
        compose)  dcomp down ;;
        dockerfile)
            local c=$(cid)
            if [ -n "$c" ]; then
                docker rm -f "$c"
                docker rmi "${PROJ}-dagrant" 2>/dev/null || true
            else
                echo "No container found" >&2
            fi
            ;;
    esac
}

case "${1:-}" in
    start)   cmd_start   ;;
    stop)    cmd_stop    ;;
    logs)    cmd_logs    ;;
    bash)    cmd_bash    ;;
    status)  cmd_status  ;;
    destroy) cmd_destroy ;;
    *)
        echo "Usage: ./dagrant {start|stop|logs|bash|status|destroy}"
        echo ""
        echo "  start    Build (if needed) and start"
        echo "  stop     Stop containers"
        echo "  logs     Follow logs (Ctrl+C to exit)"
        echo "  bash     Shell into the main container"
        echo "  status   Show container status"
        echo "  destroy  Remove containers and images"
        exit 1
        ;;
esac
