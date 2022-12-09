echo 'mv *tbl table'
mv *tbl table
echo 'start split'

for i in `ls table`
do
	cd table
	table=`echo $i | sed 's/.tbl//'`
	echo $table
	split -l 3000000 -d $i ${table}-
	cd ..
done
