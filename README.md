# stripe-webhook-http-auth-ctrl

## dependencies
- apache2-utils
- at
- fcgiwrap
- git
- [msmtp](https://marlam.de/msmtp/download/) (requires autoconf automake libtool gettext texinfo libgnutls28-dev)
- nginx
- python3-pip
- stripe (pip)
- (for local testing) stripe (stripe-cli)

## Installation and local development
```
apt install apache2-utils at fcgiwrap autoconf automake libtool gettext texinfo libgnutls28-dev nginx python3-pip

python3 -m pip install --upgrade pip
python3 -m pip install stripe

git clone [https://git.marlam.de/git/msmtp.git](https://git.marlam.de/git/msmtp.git)
cd msmtp
autoreconf -i
./configure; make; make install

mv dotmsmtp ~/.msmtp
mv server.py /usr/local/bin/server.py
[write instructions for etc-nginx-sites-enabled-filmsbytom]

# for local testing. nginx is not required for local testing.
curl [https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public](https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public) | apt-key add -
echo "deb https://packages.stripe.dev/stripe-cli-debian-local stable main" | tee -a /etc/apt/sources.list
apt update
apt install stripe
cd stripe-sample-code
pip3 install -r requirements.txt
put 'sk_test_...' into server.py

# for running
export FLASK_APP=server.py
python3 -m flask run --port=4242
stripe listen --forward-to localhost:4242/webhook
# trigger a dummy event e.g.:
stripe trigger payment_intent.succeeded
```
