FROM centos:centos7
RUN yum update -y && yum install -y nfs-utils nfs-utils-lib
# RUN yum update -y && yum install -y nfs-utils

# 
# - 
# Utilisation
# -
#   export REPERTOIRES_APP_DANS_HOTE_DOCKER=$(pwd)/repertoires/de/logging/:/repertoires/de/logging/application-1
#   export REPERTOIRE_APP1_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1:/repertoires/de/logging/application-1  
#   export REPERTOIRE_APP2_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1:/repertoires/de/logging/application-2  
#   export REPERTOIRE_APP3_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1:/repertoires/de/logging/application-3  
#   sudo docker run --publish-all=true -v $REPERTOIRE_APP1_DANS_HOTE_DOCKER:/repertoires/de/logging/application-1 -v $REPERTOIRE_APP2_DANS_HOTE_DOCKER:/repertoires/de/logging/application-2   ....
# -


# + Les répertoires de logging de chaque application : ceux donc, qui vont être servis.
RUN mkdir -p /repertoires/de/logging/application-1
RUN mkdir -p /repertoires/de/logging/application-2
RUN mkdir -p /repertoires/de/logging/application-3
# on configure les droits voulus par le serveurs NFS, sur ces 3 répertoires
RUN chown nfsnobody:nfsnobody /repertoires/de/logging/application-*
RUN chmod 755 /repertoires/de/logging/application-*

# + On fait la configuration /etc/exports
RUN echo "/repertoires/de/logging/application-1 locahost (rw,sync,no_subtree_check)" >> /etc/exports
RUN echo "/repertoires/de/logging/application-2 locahost (rw,sync,no_subtree_check)" >> /etc/exports
RUN echo "/repertoires/de/logging/application-3 locahost (rw,sync,no_subtree_check)" >> /etc/exports
# + On applique l'export
RUN exportfs -a

# + No. de port à ouvrir:
# - 
# UDP: 111, 1039, 1047, 1048 and 2049.
# TCP: 111, 1039, 1047, 1048 and 2049
# -
#   sudo docker run -p 6048:1048/udp      ....
#   sudo docker run --publish-all=true    ....
# -
EXPOSE 111/tcp
EXPOSE 1039/tcp
EXPOSE 1047/tcp
EXPOSE 1048/tcp
EXPOSE 2049/tcp

EXPOSE 111/udp
EXPOSE 1039/udp
EXPOSE 1047/udp
EXPOSE 1048/udp
EXPOSE 2049/udp


COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]