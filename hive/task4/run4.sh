#!/usr/bin/env bash
set -euo pipefail
DB="${1:?Usage: ./run4.sh <db_name>}"
hive --hiveconf db_name="$DB" -f "$(dirname "$0")/query.hql"
