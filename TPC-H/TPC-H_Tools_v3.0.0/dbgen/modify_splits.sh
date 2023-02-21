mkdir table
echo 'mv *tbl table'
mv *tbl table
echo 'start split'

for i in `ls table`
do
	cd table
	table=`echo $i | sed 's/.tbl//'`
	echo $table
	sed -i 's/.$//' $i
	split -l 300000 -d $i ${table}-
	rm -rf $i
	cd ..
done
