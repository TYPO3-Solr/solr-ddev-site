#!/bin/bash

directoryOfCurrentScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sqlFilePath="$directoryOfCurrentScript/not_covered_by_impexp.sql"

if [[ -f "$directoryOfCurrentScript/not_covered_by_impexp.isImported" ]]; then
  echo "The SQL file \"not_covered_by_impexp.sql\" was already imported, skip this step."
  exit 0;
fi

< "$sqlFilePath" typo3cms 'database:import' && touch "$directoryOfCurrentScript"/"not_covered_by_impexp.isImported" && exit 0

exit 1;

