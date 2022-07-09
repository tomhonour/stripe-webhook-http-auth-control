#!/bin/bash

id=$(< /tmp/id)
email=$(curl https://api.stripe.com/v1/customers/$id -u sk_test_: | grep email | cut -d'"' -f4)

echo "$(openssl rand -base64 32 |\
tee >(xargs echo "Subject: Your purchase from filmsbytom.com
Thank you for your purchase. The files for download are available at https://filmsbytom.com/shopfiles/ . Please use the username and password below. This password will expire in 3 days.
username: $id
password:" |\
msmtp $email &) |\
htpasswd -in $id)" >> /var/www/stripe/.customers
var1="sed '/"
var2=$id
var3="/d' /var/www/stripe/.customers"
echo $var1$var2$var3 | at now + 3 days
