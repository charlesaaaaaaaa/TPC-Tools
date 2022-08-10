cd tools
for i in `seq 1 99`
do
	./dsqgen  -DIRECTORY ../query_templates/ -TEMPLATE "query${i}.tpl" -DIALECT netezza -FILTER Y > ../query/q${i}.sql
done
