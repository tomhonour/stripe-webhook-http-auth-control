#!/bin/bash

id=$(< /tmp/id)
email=$(< /tmp/email)

echo "$(openssl rand -base64 32 |\
tee >(xargs echo "
Thank you for your purchase. The files for download are available at https://filmsbytom.com/shopfiles/ . Please use the username and password below. This password will expire in 3 days.
username: $id
password:" > msmtp.txt &) |\
#msmtp $email &) |\
#/etc/nginx/.customers
htpasswd -in $id)" >> dotcustomers
var1="sed '/"
var2=$id
#/etc/nginx/.customers
var3="/d' dotcustomers"
echo $var1$var2$var3 | at now + 3 days
