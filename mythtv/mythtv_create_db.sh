#!/bin/bash

#echo "Reading info from ${MYTH_CONFIG}"
db_name=mythconverg
db_user=mythtv
db_pass=mythtv
db_host=localhost
db_port=3306

echo "Creating user ${db_user} and database ${db_name}"

# the user doesn't exist yet, we create it here
mysql -uroot --port "${db_port}" <<SQL
CREATE DATABASE IF NOT EXISTS ${db_name};
GRANT ALL ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_pass}';
GRANT ALL ON ${db_name}.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';
FLUSH PRIVILEGES;
-- GRANT CREATE TEMPORARY TABLES ON ${db_name}.* TO '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';
FLUSH PRIVILEGES;
-- ALTER DATABASE ${db_name} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
SELECT User,Host from mysql.user;
SQL



