@echo off
setlocal

REM get user input for ccounty name
set /p county=Enter the county name:

REM join to domain
gcloud compute ssh "sdl22-%county%-01" --zone=us-east1-d --command="echo join_to_domain_command"