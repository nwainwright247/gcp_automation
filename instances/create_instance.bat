@echo off
SETLOCAL EnableDelayedExpansion

REM set the region / zone
set region=us-east1
set zone=us-east1-d

REM set machine config and type
set machine_type=n2-standard-4

REM set boot disk settings
set os=windows-2022
set boot_disk_type=pd-ssd
set boot_disk_size=50GB
set deletion_rule=delete

REM set identity and API access
set access_scopes=default

REM set observability - OPS Agent
set ops_agent=install

REM set advanced options - networking
set network_tags=allow-rdp-from-office,lb-health-checks
set network_interface_card=virtio
set network=sdl-lan-google
set subnetwork=sdl-lan-google-03

REM set network interfaces settings
set ip_stack=ipv4
set primary_internal_ip=static
set external_ip=static
set network_service_tier=premium

REM set security options
set vtpm=true
set integrity_monitoring=true

REM set "adcreds=New-Object System.Management.Automation.PSCredential(\"spatialdatalog\jkennedy\", (ConvertTo-SecureString \"Password399:)\" -AsPlainText -Force))"

set adcreds = New-Object pscredential -ArgumentList ([pscustomobject]@{^
    UserName = spatialdatalog\jkennedy^
    Password = (ConvertTo-SecureString -String 'Password399:)' -AsPlainText -Force)[0]^
})

REM verify existing disks and determine the highest disk number
for /f "tokens=2 delims=-" %%D in ('gcloud compute disks list --format="value(name)"') do (
    for /f "tokens=2 delims=-" %%N in ("%%D") do (
        if %%N gtr !disk_count! set /a disk_count=%%N
    )
)

REM increment the disk count to prepare for next available disk
set /a disk_count+=1

REM now loop through county names from the CSV file
for /F "skip=1 tokens=1,2 delims=," %%A in (counties_test.csv -F) do (

    REM build name from county
    set instance_name=sdl22-%%A-01

    REM create instance
    gcloud compute instances create sdl22-%%A-01 --zone=%zone% --machine-type=%machine_type%^
    --create-disk=auto-delete=yes,boot=yes,device-name=sdl22-%%A-01,image=projects/sdl-lan/global/images/sdl22-county-01,mode=rw,size=100,type=projects/sdl-lan/zones/us-central1-a/diskTypes/pd-ssd^
    --create-disk=device-name=sdl22-%%A-01-e,mode=rw,name=disk-1,size=1000,type=projects/sdl-lan/zones/us-east1-d/diskTypes/pd-ssd^
    --network=%network% --subnet=%subnetwork% --tags=%network_tags% --scopes=%access_scopes% --private-network-ip=10.3.0.%%B^
    --metadata=windows-startup-script-ps1="Add-Computer -ComputerName %%A-01 -DomainName sdldesktop.com -Credential %adcreds% -Restart',enable-oslogin=true

    REM gcloud compute disks snapshot-schedule sdl22-%%A-01 --snapshot-schedule="0 0 * * 0#2"
    REM gcloud compute disks snapshot-schedule sdl22-%%A-01-e --snapshot-schedule="0 0 * * *"
)


endlocal