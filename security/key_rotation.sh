 #!/bin/bash
# Script to automate the rotation of service account keys

service_account_email="your-service-account@your-project.iam.gserviceaccount.com"

gcloud iam service-accounts keys rotate --iam-account="${service_account_email}"
