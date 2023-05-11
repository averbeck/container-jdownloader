#!/bin/bash

set -eu

: ${PUID:=1000}
: ${PGID:=100}
: ${USER:=xpra}

# Ensure user and group
getent group "${PGID}" || groupadd -g "${PGID}" "${USER}"
getent passwd "${PUID}" || useradd --create-home --shell /bin/bash "${USER}" --uid "${PUID}" --gid "${PGID}"
rm -rf "/run/user/${PUID}"
mkdir -p "/run/user/${PUID}/${USER}"
chown -R "${PUID}" "/run/user/${PUID}"
chmod -R 700 "/run/user/${PUID}"

# Start Xpra as xpra user with command specified in dockerfile as CMD or passed as parameter to docker run
CMD="XPRA_PASSWORD=$XPRA_PASSWORD /usr/bin/xpra start --daemon=no --start-child='$@'"
runuser -l "${USER}" -c "${CMD}"
