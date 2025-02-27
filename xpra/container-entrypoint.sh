#!/bin/bash

set -eu

: ${PUID:=1000}
: ${PGID:=100}
: ${USER:=xpra}

# Ensure user and group
USER_OLD="$(getent passwd "${PUID}" | cut -f1 -d:)"
if [ -z "${USER_OLD}" ]; then
  getent group "${PGID}" || groupadd -g "${PGID}" "${USER}"
  useradd --create-home --shell /bin/bash "${USER}" --uid "${PUID}" --gid "${PGID}"
else
  getent group "${PGID}" || groupadd -g "${PGID}" "${USER}"
  usermod --login "${USER}" --move-home --home "/home/${USER}" "${USER_OLD}"
fi
usermod -a -G "${PGID}" "${USER}"

rm -rf "/run/user/${PUID}"
mkdir -p "/run/user/${PUID}/${USER}"
chown -R "${PUID}" "/run/user/${PUID}"
chmod -R 700 "/run/user/${PUID}"

# Start Xpra as xpra user with command specified in dockerfile as CMD or passed as parameter to docker run
CMD="XPRA_PASSWORD=$XPRA_PASSWORD /usr/bin/xpra start --daemon=no --start-child='$@'"
runuser -l "${USER}" -c "${CMD}"
