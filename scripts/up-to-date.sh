#!/bin/sh
# Whether packages.dorhawk.software serves every package in DIR already
# (the hourly run's question: nothing new, nothing to do). Exit 0: all
# there.
#   scripts/up-to-date.sh DIR [URL]
set -eu
URL=${2:-https://packages.dorhawk.software}
for f in "$1"/*.deb "$1"/*.rpm; do
    [ -e "$f" ] || continue
    case "$f" in
        *.deb) at=apt/pool/main ;;
        *) at=rpm ;;
    esac
    if ! curl -fsSI -o /dev/null "$URL/$at/$(basename "$f")"; then
        echo "new: $(basename "$f")"
        exit 1
    fi
done
echo "nothing new"
