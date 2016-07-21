#!/bin/bash

set -e

# Download IntelliJ IDEA Community Edition, if absent.
if ! test -e "${HOME}"/idea-IC-*; then
  wget -O "${HOME}/idea.tgz" "https://download.jetbrains.com/idea/ideaIC-2016.2.tar.gz"
  tar zxvf "${HOME}/idea.tgz" -C "${HOME}"
fi

# Install some of the JARs shipped with IntelliJ IDEA into the local Maven
# repository.
IDEA_HOME="$(cd "${HOME}"/idea-IC-*; pwd -P)"
chmod 755 ./idea_plugin/src/main/scripts/install-idea-jars.sh
(cd idea_plugin && src/main/scripts/install-idea-jars.sh "${IDEA_HOME}")

# Build and install the formatter and plugins.
IDEA_VERSION="$(echo $IDEA_HOME | grep -oP '(?<=idea-I[CU]-).*')"
mvn -B -V install -Didea.platform.version="${IDEA_VERSION}" -DskipTests=true
