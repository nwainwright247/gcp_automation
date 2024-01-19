#!/bin/bash

#script to run security scans using Google Cloud Security Scanner and other tools
project_id="project-id"
web_app_url="https://app-url.com"
instance_group="instance-group"
cloud_storage_bucket="bucket-name"
cloud_function_name="cloud-function"
pubsub_topic="pubsub-topic"

#security scan for web application
gcloud beta compute security-scanner scan-configs create "web-app-config" \
  --description="Security scan configuration for web application" \
  --authentication-login "USERNAME=admin,PASSWORD=admin-password" \
  --schedule="every 24 hours" \
  --target-url="${web_app_url}" \
  --project="${project_id}"

#security scan for instances in an instance group
gcloud beta compute security-scanner scan-configs create "instance-group-config" \
  --description="Security scan configuration for instance group" \
  --schedule="every 24 hours" \
  --target-https-proxy="${instance_group}-https-proxy" \
  --project="${project_id}"

#security scan for Cloud Storage bucket
gsutil iam get gs://"${cloud_storage_bucket}"

#security scan for Cloud Functions
gcloud functions deploy "${cloud_function_name}" \
  --runtime=nodejs14 \
  --trigger-http \
  --allow-unauthenticated \
  --project="${project_id}"

#security scan for Pub/Sub topics
gcloud pubsub topics describe "${pubsub_topic}" --project="${project_id}"