#!/bin/bash

set -eu

: ${PUID:=1000}
: ${PGID:=100}
: ${USER:="jdownloader"}

# Create folders if they are missing
mkdir -p /jd2 /downloads

# Copy JDownloader2 to ${APP_HOME} if it's not already existent
if [ ! -f /jd2/JDownloader.jar ]; then
  cp -r /usr/local/share/jd2 /
fi

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

# Ensure persistent firefox profile
mkdir -p "/jd2/.mozilla"
ln -sf "/jd2/.mozilla" "/home/${USER}/.mozilla"

# Fix permissions
chown -R ${PUID}:${PGID} /jd2 /downloads
chmod -R g+rw /jd2 /downloads

# Start Xpra with JDownloader
: ${APP:="jd2launcher"}
: ${CMD:="XPRA_PASSWORD='${XPRA_PASSWORD}' /usr/bin/xpra start --daemon=no --exit-with-children=no --start='${APP}'"}
runuser -l "${USER}" -c "${CMD}"
