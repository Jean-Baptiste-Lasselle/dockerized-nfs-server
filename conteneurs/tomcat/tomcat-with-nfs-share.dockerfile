FROM tomcat:8.0
RUN yum update -y
RUN yum install -y nfs-utils nfs-utils-lib
# ADD ./creer-bdd-application.sql .
RUN chkconfig nfs on
RUN chkconfig nfs on
RUN systemctl start rpcbind
RUN systemctl start nfs

# To be continued... : il manqu : entrypoint etc...
