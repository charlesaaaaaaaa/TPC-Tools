process_num=${1:-'5'}
if [[ $# != 1 ]]
then
	echo 默认的开启的进程数是 5
	echo 如果想要其它进程数可以：bash copy.sh 进程数
	echo -e '===========================================\n'
fi
rm -rf mycopy.sql && touch mycopy.sql
rm -rf mydel.sql && touch mydel.sql
for i in `ls table | awk -F- '{print $1}' | sort | uniq`
do
	echo "delete from $i; " >> mydel.sql
done

for i in `ls table`
do
	table=`echo $i | awk -F- '{print $1}'`
	echo "use tpch; LOAD DATA LOCAL INFILE './table/${i}' INTO TABLE ${table} FIELDS TERMINATED BY '|';" >> mycopy.sql
done

total_line_num=`cat mycopy.sql | wc -l`
each_process_line=`echo "scale=0;$total_line_num/${process_num}+1" | bc -l`
echo fileNum=$total_line_num 
echo open $process_num process, at least need $each_process_line line each process
echo -e '=============================================================================\n'

rm -rf split && mkdir -p split
split -l $each_process_line -d mycopy.sql ./split/mycopy-

cat << EOF > myload.sh
sock=\${1:-''}
#port=\${2:-'12389'}
#db=\${3:-'tpch'}
#user=\${4:-'abc'}
#pwd=\${5:-'abc'}
PGPASSWORD=\$pwd psql -h \$host -p \$port -U \$user -d \$db -f del.sql
for i in \`ls split\`
do
	mysql --defaults-file=$1 -uroot -proot --local-infile=1 -e "$sql" > mycopy.sql &
done
echo 请通过 ps -ef | grep psql 查看当前copy的进程
EOF

echo 开启灌数据进程，使用
echo bash load.sh host port dbname user pwd
echo 如：bash load.sh 192.168.0.132 35001 tpch abc abc
echo -e '===============================================\n'
