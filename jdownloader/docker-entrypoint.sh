#!/bin/bash

set -eu

: ${PUID:=1000}
: ${PGID:=100}
: ${USER:=jdownloader}

# Create folders if they are missing
mkdir -p /jd2 /downloads

# Copy JDownloader2 to ${APP_HOME} if it's not already existent
if [ ! -f /jd2/JDownloader.jar ]; then
  cp -r /usr/local/share/jd2 /
fi

# Ensure user and group
getent group "${PGID}" || groupadd -g "${PGID}" "${USER}"
getent passwd "${PUID}" || useradd --create-home --shell /bin/bash "${USER}" --uid "${PUID}" --gid "${PGID}"
rm -rf "/run/user/${PUID}"
mkdir -p "/run/user/${PUID}/${USER}"
chown -R "${PUID}" "/run/user/${PUID}"
chmod -R 700 "/run/user/${PUID}"

# Fix permissions
chown -R ${PUID}:${PGID} /jd2 /downloads
chmod -R g+rw /jd2 /downloads

# Start Xpra as xpra user with command specified in dockerfile as CMD or passed as parameter to docker run
#APP="$@"
APP="jd2launcher"
CMD="XPRA_PASSWORD=$XPRA_PASSWORD /usr/bin/xpra start --daemon=no --webcam=no --exit-with-children=no --start-child='${APP}'"
runuser -l "${USER}" -c "${CMD}"
