#!/bin/bash

set -e

echo '$@ = '"$@"

overrideSolrUnixUidAndGidAndSetPermissions ()
{
  if [[ -v SOLR_OVERRIDE_UID ]] && grep -E -q '^[0-9]+$' <<<"${SOLR_OVERRIDE_UID:-}"; then
    usermod --non-unique --uid "$SOLR_OVERRIDE_UID" solr
  fi

  if [[ -v SOLR_OVERRIDE_GID ]] && grep -E -q '^[0-9]+$' <<<"${SOLR_OVERRIDE_GID:-}"; then
    groupmod --non-unique --gid "$SOLR_OVERRIDE_GID" solr
  fi

  chown -R solr:solr /var/solr
}

overrideSolrUnixUidAndGidAndSetPermissions

runuser solr -c 'docker-entrypoint.sh '"$@"
