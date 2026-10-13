#!/bin/sh
# Each app's packages (apps.json) from its latest GitHub release into DIR:
# the .deb and the RPM, as the app's own release workflow built them. With
# REPO and TAG (a release that asked to be published), that release
# instead of the latest for that app. Needs gh (GH_TOKEN on CI).
#   scripts/fetch-releases.sh DIR [REPO TAG]
set -eu
cd "$(dirname "$0")/.."
DIR=$1
mkdir -p "$DIR"
for repo in $(jq -r '.[].repo' apps.json); do
    if [ "${2:-}" = "$repo" ] && [ -n "${3:-}" ]; then
        gh release download "$3" --repo "$repo" --pattern '*.deb' --pattern '*.rpm' --dir "$DIR" --clobber
    else
        gh release download --repo "$repo" --pattern '*.deb' --pattern '*.rpm' --dir "$DIR" --clobber
    fi
done
ls "$DIR"
