# 环境设置
## tpcds-kit:

The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).

This version is based on v2.10.0 and has been modified to:

* Allow compilation under macOS (commit [2ec45c5](https://github.com/gregrahn/tpcds-kit/commit/2ec45c5ed97cc860819ee630770231eac738097c))
* Address obvious query template bugs like
  * query22a: [#31](https://github.com/gregrahn/tpcds-kit/issues/31)
  * query77a: [#43](https://github.com/gregrahn/tpcds-kit/issues/43)
* Rename `s_web_returns` column `wret_web_site_id` to `wret_web_page_id` to match specification. See [#22](https://github.com/gregrahn/tpcds-kit/issues/22) & [#42](https://github.com/gregrahn/tpcds-kit/issues/42).

To see all modifications, diff the files in the master branch to the version branch. Eg: `master` vs `v2.10.0`.

## Setup

### Linux

Make sure the required development tools are installed:

Ubuntu:
```
sudo apt-get install gcc make flex bison byacc git
```

CentOS/RHEL:
```
sudo yum install gcc make flex bison byacc git
```

Then run the following commands to clone the repo and build the tools:

* 如果是跑mysql的情况下，要把TPC-DS放到对应节点的服务器上，不能远程。因为
  * mysql有写入文件限制，所以只能用root账户来运行
  * 要用到`--defaults-file` 这个参数，可以在服务器上
  * `ps -ef | grep mysql` 或者 `ps -ef | grep mysql-port`来获取对应端口的默认路径
# 运行

* git clone https://gitee.com/liu-liangcheng/Tools.git -b master
* cd TPC-DS
* tpcds_path=`pwd` #把 TPC-DS(当前) 目录路径 赋值给变量 tpcds_path
* cd tools
* make OS=LINUX

## create database db_name 

## creata tpc-ds table

* cd ${tpcds_path}  #使用该变量
* chmod 755 *sh
* mkdir -p ${tpcds_path}/datas
* psql -h host -p port -d db_name -f create_table.sql
* postgresql like : psql -h 192.168.0.113 -p 8881 -d test -f create_table.sql
* mysql like: mysql --defaults-file=/mysql-configure-file-path/ -uroot -proot db_name < create_table.sql
	

## create data dir & generated data
```
        ${tpcds_path}/tools/dsdgen -DIR ${tpcds_path}/datas -SCALE 1 #-SCALE 1 means grnerated 1 GB TPC-DS data
        or
        ${tpcds_path}/tools/dsdgen -DIR ${tpcds_path}/datas -SCALE 1 -parallel 4 -child 1 #-parallel 4 : use 4 threads
```
## copy data 

* cd ${tpcds_path}
* mysql:
  * mysql like : 
    * ./copy.sh mysql /mysql-configure-file-path/ dbname

* postgres
  * ./copy.sh
  * psql -h host -p port -d db_name -f copy.sql
    * postgresql like : psql -h 192.168.0.113 -p 8881 -d test -f copy.sql

## create TPC-DS test statement 
	cd ${tpcds_path}
	./create_query.sh

## run tpc-ds
* cd ${tpcds_path}
* postgresql like : ./run.sh 192.168.0.113 5423 test
* mysql like : ./myrun.sh /mysql-configure-file-path/ dbname
