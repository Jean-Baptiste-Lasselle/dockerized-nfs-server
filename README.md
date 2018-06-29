# Abstract

Recette de provision d'un d'un conteneur opérant un serveur nfs-server

# Utilisation

Exécutez:

```
mkdir provision-nfs-server
cd provision-nfs-server
git clone "https://github.com/Jean-Baptiste-Lasselle/dockerized-nfs-server" .
sudo chmod +x ./operations.sh
./operations.sh
```

Ou en une seule ligne:

```
mkdir provision-nfs-server && cd provision-nfs-server && git clone "https://github.com/Jean-Baptiste-Lasselle/dockerized-nfs-server" . && sudo chmod +x ./operations.sh && ./operations.sh
```

# ANNEXE: références

* https://www.howtoforge.com/tutorial/setting-up-an-nfs-server-and-client-on-centos-7/


# ANNEXE: diverses notes

```
exportfs: No host name given with VAL_REPERTOIRE_APP1_DANS_NFS_SERVER (rw,sync,no_subtree_check), suggest *(rw,sync,no_subtree_check)
```


Notons: cidessous, la preuve que lorsque j'utilise l'optio `-v` de la commande `docker run` , les fichiers partagés entre hôte docker, et 
conteneur, persistent:
* après un arrêt, par `docker stop $NOM_CONTNR` du conteneur.
* après une destruction complète, par `docker rm $NOM_CONTNR`, du conteneur.

```
[jibl@pc-65 ~]$ docker exec -it jibl-test-tomy /bin/bash
root@631182b63f9f:/usr/local/tomcat# vi ./logs/fichier-crree-ds-conteneur.jbl
lash: vi: command not found                                                                                          #echo  ./logs/fichier-crree-ds-conteneur.jbl
root@631182b63f9f:/usr/local/tomcat# echo  ./logs/fichier-crree-ds-conteneur.jbl
er-crree-ds-conteneur.jblcal/tomcat# echo "voilà, monsieur jbl " >> ./logs/fichie
root@631182b63f9f:/usr/local/tomcat# cat ./logs/fichier-crree-ds-conteneur.jbl
voilà, monsieur jbl
root@631182b63f9f:/usr/local/tomcat# ls ./logs/
catalina.2018-06-17.log            localhost.2018-06-17.log
fichier-ajouter-de-lexterieur.jbl  localhost_access_log.2018-06-17.txt
fichier-crree-ds-conteneur.jbl     manager.2018-06-17.log
host-manager.2018-06-17.log
root@631182b63f9f:/usr/local/tomcat# ls -all ./logs/
total 28
drwxrwxr-x.  2 1000  1000 4096 Jun 17 23:32 .
drwxr-sr-x. 11 root staff 4096 Jun 27  2018 ..
-rw-r-----.  1 root root  7052 Jun 17 23:29 catalina.2018-06-17.log
-rw-rw-r--.  1 1000  1000   15 Jun 17 23:30 fichier-ajouter-de-lexterieur.jbl
-rw-r--r--.  1 root root    22 Jun 17 23:32 fichier-crree-ds-conteneur.jbl
-rw-r-----.  1 root root     0 Jun 17 23:29 host-manager.2018-06-17.log
-rw-r-----.  1 root root   459 Jun 17 23:29 localhost.2018-06-17.log
-rw-r-----.  1 root root     0 Jun 17 23:29 localhost_access_log.2018-06-17.txt
-rw-r-----.  1 root root     0 Jun 17 23:29 manager.2018-06-17.log
root@631182b63f9f:/usr/local/tomcat# exit
exit
[jibl@pc-65 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                       PORTS                                                                                            NAMES
631182b63f9f        tomcat              "catalina.sh run"        3 minutes ago       Up 3 minutes                 0.0.0.0:8084->8080/tcp                                                                           jibl-test-tomy
c8e073bcd197        bytes-io/sgbdr:v3   "docker-entrypoint.s…"   About an hour ago   Up About an hour (healthy)   0.0.0.0:8475->3306/tcp                                                                           ciblededeploiement-composant-sgbdr
c35970bc02f2        tomcat:8.0          "catalina.sh run"        About an hour ago   Up About an hour             0.0.0.0:7852->8080/tcp                                                                           ciblededeploiement-composant-srv-jee
7f584da0c089        sebp/elk            "/usr/local/bin/star…"   About an hour ago   Up About an hour             0.0.0.0:5044->5044/tcp, 0.0.0.0:5601->5601/tcp, 0.0.0.0:9200->9200/tcp, 0.0.0.0:9300->9300/tcp   conteneur-elk-jibl
[jibl@pc-65 ~]$ docker stop jibl-test-tomy
jibl-test-tomy
[jibl@pc-65 ~]$ ls -all ./logs-de-tomy/
total 28
drwxrwxr-x. 2 jibl jibl 4096 18 juin  01:32 .
drwx------. 6 jibl jibl 4096 18 juin  01:26 ..
-rw-r-----. 1 root root 7798 18 juin  01:33 catalina.2018-06-17.log
-rw-rw-r--. 1 jibl jibl   15 18 juin  01:30 fichier-ajouter-de-lexterieur.jbl
-rw-r--r--. 1 root root   22 18 juin  01:32 fichier-crree-ds-conteneur.jbl
-rw-r-----. 1 root root    0 18 juin  01:29 host-manager.2018-06-17.log
-rw-r-----. 1 root root  735 18 juin  01:33 localhost.2018-06-17.log
-rw-r-----. 1 root root    0 18 juin  01:29 localhost_access_log.2018-06-17.txt
-rw-r-----. 1 root root    0 18 juin  01:29 manager.2018-06-17.log
[jibl@pc-65 ~]$
[jibl@pc-65 ~]$ docker rm jibl-test-tomy
jibl-test-tomy
[jibl@pc-65 ~]$ ls -all ./logs-de-tomy/
total 28
drwxrwxr-x. 2 jibl jibl 4096 18 juin  01:32 .
drwx------. 6 jibl jibl 4096 18 juin  01:26 ..
-rw-r-----. 1 root root 7798 18 juin  01:33 catalina.2018-06-17.log
-rw-rw-r--. 1 jibl jibl   15 18 juin  01:30 fichier-ajouter-de-lexterieur.jbl
-rw-r--r--. 1 root root   22 18 juin  01:32 fichier-crree-ds-conteneur.jbl
-rw-r-----. 1 root root    0 18 juin  01:29 host-manager.2018-06-17.log
-rw-r-----. 1 root root  735 18 juin  01:33 localhost.2018-06-17.log
-rw-r-----. 1 root root    0 18 juin  01:29 localhost_access_log.2018-06-17.txt
-rw-r-----. 1 root root    0 18 juin  01:29 manager.2018-06-17.log
[jibl@pc-65 ~]$

```

ANNEXE ?
Donc l'idée est:

Je créée  un volume pour chaque Pod Kubernetes, et le partage entre tous les conteneurs du même pod. Donc j'ai un volume par Pod du cluster.
Je déploie un microservice basé sur un conteneur serveur NFS. Je monte, sur le disuqe dur d'une VM, le répertoire du serveur NFS contenant les fichiers de logs de toutes mes applications,  un sous répertoire par application. Cette VM est de plus un hôte Docker, et je peux créer autant de conteneurs filebeat que d'application, et chaque conteneur filebeat a un volume partagé avec l'hôte Docker. Le répertoire des fichiers de logs de chaque applciation, amené par NFS sur le disque dur de la VM, est contneu dans le répertoire partagé avec le contneur filebeat. le volume est monté en read only, parce que le filebeat n'a pas vocation à modifier de ficheir. 

LA même chose peut être faite avec un conteneuir NFS serveur au lieu d'un microservice NFS, et un volume docker, partagé entre le conteneur de chaque application (émettrice de logs) , et le contneur du serveur NFS.
Le serveur NFS permet de transporter les fichiers de logs vers des conteneurs Docker dans le même hôte Docker (en fait dans ce cas, on aura simplement recours au partage de volume docker entre 2 conteneurs sur le même hôte Docker) , ou dans un conteneur différent, toujours en montant le partage NFS sur le disque de l'h^te DOcker, et en partageant un volume docker entre un conteneur filebeat, et l'hôte docker.