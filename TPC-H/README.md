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
* 这一步的-s就是要产生多少G的数据
    
###  bash ./modify_splits.sh	
* 这一步是处理下产生的数据文件

###  psql -h host -p port -U db_user_name -d db_name -f ./dss.ddl
* 这里是建立好对应的表
* like
  * postgresql: psql -h localhost -p 8881 -U abc -d tpch -f ./dss.ddl
  * mysql like: mysql --defaults-file=/mysql-configure-file-path/ -uroot -proot db_name < ./dss.ddl
  
###  bash ./copy.sh 进程数
* 就是你要用几个进程来灌数据
* like 
  * postgres : bash ./copy.sh 5
  * mysql : bash ./mycopy.sh /mysql-configure-file-path/
* 这一步完成后会有提示怎么使用load.sh文件灌数据
###  bash ./create_statements.sh
* 这一步就是产生要运行的sql语句

###  运行测试
* postgresql : bash ./run.sh localhost 8881 tpch abc abc
* mysql : bash ./myrun.sh /mysql-configure-file-path/
