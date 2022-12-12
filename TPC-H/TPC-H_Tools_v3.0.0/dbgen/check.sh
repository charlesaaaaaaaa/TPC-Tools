
total=`cat $1 | grep cost | awk '{a=a+$5}END{print a}'`
echo "=== total_cost: ${total}s"

echo "|| sql || result || cost || error ||"

for i in `cat $1 | grep begin | awk '{print $3}' | sed 's/,//'`
do 
	test=`cat $1 | grep -A 3 -w "begin run $i" | grep ERROR`
	times=`cat $1 | grep -w "^run $i" | awk '{print $5}' | sed 's/,//'`
	if [[ -n "$test" ]]
	then
		err=`grep -w -A 2 "begin run $i" $1 | grep ERROR | awk '$1=$2=$3=""; {print $0}' | sed 's/   //'` 
		echo "|| $i || fail || $times || $err ||"
	else 
		echo "|| $i || succ || $times || ||"
	fi
done
