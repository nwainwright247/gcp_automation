#!/bin/bash

#script to configure logging and monitoring settings for security events
project_id="project-id"
logs_bucket="logs-bucket"
notification_email="email@example.com"

#set up logs for various security-related events
gcloud logging create sink security-logs-sink-all "storage.googleapis.com/${logs_bucket}" \
  --log-filter='severity>=ERROR AND resource.type!="gce_instance"'

#create metrics for different security-related events
gcloud logging metrics create firewall-deny-metric \
  --description="Metric for denied firewall traffic" \
  --filter='jsonPayload.event_subtype="firewall" AND jsonPayload.event_type="deny"'

gcloud logging metrics create iam-changes-metric \
  --description="Metric for IAM policy changes" \
  --filter='protoPayload.methodName="SetIamPolicy" AND resource.type!="gce_instance"'

#create an alerting policy for security-related events
gcloud alpha monitoring policies create security-alert-policy \
  --display-name="Security Alert Policy" \
  --conditions='metric.type="logging.googleapis.com/user/firewall-deny-metric" AND conditionThreshold.filter="jsonPayload.event_subtype=\"firewall\" AND jsonPayload.event_type=\"deny\"" OR metric.type="logging.googleapis.com/user/iam-changes-metric" AND conditionThreshold.filter="protoPayload.methodName=\"SetIamPolicy\" AND resource.type!=\"gce_instance\""'

#bind the alerting policy to a notification channel (e.g., email)
notification_channel_id=$(gcloud alpha monitoring channels create email "${notification_email}" --display-name="Security Events Notification Channel" --project="${project_id}" --format="value(name.basename())")
gcloud alpha monitoring policies update security-alert-policy --notification-channels="${notification_channel_id}"