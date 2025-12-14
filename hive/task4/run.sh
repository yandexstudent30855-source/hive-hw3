#!/usr/bin/env bash
set -euo pipefail

DB="${1:?Usage: ./run4.sh <db_name>}"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

hive --hiveconf db="$DB" -f "$DIR/query.hql"
