mkdir query
for q in `seq 1 22`
do
    DSS_QUERY=dss/templates ./qgen $q >> query/$q.sql
    sed 's/^select/explain select/' query/$q.sql > query/$q.explain.sql
    cat query/$q.sql >> query/$q.explain.sql;
    sed -i 's///' query/${q}.sql
    sed -i 's///' query/${q}.explain.sql
done
