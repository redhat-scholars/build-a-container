#!/bin/bash

set -euo pipefail

declare SITE=${1:-site.yml}
declare REPO=${2:-https://github.com/hatmarch/cdc-data-monolith}
declare BRANCH="gh-pages"

echo "Removing old publish directory"
if [[ -d $DEMO_HOME/publish ]]; then
    rm -rf $DEMO_HOME/publish 
fi

git clone -b ${BRANCH} ${REPO} $DEMO_HOME/publish

echo "Generating the site documentation from ${SITE}"

antora generate --stacktrace $DEMO_HOME/${SITE} --to-dir $DEMO_HOME/publish

echo "Pushing site to ${BRANCH} branch of ${REPO}"
cd $DEMO_HOME/publish
git add --all .
git commit -m"Automated Publish" 
git push origin

echo "Site published successfully!"