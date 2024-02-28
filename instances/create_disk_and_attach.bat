@echo off
setlocal

REM get user input for county name
set /p county=Enter the county name:

REM create and attach disk
gcloud compute disks create "sdl22-%county%-01-e-disk" --size=100GB --type=pd-ssd --zone=us-east1-d
gcloud compute instances attach-disk "sdl22-%county%-01" --disk="sdl22-%county%-01-e-disk" --device-name=e-disk --zone=us-east1-d