# backup_rclone_Hubic
Sauvegarde serveur sur cloud Hubic

Après un bug de mon serveur et la récupération de certaines données sauvegardées en FTP j’ai voulu sécuriser entre plus mes sauvegardes
en doublant le système et sans passer par une compression des fichiers.

Pour cela j’ai utilisé RCLONE http://rclone.org/ avec un fichier bash cela me permet de sauvegarder mes dossiers et mes bases de
données.

Pour l’installation : Télécharger ici : http://rclone.org/downloads/ la version qui convient à votre installation. Un wget avec le
lien marche très bien.

Ensuite il faut faire l’installation :
unzip rclone-v1.17-linux-amd64.zip
cd rclone-v1.17-linux-amd64

sudo cp rclone /usr/sbin/
sudo chown root:root /usr/sbin/rclone
sudo chmod 755 /usr/sbin/rclone

sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb

Une fois installer il faut faire la configuration je vous invite à regarder la page officiel de Rclone suivant votre cloud.
Mois j’ai fait l’installation pour Hubic : http://rclone.org/docs/

Une fois la config terminée il suffit de faire par exemple pour sauvegarder les sites  :
rclone copy /var/www/ Hubic:default/CloudVPS/www/

Hubic est le nom donné a mon remote lors de la config de Rclone et ensuite le chemin dans mon cloud Hubic.
Pour voir le dossier dans Hubic sur le site web il faut ajouter default. Sinon le fichier n’est pas visible.

Pour automatiser tout cela j’ai fait un fichier bash qui dans un 1er temps sauvegarde mes bases et ensuite fait les différents
rclone pour les dossiers à sauvegarder. Si une erreur est détecter le fichier stop et un mail d’erreur est envoyé avec un fichier PHP
et si tout va bien un mail est envoyé avec OK.

Une tache cron toutes les nuit pour lancer le programme. La sauvegarde est incrémentale et sans compression.

