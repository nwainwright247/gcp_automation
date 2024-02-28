@echo off
REM STEP 1 - grab county names and maximum version from existing instances
for /f "tokens=2 delims=-" %%a in ('gcloud compute instances list --format="value(name)" ^| findstr "sdl-lan-win22"') do (
    for /f "tokens=1,* delims=-" %%b in ("%%a") do (
        set "county=%%b"
        set "version=%%c"
        setlocal enabledelayedexpansion
        echo Step 1: County: !county!, Max Version: !version!
        endlocal
    )
)

REM create an array of existing counties
for /f "delims=" %%c in ('gcloud compute instances list --format="value(name)" ^| findstr "sdl-lan-win22" ^| for /f "tokens=1 delims=-" %%d in ("%%a") do echo %%d') do (
    setlocal enabledelayedexpansion
    set "existing_counties=!existing_counties! %%c"
    endlocal
)

REM create new instances with incremented version numbers
echo Creating new instances:
for %%e in (%existing_counties%) do (
    for /f "tokens=2 delims=-" %%f in ('gcloud compute instances list --format="value(name)" ^| findstr /i "sdl-lan-win22-%%e-" ^| findstr /r "[0-9][0-9]$"') do (
        set "max_version=%%f"
    )
    if not defined max_version set "max_version=00"
    set /a new_version=10#%max_version% + 1
    set "instance_name=sdl-lan-win22-%%e-!new_version:~-2!"
    set "boot_drive=!instance_name!-boot"

    REM create VM command using gcloud
    gcloud compute instances create "!instance_name!" --boot-disk-size=10GB --image-family=windows-2019 --image-project=windows-cloud --boot-disk-type=pd-ssd

    echo - Created instance: !instance_name!
)

REM STEP 2 - track down current instance names and delete
echo Step 2: Deleting all instances
for /f "tokens=*" %%g in ('gcloud compute instances list --format="value(name)"') do (
    echo - Deleting instance: %%g
    gcloud compute instances delete "%%g" --quiet
)

REM STEP 3
echo Step 3: Cloning leftover drives
for /f "tokens=1,2" %%h in ('gcloud compute instances list --format="value(name,boot-disk)"') do (
    set "vm_name=%%h"
    set "drive_name=%%i"
    for /f "tokens=2 delims=-" %%i in ("!vm_name!") do (
        set "county=%%i"
    )

    echo - Cloning drive for VM: !vm_name!
    set "clone_drive=!drive_name!-clone"

    REM clone the drive using gcloud command
    gcloud compute disks create "!clone_drive!" --source-disk="!drive_name!" --source-disk-zone=us-central1-a

    echo - Attaching new drive to VM: !vm_name!
    REM attach the new drive to the VM
    gcloud compute instances attach-disk "!vm_name!" --disk="!clone_drive!" --device-name="!clone_drive!"
)
