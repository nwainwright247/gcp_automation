#!/bin/bash

#script to manage encryption settings for GCP resources
project_id="project-id"
storage_bucket="storage-bucket"
datastore_namespace="datastore-namespace"

#enable encryption at rest for Cloud Storage bucket
gsutil defacl set private gs://"${storage_bucket}"
gsutil acl ch -u "${project_id}@appspot.gserviceaccount.com:O" gs://"${storage_bucket}"
gsutil kms set-default-key "${project_id}@appspot.gserviceaccount.com" gs://"${storage_bucket}"

#enable encryption at rest for Datastore
gcloud datastore namespaces create "${datastore_namespace}" --project="${project_id}"
gcloud beta datastore indexes create index.yaml --project="${project_id}" --namespace="${datastore_namespace}"