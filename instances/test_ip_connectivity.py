import json
from googleapiclient import discovery
from google.oauth2 import service_account

# Set up credentials and API client
credentials = service_account.Credentials.from_service_account_file(
    'path/to/your/service/account/key.json',
    scopes=['https://www.googleapis.com/auth/cloud-platform']
)
api = discovery.build('compute', 'v1', credentials=credentials)

# TEST 1: Test between VM instances in a VPC Network
test_input = {
    "source": {
        "instance": "sdl22-dc-02",
        "ipAddress": "35.231.108.30",
        "projectId": "145833268326172270"
    },
    "protocol": "ICMP",  # Replace with the specific protocol you want to test (e.g., "TCP" or "UDP")
}

# Replace 'your-project-id' with your actual project ID
project_id = "145833268326172270"

# Replace 'your-unique-test-id' with a unique test ID
test_id = "T-02"

# Replace 'your-location' with the appropriate location
location = "global"

# Create the parent path
parent = f"projects/145833268326172270/locations/global"

# Create the request
request = api.projects().locations().global_().connectivityTests().create(
    parent=parent,
    testId=test_id,
    body=test_input
)

# Run the connectivity test and capture the results
response = request.execute()

# Print the formatted results
print("Connectivity Test Results:")
print(json.dumps(response, indent=4))

# Process or display specific details from the response
print("Connectivity Test ID:", response.get("name"))
print("Operation Status:", response.get("operationStatus"))
# Add more details as needed...

# Save the results to a file
with open("connectivity_test_results.json", "w") as result_file:
    json.dump(response, result_file, indent=4)



# TEST 2: Test between private IP addresses in a VPC network

#test_input = {
 # "source": {
  #    "ipAddress": "SOURCE_IP_ADDRESS",
   #   "projectId": "SOURCE_IP_PROJECT_ID"
  #},
  #"destination": {
   #   "ipAddress": "DESTINATION_IP_ADDRESS",
    #  "port": "DESTINATION_PORT",
     # "projectId": "DESTINATION_IP_PROJECT_ID"
  #},
  #"protocol": "PROTOCOL",
#}

#request = api.projects().locations().global_().connectivityTests().create(
   # parent="projects/PROJECT_ID/locations/global",#testId="TEST_ID",
   # body=test_input)

#print(json.dumps(request.execute(), indent=4))


#TEST 3: Test IP addresses in a shared VPC Network

#test_input = {
 # "source": {
  #    "ipAddress": "SOURCE_IP_ADDRESS",
   #   "projectId": "SOURCE_IP_PROJECT_ID"
  #},
  #"destination": {
   #   "ipAddress": "DESTINATION_IP_ADDRESS",
    #  "projectId": "DESTINATION_IP_PROJECT_ID",
     # "network": "DESTINATION_NETWORK",
      #"port": "DESTINATION_PORT",
  #},
  #"protocol": "PROTOCOL",
#}

# request = api.projects().locations().global_().connectivityTests().create(
   # parent="projects/PROJECT_ID/locations/global",
   # testId="TEST_ID",
   # body=test_input)

# print(json.dumps(request.execute(), indent=4))