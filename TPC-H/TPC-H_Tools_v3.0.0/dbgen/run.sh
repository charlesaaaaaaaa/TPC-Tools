host=${1:-'172.28.89.156'} #default host

port=${2:-'12389'} #default port

db=${3:-'tpch'} #default db_name

pwds=${5:-'abc'} #default password

user=${4:-'abc'} #defult user

rm -rf ./run_log/
mkdir run_log

total_cost=0
for i in {1..22}
#for i in 4 16 17 22
do
        echo "begin run Q${i}, query/$i.sql , `date`"
        begin_time=`date +%s.%N`
        PGPASSWORD=${pwds} psql -h ${host} -p ${port} -d ${db} -U ${user}  -f query/${i}.sql > ./run_log/log_q${i}.out
        rc=$?
        end_time=`date +%s.%N`
        cost=`echo "$end_time-$begin_time"|bc`
        total_cost=`echo "$total_cost+$cost"|bc`
        if [ $rc -ne 0 ] ; then
              printf "run Q%s fail, cost: %.2f, totalCost: %.2f, `date`\n" $i $cost $total_cost
         else
              printf "run Q%s succ, cost: %.2f, totalCost: %.2f, `date`\n" $i $cost $total_cost
         fi
done
