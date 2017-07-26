#!/bin/bash

#Variable
CONF_DIRECTORY='conf'   #emplacement fichier conf
LOGS_DIRECTORY='logs'   #emplacement fichier logs
PATH_WPSCAN='wpscan'    #emplacement de wpscan
FILETEMP=`date +%s`.tmp #nom du fichier temp
#MAJ de WPSCAN
$PATH_WPSCAN --update
#Recupération des urls à scanner et création d'un fichier temp
ls $CONF_DIRECTORY > $FILETEMP
#lecture du fichier temp
while read URL
do
#création du fichier de resultat de wpscan
NAMEFILE=$LOGS_DIRECTORY'/wpscan-'$URL'_'`date +%Y-%m-%d-%H:%M:%S`'.txt'
#Remplissage du fichier
$PATH_WPSCAN -u $URL --random-agent --follow-redirection --no-color >> $NAMEFILE

        #lecture des adresse mail stocké dans les fichier url
        while read MAILCONTACT
        do
                if echo $MAILCONTACT | grep '@'
                then
                #envoi des email avec les resultats dans le corp et en pieces jointe
                cat $NAMEFILE | mail -A $NAMEFILE -s 'Scan WPS de '$URL' du '`date +%d-%m-%Y` $MAILCONTACT -a From:adresse@denvoie.fr
                fi
        done < $CONF_DIRECTORY/$URL
done < $FILETEMP
#Supréssion du fichier temp
rm $FILETEMP

exit 0
