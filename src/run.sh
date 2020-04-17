#!/bin/bash

#set -x


# Configure config

#if [ "$1" = "run" ]; then

# Configure cofig
sed -i -E "s/auth_method:.*/auth_method: "$MT_AUTH"/" /app/config.conf
sed -i -E "s/Login:.*/Login: "$MT_LOGIN"/" /app/config.conf
sed -i -E "s/Password:.*/Password: "$MT_PASSWORD"/" /app/config.conf
sed -i -E "s/backup_passwd.*/backup_passwd: "$MT_BACKUP_PASSWORD"/" /app/config.conf
sed -i -E "s/threads:.*/threads: "$THREADS"/" /app/config.conf

sed -i -E "s/smtp_server:.*/smtp_server: "$SMTP_SERVER"/" /app/config.conf
sed -i -E "s/smtp_login:.*/smtp_login: "$SMTP_LOGIN"/" /app/config.conf
sed -i -E "s/smtp_passwd:.*/smtp_passwd: "$SMTP_PASS"/" /app/config.conf
sed -i -E "s/smtp_from:.*/smtp_from: "$SMTP_FROM"/" /app/config.conf
sed -i -E "s/smtp_to:.*/smtp_to: "$SMTP_TO"/" /app/config.conf
#fi


echo "execute command on Mikrotik"

AUTH_METOD=`cat /app/config.conf | grep "auth_method:" | awk '{print $2}' | sed 's/"//g'`
if [ "auth" = "$AUTH_METOD" ]
then
echo "AUTH"
echo "
/user add name=$MT_LOGIN group=full password=$MT_PASSWORD
" > /app/backup/add_backup_user.rsc

else 
echo "KEY"

echo "
/user add name=$MT_LOGIN group=full password=$MT_PASSWORD
/file print file=rsa_pub
:delay 2
/file set rsa_pub.txt contents="$SSH_PUBLIC_KEY"
:delay 2
/user ssh-keys import user=backup public-key-file=rsa_pub.txt
"  > /app/backup/add_backup_user.rsc

fi

#RUN backup script 
python /app/backup.py
