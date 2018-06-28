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