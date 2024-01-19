#!/bin/bash

#script to manage firewall rules and network security settings in GCP
project_id="your-project-id"
network_name="your-network-name"
firewall_rule_name="example-firewall-rule"
allow_protocol="tcp"
allow_port="80"

#create a new firewall rule
gcloud compute firewall-rules create "${firewall_rule_name}" \
  --project="${project_id}" \
  --network="${network_name}" \
  --allow="${allow_protocol}:${allow_port}" \
  --source-ranges="0.0.0.0/0"  #adjust source ranges based on your requirements

echo "Firewall rule created: ${firewall_rule_name}"

#list existing firewall rules
echo "Existing firewall rules:"
gcloud compute firewall-rules list --project="${project_id}"

#update an existing firewall rule
gcloud compute firewall-rules update "${firewall_rule_name}" \
  --allow="${allow_protocol}:${allow_port},8080"  #modify allowed ports as needed

echo "Firewall rule updated: ${firewall_rule_name}"

#delete a firewall rule
#gcloud compute firewall-rules delete "${firewall_rule_name}" --project="${project_id}"
#uncomment the line above if you want to delete the firewall rule

echo "Script completed."