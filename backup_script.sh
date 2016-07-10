#!/bin/bash

#fonction analise le retour des commandes $1 si <> de 0 mail avec message $2 et sujet erreur $3
gestion_retour() {
        if [ $1 -ne 0 ]; then
            /home/michelgard/backupHubic/mailBackup.php "\"$2\"" $3
			exit 1
        fi
}

# On liste nos bases de données
LISTEBDD=$( echo 'show databases' |mysql --defaults-extra-file=/etc/mysql/user.sql)
gestion_retour $? 'Erreur lecture noms des bases' 1

for BDD in $LISTEBDD
do
	# Exclusion des BDD information_schema , mysql et Database
	if [ $BDD != "information_schema" ] && [ $BDD != "mysql" ] && [ $BDD != "performance_schema" ] && [ $BDD != "phpmyadmin" ] && [ $BDD != "Database" ]
	then
		# Emplacement du dossier ou nous allons stocker les bases de données, un dossier par base de données
		CHEMIN=/home/final/base_DB/$BDD
		# Si le repertoire de la BDD dans $CHEMIN n'existe pas, on le cree
		if [ ! -d "$CHEMIN" ];then
			mkdir -p $CHEMIN/
		fi
		# On backup notre base de donnees
		mysqldump --defaults-extra-file=/etc/mysql/user.sql --single-transaction --add-drop-database --databases $BDD > "$CHEMIN/$BDD.sql"
		gestion_retour $? 'Erreur sur sauvegarde base' 1
		echo "|Sauvegarde de la base de donnees $BDD.sql ";
	fi
done

#Sauvegarde sur Cloud Hubic avec rclone
#site www
rclone copy /var/www/ Hubic:default/CloudVPS/www/ 
gestion_retour $? 'Erreur sur sauvegarde dossier www' 1

#repertoire ect
rclone copy /etc/ Hubic:default/CloudVPS/etc/ 
gestion_retour $? 'Erreur sur sauvegarde dossier etc' 1

#répertoire my sql
rclone copy /var/lib/mysql/ Hubic:default/CloudVPS/mysql/ 
gestion_retour $? 'Erreur sur sauvegarde dossier /var/lib/mysql' 1

#répertoire michelgard
rclone copy /home/michelgard/ Hubic:default/CloudVPS/home/michelgard 
gestion_retour $? 'Erreur sur sauvegarde dossier michelgard' 1

#répertoire final
rclone copy /home/final/ Hubic:default/CloudVPS/home/final
gestion_retour $? 'Erreur sur sauvegarde dossier final' 1

#les bases sauvées plus haut
rclone copy /home/final/base_DB/ Hubic:default/CloudVPS/base_DB/ 
gestion_retour $? 'Erreur sur sauvegarde des bases' 1

/home/michelgard/backupHubic/mailBackup.php "\"Sauvegarde sur Hubic avec succes !\"" 0
