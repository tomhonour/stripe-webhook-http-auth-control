# stripe-webhook-http-auth-ctrl

## the logic
1. a customer performs and action
2. stripe sends a POST request with a json body
3. `webhook.py` handles the request, calls `customers.sh`, and then returns 200.
4. `customers.sh` creates a username and password for the customer, places that information into http auth, and then e-mails that information to the customer. it also removes that customer from http auth after 3 days.

## dependencies
- web server (nginx is used here)
- apache2-utils
- at
- curl
- msmtp
- python3-pip (plus pip modules: waitress and those in requirements.txt)
note: requirements.txt is supplied by stripe [here](https://stripe.com/docs/webhooks/quickstart).

### for local testing
- stripe-cli

## installation (steps on web server)
push `customers.sh`, `requirements.txt`, and `webhook.py` to your web server. steps to set up an msmtp config are not provided here although a basic rc file is provided. check out [msmtp on the arch wiki](https://wiki.archlinux.org/title/Msmtp) for help. then:
```
apt install nginx apache2-utils at msmtp python3-pip
python3 -m pip install --upgrade pip
pip3 install waitress
pip3 install -r requirements.txt
```
edit `/etc/nginx/sites-enabled/`x to include the following in your server block:
```
location /webhook {
		proxy_pass http://localhost:8000 ;
#		limit_except POST {
#			deny all ;
#		}
```
### deploy
since webhook.py is a flask 'app', wsgi should be used (probably by starting webhook.py with systemd). however for now, I have just executed the following command in tmux in the background. it's lazy but it works!
```
python3 webhook.py
```

## local development and testing
for local development and testing, nginx is not required.
```
curl https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | apt-key add -
echo "deb https://packages.stripe.dev/stripe-cli-debian-local stable main" | tee -a /etc/apt/sources.list
apt update
apt install stripe
```
put 'sk_test_...' into server.py

### for running
```
export FLASK_APP=server.py
python3 -m flask run --port=4242
stripe listen --forward-to localhost:4242/webhook
```
### trigger a dummy event e.g.:
`stripe trigger payment_intent.succeeded`
