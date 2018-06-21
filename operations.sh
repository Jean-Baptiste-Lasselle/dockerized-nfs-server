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


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################




# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL
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
	echo "date avant la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	sudo which ntpdate
	sudo yum install -y ntp
	sudo ntpdate 0.us.pool.ntp.org
	echo "date après la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	# pour re-synchroniser l'horloge matérielle, et ainsi conserver l'heure après un reboot, et ce y compris après et pendant
	# une coupure réseau
	sudo hwclock --systohc

}

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------



echo " +++provision+ conteneur + nfs-server +  COMMENCEE  - " >> $NOMFICHIERLOG

# synchroniserSurServeurNTP
# PARTIE INTERACTIVE

# PARTIE SILENCIEUSE

# - BUILD IMAGE NFS-SERVER
export MAISON_MERE=`pwd`
export CONTEXTE_DU_BUILD_DOCKER=$MAISON/application-1/bdd/mariadb
export NOM_IMAGE_DOCKER_SGBDR=bytes.io/nfs-server:1.0.0
cd $CONTEXTE_DU_BUILD_DOCKER
clear
pwd
generer_fichiers
sudo docker build --tag $NOM_IMAGE_DOCKER_SGBDR -f ./nfs-server.dockerfile $CONTEXTE_DU_BUILD_DOCKER
cd $MAISON


echo " +++provision+ conteneur + nfs-server +  TERMINEE  - " >> $NOMFICHIERLOG