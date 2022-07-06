#! /usr/bin/env python3.6

import json
import os
import stripe
import subprocess

stripe.api_key = 'sk_test_'

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

# need an endpoint secret check

	if event and event['type'] == 'checkout.session.completed':
# create check if None is returned instead of a str
# checkout.session.completed provides more info
		a = event['data']['object']
		idf = open('/tmp/id', 'w')
		idf.write(a['customer'])
		idf.close()
#		idf = open(r'/tmp/email', 'w')
#		idf.write(a[''])
#		idf.close()
		subprocess.call('customers.sh')
		os.remove("/tmp/id")
		os.remove("/tmp/email")

	return jsonify(success=True)
