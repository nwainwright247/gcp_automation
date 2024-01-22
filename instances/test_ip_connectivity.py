import json

# TEST 1: Test between VM instances in a VPC Network

test_input = {
    "source": {
        "instance": "sdl22-dc-02",
        "ipAddress": "35.231.108.30",
        "projectId": "145833268326172270"
    },
    "protocol": "PROTOCOL",  # Replace with the specific protocol you want to test (e.g., "TCP" or "UDP")
}

request = api.projects().locations().global_().connectivityTests().create(
    parent="projects/PROJECT_ID/locations/global",
    testId="TEST_ID",  # Replace with a unique test ID
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