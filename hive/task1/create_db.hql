CREATE DATABASE IF NOT EXISTS ${hiveconf:db_name}
LOCATION '${hiveconf:db_path}';

-- на всякий случай
USE ${hiveconf:db_name};
