rm -rf copy.sql mycopy.sh
iconv -f GBK -t UTF-8 ./datas/customer.dat -o ./datas/tcustomer.dat  #把编码转换成UTF-8
sed -i 's/'"'"/' ''/g' ./datas/customer.dat                          #把包含有 ‘ 的给去掉，不然计算节点会不认识报错
for i in `ls -l ./datas/ | awk '{print $9}'`
do
	sed -i 's/.$//g' ./datas/$i
	echo $i 
	table=`echo $i | sed 's/....$//'`
	if [[ "$1" == "pgsql" ]]
        then
                echo "\COPY    dbgen_version from 'datas/dbgen_version.dat' with DELIMITER '|' NULL ''  ;" >> copy.sql
	elif [[ "$1" == "mysql" ]]
	then
		echo $table
		echo "mysql --defaults-file=$2  -uroot -proot --local-infile=1 -e \" use $3; LOAD DATA LOCAL INFILE './datas/$i' INTO TABLE $table FIELDS TERMINATED BY '|';\"" >> mycopy.sh
		mysql --defaults-file=$2  -uroot -proot --local-infile=1 -e " use $3; LOAD DATA LOCAL INFILE './datas/$i' INTO TABLE $table FIELDS TERMINATED BY '|';"
	fi
done
