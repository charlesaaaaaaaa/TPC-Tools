# 环境设置
### cd TPC-H_Tools_v3.0.0/dbgen/

* mv makefile.suite makefile
* vi makefile
  *	change makefile on line 103 to 111, like：
```
103 CC      = gcc
104 # Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
105 #                                  SQLSERVER, SYBASE, ORACLE, VECTORWISE
106 # Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS, 
107 #                                  SGI, SUN, U2200, VMS, LINUX, WIN32 
108 # Current values for WORKLOAD are:  TPCH
109 DATABASE=ORACLE 
110 MACHINE = LINUX
111 WORKLOAD = TPCH
```
  * 如果是mysql的话，就改 DATABASE=SQLSERVER

###  make

* 如果是跑mysql的情况下，要把TPC-DS放到对应节点的服务器上，不能远程。因为
  * mysql有写入文件限制，所以只能用root账户来运行
  * 要用到`--defaults-file` 这个参数，可以在服务器上
  * `ps -ef | grep mysql` 或者 `ps -ef | grep mysql-port`来获取对应端口的默认路径
 
## 以下用/mysql-configure-file-path/来代替端口默认配置文件的路径

# 运行
### ./dbgen -vf -s 1
* -s 1 : Generate 1GB of data
    
###  bash ./modify_splits.sh	

###  psql -h host -p port -U db_user_name -d db_name -f ./dss.ddl
* like
  * postgresql: psql -h localhost -p 8881 -U abc -d tpch -f ./dss.ddl
  * mysql like: mysql --defaults-file=/mysql-configure-file-path/ -uroot -proot db_name < ./dss.ddl
  
###  bash ./copy.sh host port db_name db_user_name
* like 
  * postgres : bash ./copy.sh localhost  8881 tpch abc
  * mysql : bash ./mycopy.sh /mysql-configure-file-path/
###  bash ./create_statements.sh

###  运行测试
* postgresql : bash ./run.sh localhost 8881 tpch abc abc
* mysql : bash ./myrun.sh /mysql-configure-file-path/
