export sql='mysql'

sed "s/#file#/$1/g" load-raw.sql | $sql --database=raw --local-infile=1
