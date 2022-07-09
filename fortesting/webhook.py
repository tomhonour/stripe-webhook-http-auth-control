#! /usr/bin/env python3.6

import json
import os
import stripe
import subprocess

stripe.api_key = 'sk_test_'

endpoint_secret = 'whsec_'
from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
	event = None
	payload = request.data

	try:
		event = json.loads(payload)
	except:
		return jsonify(success=False)
	if endpoint_secret:
		sig_header = request.headers.get('stripe-signature')
		try:
			event = stripe.Webhook.construct_event(
				payload, sig_header, endpoint_secret
			)
		except stripe.error.SignatureVerificationError as e:
			return jsonify(success=False)

	if event and event['type'] == 'checkout.session.completed':
		a = event['data']['object']
		idf = open('/tmp/id', 'w')
		idf.write(a['customer'])
		idf.close()
		subprocess.call('/home/user/Documents/GitHub/stripe-webhook-http-auth-control/fortesting/customers.sh')
		os.remove("/tmp/id")

	return jsonify(success=True)

if __name__ == "__main__":
	from waitress import serve
	serve(app, host="0.0.0.0", port=8000)
