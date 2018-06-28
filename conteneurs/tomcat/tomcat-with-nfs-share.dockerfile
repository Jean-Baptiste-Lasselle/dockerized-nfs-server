FROM tomcat:8.0
RUN yum update -y
# RUN yum install -y nfs-utils nfs-utils-lib
RUN yum install -y nfs-utils
# ADD ./creer-bdd-application.sql .
# RUN chkconfig nfs on
# RUN chkconfig nfs on
# RUN systemctl start rpcbind
# RUN systemctl start nfs
# - le répertoire dans lequel on veut monter le répertoire servi par le serveur NFS: [/usr/local/tomcat/logs/]
mount localhost:VAL_REPERTOIRE_APP1_DANS_NFS_SERVER /usr/local/tomcat/logs/

HEALTHCHECK --interval=1s --timeout=300s --start-period=1s --retries=300 CMD curl --silent --fail localhost:8080/_cluster/health || exit 1
