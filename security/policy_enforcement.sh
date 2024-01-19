#!/bin/bash

#script to enforce security policies across GCP resources
project_id="project-id"
tag_to_enforce="secure-tag"

#get a list of all VM instances in the project
vm_instances=$(gcloud compute instances list --project="${project_id}" --format="value(name)")

#loop through each VM instance and enforce the security policy
for instance in ${vm_instances}; do
  #check if the required tag is present
  if gcloud compute instances describe "${instance}" --project="${project_id}" --format="value(tags.items[0])" | grep -q "${tag_to_enforce}"; then
    echo "Security policy compliant for VM instance: ${instance}"
  else
    #enforce the security policy by adding the required tag
    gcloud compute instances add-tags "${instance}" --tags="${tag_to_enforce}" --project="${project_id}"
    echo "Enforced security policy for VM instance: ${instance}"
  fi
done