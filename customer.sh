#!/bin/bash

if [[ $(atq) ]]; then # if any stdout exists for the command atq then do the following. need to add condition that .myusers isn't too long
customerno=$(openssl rand -base64 8) # create an 8 character customer number
# create a 32 character password. branch one ( tee >() ) sends the password to the customer via e-mail. branch two pipes the password into htpasswd which prints 'customer_$customerno:<hashed password>' to stdout. this is appended to .myusers. the ampersand at the end of msmtp is v. important!
echo "$(openssl rand -base64 32 |\
tee >(xargs echo "
Thank you for your purchase. The files for download are available at https://filmsbytom.com/shopfiles/ . Please use the username and password below. This password will expire in 3 days.
username: customer
password:" |\
msmtp [STRIPE CUSTOMER E-MAIL] &) |\
htpasswd -in customer_$customerno)" >> /etc/nginx/.myusers
echo 'sed "/$customerno/d" /etc/nginx/.myusers' | at now + 3 days &>/dev/null # in 3 days delete the line in .myusers associated with that customer

else

# this achieves a similar result, except that htpasswd is in branch one
openssl rand -base64 32 |\
tee >(htpasswd -ci /etc/nginx/.myusers customer &>/dev/null) |\
xargs echo "
Thank you for your purchase. The files for download are available at https://filmsbytom.com/shopfiles/ . Please use the username and password below. This password will expire in 3 days.
username: customer
password:" |\
#msmtp [STRIPE CUSTOMER E-MAIL]
echo "sed '/customer:/d' /etc/nginx/.myusers" | at now + 3 days &>/dev/null

fi
