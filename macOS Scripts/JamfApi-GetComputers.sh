#!/bin/bash

url=
client_id=
client_secret=
# NEED current_epoch VALUE DEFINED FIRST - So we can compare the expiration times
current_epoch=$(date +%s)

getAccessToken() {
	response=$(curl --silent --location --request POST "${url}/api/oauth/token" \
		--header "Content-Type: application/x-www-form-urlencoded" \
		--data-urlencode "client_id=${client_id}" \
		--data-urlencode "grant_type=client_credentials" \
		--data-urlencode "client_secret=${client_secret}")
	access_token=$(echo "$response" | plutil -extract access_token raw -)
	token_expires_in=$(echo "$response" | plutil -extract expires_in raw -)
	token_expiration_epoch=$(($current_epoch + $token_expires_in - 1))
}

getAccessToken 

apiEndpoint="${url}/JSSResource/computers"

jsonResponse=$(curl -s -X 'GET' "$apiEndpoint" \
		-H "Authorization: Bearer $access_token" \
		-H 'accept: application/json')
#echo $jsonResponse
#Use Python to parse and process the JSON data
python3 - <<EOF
import json

data = '''$jsonResponse'''

try:
		# Load JSON into a Python dictionary
		json_data = json.loads(data)
		# Pretty print JSON data
		print(json.dumps(json_data, indent=4))
		# Add additional processing as needed
except json.JSONDecodeError as e:
		print(f"Error decoding JSON: {e}")
EOF