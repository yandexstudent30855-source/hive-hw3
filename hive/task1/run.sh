#!/usr/bin/env bash
set -euo pipefail

DB="${1:?Usage: ./run1.sh <db_name> <hdfs_path>}"
PATH_HDFS="${2:?Usage: ./run1.sh <db_name> <hdfs_path>}"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

hive --hiveconf db="$DB" \
     --hiveconf path="$PATH_HDFS" \
     -f "$DIR/create_db.hql"
