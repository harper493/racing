#
# build-tables.sh
#
# Usage is:
#
# ./build-tables.sh database-name [criteria]
#
# [criteria] is made from the where statement of the data to be extracted from
# the raw data, e.g. type='' and racedate>'2022-01-01'
#

if [ "$1" = '' ]
then
    echo '    usage is build-tables.sh database-name [criteria]'
    echo '    where [criteria] is the content of the WHERE clause to select from raw data'
    echo "    NOTE: column names must be preceded by 'rawdata.' e.g. rawdata.type=''"
    exit 1
fi

db=$1

if [ "$2" = '' ]
then
    where=''
else
    where="where $2"
fi    

sql=mysql
sqldb="$sql --database=$db"

# Make all tables, and populate the base data

echo "create database if not exists $db;" | $sql

$sqldb < make-tables.sql
sed "s/#where#/$where/" build-tables.sql | $sqldb

# Now update all the derived summary tables

$sqldb < make-goings.sql
$sqldb < make-lengths.sql
$sqldb < update-goings.sql
$sqldb < update-lengths.sql
$sqldb < update-correction.sql

# Update goings and lengths again to get corrected values

$sqldb < update-goings.sql
$sqldb < update-lengths.sql

# Update each of the summary classes

sed 's/#type#/trainer/g' update-summary-generic.sql | $sqldb
sed 's/#type#/jockey/g'  update-summary-generic.sql | $sqldb
sed 's/#type#/horse/g'   update-summary-generic.sql | $sqldb
$sqldb < update-horses-extra.sql

# Clean up


