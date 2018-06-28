#!/bin/bash
# Hôte Docker sur centos 7
############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-OK]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# 
# 
# ...
# ----------------------------------------------------------




# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
MAISON_OPERATIONS=$(pwd)

# -
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-nfs-server-dock.log"


######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -

export REPERTOIRES_APP_DANS_HOTE_DOCKER=$(pwd)/repertoires/de/logging
export REPERTOIRE_APP1_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1
export REPERTOIRES_LOGS_APPS_DANS_NFS_SERVER=/repertoires/de/logging
export REPERTOIRE_APP1_DANS_NFS_SERVER=$REPERTOIRES_LOGS_APPS_DANS_NFS_SERVER/application-1
export REPERTOIRE_APP2_DANS_NFS_SERVER=$REPERTOIRES_LOGS_APPS_DANS_NFS_SERVER/application-2

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################




# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL
configurerServeurNTP () {
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ------	SYNCHRONSITATION SUR UN SERVEUR NTP PUBLIC (Y-en-a-til des gratuits dont je puisse vérifier le certificat SSL TLSv1.2 ?)
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---	Pour commencer, pour ne PAS FAIRE PETER TOUS LES CERTIFICATS SSL vérifiés pour les installation yum
	# ---	
	# ---	Sera aussi utilise pour a provision de tous les noeuds d'infrastructure assurant des fonctions d'authentification:
	# ---		Le serveur Free IPA Server
	# ---		Le serveur OAuth2/SAML utilisé par/avec Free IPA Server, pour gérer l'authentification 
	# ---		Le serveur Let's Encrypt et l'ensemble de l'infrastructure à clé publique gérée par Free IPA Server
	# ---		Toutes les macines gérées par Free-IPA Server, donc les hôtes réseau exécutant des conteneurs Girofle
	# 
	# 
	# >>>>>>>>>>> Mais en fait la synchronisation NTP doit se faire sur un référentiel commun à la PKI à laquelle on choisit
	# 			  de faire confiance pour l'ensemble de la provision. Si c'est une PKI entièrement interne, alors le système 
	# 			  comprend un repository linux privé contenant tous les packes à installer, dont docker-ce.
	# 
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	echo "date avant la re-synchronisation [Serveur NTP=$SERVEUR_NTP : $(date)]" >> $NOMFICHIERLOG
	sudo which ntpdate
	sudo yum install -y ntp
	sudo ntpdate 0.us.pool.ntp.org
	echo "date après la re-synchronisation [Serveur NTP=$SERVEUR_NTP : $(date)]" >> $NOMFICHIERLOG
	# pour re-synchroniser l'horloge matérielle, et ainsi conserver l'heure après un reboot, et ce y compris après et pendant
	# une coupure réseau
	sudo hwclock --systohc

}
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon
# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL foirent
synchroniserSurServeurNTP () {
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ------	SYNCHRONSITATION SUR UN SERVEUR NTP PUBLIC (Y-en-a-til des gratuits dont je puisse vérifier le certificat SSL TLSv1.2 ?)
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---	Pour commencer, pour ne PAS FAIRE PETER TOUS LES CERTIFICATS SSL vérifiés pour les installation yum
	# ---	
	# ---	Sera aussi utilise pour a provision de tous les noeuds d'infrastructure assurant des fonctions d'authentification:
	# ---		Le serveur Free IPA Server
	# ---		Le serveur OAuth2/SAML utilisé par/avec Free IPA Server, pour gérer l'authentification 
	# ---		Le serveur Let's Encrypt et l'ensemble de l'infrastructure à clé publique gérée par Free IPA Server
	# ---		Toutes les macines gérées par Free-IPA Server, donc les hôtes réseau exécutant des conteneurs Girofle
	# 
	# 
	# >>>>>>>>>>> Mais en fait la synchronisation NTP doit se faire sur un référentiel commun à la PKI à laquelle on choisit
	# 			  de faire confiance pour l'ensemble de la provision. Si c'est une PKI entièrement interne, alors le système 
	# 			  comprend un repository linux privé contenant tous les packes à installer, dont docker-ce.
	# 
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	echo "date avant la re-synchronisation [Serveur NTP=$SERVEUR_NTP : $(date)]" >> $NOMFICHIERLOG
	 >> $NOMFICHIERLOG
	# pour re-synchroniser l'horloge matérielle, et ainsi conserver l'heure après un reboot, et ce y compris après et pendant
	# une coupure réseau
	sudo hwclock --systohc
	echo "date après la re-synchronisation [Serveur NTP=$SERVEUR_NTP : $(date)]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	

}

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------



echo " +++provision+ conteneur + nfs-server +  COMMENCEE  - "

# configurerServeurNTP
synchroniserSurServeurNTP

mkdir -p $REPERTOIRE_APP1_DANS_HOTE_DOCKER

# --------------------------------------- #
# --------------------------------------- #
# -------   CONTENEUR NFS-SERVER   ------ #
# --------------------------------------- #
# --------------------------------------- #

# - BUILD IMAGE NFS-SERVER
export MAISON_MERE=`pwd`
export CONTEXTE_DU_BUILD_DOCKER=$MAISON_OPERATIONS/conteneurs/nfs-server/
# export CONTEXTE_DU_BUILD_DOCKER=$MAISON_OPERATIONS/conteneurs/tomcat/
# export CONTEXTE_DU_BUILD_DOCKER=$MAISON_OPERATIONS/conteneurs/tomcat/tomcat-with-nfs-share.dockerfile
export NOM_IMAGE_DOCKER_NFS_SERVER=bytes.io/nfs-server:1.0.0
cd $CONTEXTE_DU_BUILD_DOCKER
clear
pwd

sudo docker build --tag $NOM_IMAGE_DOCKER_NFS_SERVER -f ./nfs-server.dockerfile $CONTEXTE_DU_BUILD_DOCKER
cd $MAISON_OPERATIONS

# - RUN CONTENEUR NFS-SERVER
# Construction des répertoires pour le logging de chaque application dans l'hôtes docker
# - 
# Utilisation
# -

# export REPERTOIRES_APP_DANS_HOTE_DOCKER=$(pwd)/repertoires/de/logging
# export REPERTOIRE_APP1_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1

# - 
# - Pour chaque application, on substitue, dans le dockerfile, la valeur du chemin des répertoires contenant les fichiers de logs  
# - 
sed -i "s/VAL_REPERTOIRE_APP1_DANS_HOTE_DOCKER/$REPERTOIRE_APP1_DANS_NFS_SERVER/g" $MAISON_OPERATIONS/conteneurs/tomcat/nfs-server.dockerfile
# 
# sudo docker run --publish-all=true -v $REPERTOIRE_APP1_DANS_HOTE_DOCKER:/repertoires/de/logging/application-1 -v $REPERTOIRE_APP2_DANS_HOTE_DOCKER:/repertoires/de/logging/application-2   ....
# sudo docker run --name conteneur-jbl-nfs-server ---restart=always --publish-all=true -v $REPERTOIRE_APP1_DANS_HOTE_DOCKER:$REPERTOIRE_APP1_DANS_NFS_SERVER  -d $NOM_IMAGE_DOCKER_NFS_SERVER
sudo docker run --name conteneur-jbl-nfs-server ---restart=always --publish-all=true -d $NOM_IMAGE_DOCKER_NFS_SERVER
# -



# --------------------------------------- #
# --------------------------------------- #
# ------- CONTENEUR TOMCAT LOGUEUR ------ #
# --------------------------------------- #
# --------------------------------------- #

# - BUILD IMAGE NFS-SERVER
export CONTEXTE_DU_BUILD_DOCKER=$MAISON_OPERATIONS/conteneurs/tomcat/
# export CONTEXTE_DU_BUILD_DOCKER=$MAISON_OPERATIONS/conteneurs/tomcat/tomcat-with-nfs-share.dockerfile
export NOM_IMAGE_DOCKER_TOMCAT_LOGS=bytes.io/tomcat-logueur:1.0.0
cd $CONTEXTE_DU_BUILD_DOCKER
clear
pwd

sudo docker build --tag $NOM_IMAGE_DOCKER_TOMCAT_LOGS -f ./tomcat-with-nfs-share.dockerfile $CONTEXTE_DU_BUILD_DOCKER
cd $MAISON_OPERATIONS

# - RUN CONTENEUR NFS-SERVER
# Construction des répertoires pour le logging de chaque application dans l'hôtes docker
# - 
# Utilisation
# - 

# export REPERTOIRES_APP_DANS_HOTE_DOCKER=$(pwd)/repertoires/de/logging
# export REPERTOIRE_APP1_DANS_HOTE_DOCKER=$REPERTOIRES_APP_DANS_HOTE_DOCKER/application-1

# - 
# - Pour chaque application, on substitue, dans le dockerfile, la valeur du chemin des répertoires contenant les fichiers de logs  
# - 
sed -i "s/VAL_REPERTOIRE_APP1_DANS_NFS_SERVER/$REPERTOIRE_APP1_DANS_NFS_SERVER/g" $MAISON_OPERATIONS/conteneurs/tomcat/tomcat-with-nfs-share.dockerfile
# 
sudo docker run --name conteneur-tomcat-nfs-logs ---restart=always --publish-all=true -v $REPERTOIRE_APP1_DANS_HOTE_DOCKER:/usr/local/tomcat/logs  -d $NOM_IMAGE_DOCKER_TOMCAT_LOGS
# -





# - Construire un conteneur tomcat dans lequel on va faire un partage NFS

echo " +++provision+ conteneur + nfs-server +  TERMINEE  - "