#!/usr/bin/env bash
set -euo pipefail

DB="${1:?Usage: ./run1.sh <db_name> <hdfs_path>}"
PATH_HDFS="${2:?Usage: ./run1.sh <db_name> <hdfs_path>}"

hive --hiveconf db_name="$DB" \
     --hiveconf db_path="$PATH_HDFS" \
     -f "$(dirname "$0")/create_db.hql"
