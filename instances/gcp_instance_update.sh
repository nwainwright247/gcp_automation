#!/bin/bash

# STEP 1 - grab county names and maximum version from existing instances
existing_counties_and_versions=($(gcloud compute instances list --format="value(name)" | grep -oP 'sdl-lan-win22-\K[^-]+' | awk -F '-' '{print $NF}' | sort -n -r))

echo "Step 1: County names and maximum versions from existing instances:"
for entry in "${existing_counties_and_versions[@]}"; do
  county=$(echo "${entry}" | cut -d ':' -f 1)
  max_version=$(echo "${entry}" | cut -d ':' -f 2)
  
  echo " - County: $county, Max Version: $max_version"
done

#create an array of existing counties
existing_counties=($(echo "${existing_counties_and_versions[@]}" | awk -F ':' '{print $1}' | sort -u))

#create new instances with incremented version numbers
echo "Creating new instances:"
for county in "${existing_counties[@]}"; do
  #find the maximum version for the current county
  max_version=$(echo "${existing_counties_and_versions[@]}" | grep -oP "${county}:\K\d+" | head -n 1)
  if [ -z "${max_version}" ]; then
    #if no existing versions, start with 01
    max_version="00"
  fi

  #increment the version for the new instance
  new_version=$(printf "%02d" $((10#${max_version} + 1)))

  instance_name="sdl-lan-win22-${county}-${new_version}"
  boot_drive="${instance_name}-boot"

  #create VM command using gcloud
  gcloud compute instances create "${instance_name}" --boot-disk-size=10GB --image-family=windows-2019 --image-project=windows-cloud --boot-disk-type=pd-ssd

  echo " - Created instance: $instance_name"
done

# STEP 2 - track down current instance names and delete
#list all instance names and delete them
echo "Step 2: Deleting all instances"
instances_to_delete=($(gcloud compute instances list --format="value(name)"))
for instance in "${instances_to_delete[@]}"; do
  echo " - Deleting instance: $instance"
  gcloud compute instances delete "${instance}" --quiet
done

# STEP 3
#list all drives and VM names
echo "Step 3: Cloning leftover drives"
drives_and_vms=($(gcloud compute instances list --format="value(name,boot-disk)" | tr '\n' ' '))

for ((i = 0; i < ${#drives_and_vms[@]}; i += 2)); do
  #extract VM name and drive name
  vm_name="${drives_and_vms[i]}"
  drive_name="${drives_and_vms[i + 1]}"
  
  #extract county name from the VM name
  county=$(echo "${vm_name}" | grep -oP 'sdl-lan-win22-\K[^-]+')

  echo " - Cloning drive for VM: $vm_name"
  clone_drive="${drive_name}-clone"

  #clone the drive using gcloud command
  gcloud compute disks create "${clone_drive}" --source-disk="${drive_name}" --source-disk-zone=us-central1-a

  echo " - Attaching new drive to VM: $vm_name"
  #attach the new drive to the VM
  gcloud compute instances attach-disk "${vm_name}" --disk="${clone_drive}" --device-name="${clone_drive}"
done

#COMMANDS

#Run Script in GCP Cloud Shell
#   upload script into GCP
#       gcloud alpha cloud-shell scp ./gcp_instance_update.sh $nwainwright@cloudshell:~
#   grant execute permissions
#       chmod +x gcp_instance_update.sh
#   run the script
#       ./gcp_instance_update.sh

#Another way to run this script in GCP Cloud Shell
# Make the script executable
#   chmod +x gcp_instance_update.sh
# Run the script
#   ./gcp_instance_update.sh