@echo off
setlocal

REM set region and zone
set region=us-east1
set zone=us-east1-d

REM Initialize instance number to 1
set "instance_number=01"

REM :CHECK_NAME
REM List existing instances and check for name conflicts
REM set "count="
REM for /f "tokens=1,* delims=:" %%A in ('gcloud compute instances list --format="table(name)" ^| findstr /i /c:"sdl22-%count%-%%instance_number%"') do (
REM  set /a "instance_number+=1"
REM    if %instance_number% leq 10 (
REM        goto CHECK_NAME
REM    ) else (
REM        echo Error: Maximum number of instances reached for sdl22-%count%.
REM        exit /b 1
REM    )
REM )

REM Get user input for county name
REM set /p count=Enter the county name:

REM set machine configuration and type
set machine_type=n2-standard-4

REM set boot disk settings
set os=windows-2022
set boot_disk_type=pd-ssd
set boot_disk_size=100GB
set deletion_rule=delete

REM set identity and API access
set access_scopes=default

REM set observability - OPS Agent
set ops_agent=install

REM est advanced options - Networking
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

REM create instance
gcloud compute instances create "sdl22-%count%-%%instance_number%" --region=%region% --zone=%zone% --machine-type=%machine_type% --image-family=%os% --image-project=windows-cloud --boot-disk-type=%boot_disk_type% --boot-disk-size=%boot_disk_size% --boot-disk-device-name="sdl22-%count%-%%instance_number%-e" --deletion-rule=%deletion_rule% --network=%network% --subnet=%subnetwork% --tags=%network_tags% --scopes=%access_scopes% --metadata=enable-oslogsin=true --shielded-vtpm;=%vtpm% --shielded-integrity-monitoring=%integrity_monitoring% --create-disk="auto-delete=false" --zone=%zone% --network-interface="subnet=%subnetwork%,network-tier=%network_service_tier%,network-ip-name=sdl22-%count%-%%instance_number%-internal or external,network-tags=%network_tags%,nic-type=%network_interface_card%,public-cmd=true,can-ip-forward=false"
