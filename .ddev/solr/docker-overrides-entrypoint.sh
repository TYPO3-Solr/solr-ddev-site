#!/bin/bash

set -e

echo '$@ = '"$@"

everrideSolrUnixUidAndGidAndSetPermissions ()
{
  if [[ -v SOLR_OVERRIDE_UID ]] && grep -E -q '^[0-9]+$' <<<"${SOLR_OVERRIDE_UID:-}"; then
    usermod -u "$SOLR_OVERRIDE_UID" solr
  fi

  if [[ -v SOLR_OVERRIDE_GID ]] && grep -E -q '^[0-9]+$' <<<"${SOLR_OVERRIDE_GID:-}"; then
    groupmod -g "$SOLR_OVERRIDE_GID" solr
  fi

  chown -R solr:solr /var/solr
}

everrideSolrUnixUidAndGidAndSetPermissions

su solr --preserve-environment -c 'docker-entrypoint.sh '"$@"
