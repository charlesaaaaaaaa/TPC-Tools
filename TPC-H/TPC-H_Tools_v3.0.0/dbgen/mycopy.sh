if [[ -f copy.sql ]] ; then  rm -rf tb.txt && echo " delete file tb.txt "; else echo "begin"; fi
if [[ -f copy.txt ]] ; then  rm -rf tb.txt && echo " delete file tb.txt "; else echo "begin"; fi
rm -rf copy.sql copy.txt

echo customer >> copy.txt
echo lineitem >> copy.txt
echo nation   >> copy.txt
echo orders   >> copy.txt
echo partsupp >> copy.txt
echo part     >> copy.txt
echo region   >> copy.txt
echo supplier >> copy.txt
mysql --defaults-file=$1 -uroot -proot --local-infile=1 -e "set global enable_fullsync = OFF;"

for a in `seq 1 9`
do
	ab=`sed -n ${a}p copy.txt`
	echo "delete from ${ab} ;" >> copy.sql
	for i in ${ab}
	do
		for ia in $(ls ./table | grep ${ab})
		do
			#sql="use mysql; LOAD DATA LOCAL INFILE './table/${ia}' INTO TABLE ${ab} FIELDS TERMINATED BY '|' lines terminated by '|\n';"
			sql="use mysql; LOAD DATA LOCAL INFILE './table/${ia}' INTO TABLE ${ab} FIELDS TERMINATED BY '|';"
			echo mysql --defaults-file=$1 -uroot -proot --local-infile=1 -e "$sql"
			echo mysql --defaults-file=$1 -uroot -proot --local-infile=1 -e "$sql" > mycopy.sql
			mysql --defaults-file=$1 -uroot -proot --local-infile=1 -e "$sql"
		done
	done
done

