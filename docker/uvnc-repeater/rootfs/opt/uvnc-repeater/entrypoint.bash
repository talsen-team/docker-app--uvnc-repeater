#!/bin/bash

set -euo pipefail

OVERRIDE_MARKER="/.is-overridden"

IS_OVERRIDDEN="false"
if [ -f "${OVERRIDE_MARKER}" ] ;
then
  IS_OVERRIDDEN="true"
fi

function export_default() {
  local DEFAULT_DIR="/default"
  local UVNC_CFG_DIR="/etc/uvnc/"

  if [ "${IS_OVERRIDDEN}" = "false" ] ;
  then
    mkdir --parents "${DEFAULT_DIR}${UVNC_CFG_DIR}"
    rsync --archive "${UVNC_CFG_DIR}" "${DEFAULT_DIR}${UVNC_CFG_DIR}"
  fi
}

function import_override() {
  local OVERRIDE_DIR="/override"

  mkdir --parents "${OVERRIDE_DIR}"
  rsync --archive "${OVERRIDE_DIR}/" "/"

  touch "${OVERRIDE_MARKER}"
}

UVNCREPLOG=/var/log/uvncrepeater.log
UVNCREPSVC=/usr/sbin/uvncrepeatersvc
UVNCREPINI=/etc/uvnc/uvncrepeater.ini

export_default
import_override

${UVNCREPSVC} ${UVNCREPINI} 2>> ${UVNCREPLOG}
