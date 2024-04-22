#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -p <project_id> -z <zone> -n <instance_group_name> -t <instance_template> -s <target_size>"
    echo "Options:"
    echo "  -p    Project ID"
    echo "  -z    Zone"
    echo "  -n    Instance group name"
    echo "  -t    Instance template name"
    echo "  -s    Target size"
    exit 1
}

# Parse command-line options
while getopts ":p:z:n:t:s:" opt; do
    case ${opt} in
        p)
            PROJECT_ID=$OPTARG
            ;;
        z)
            ZONE=$OPTARG
            ;;
        n)
            INSTANCE_GROUP_NAME=$OPTARG
            ;;
        t)
            INSTANCE_TEMPLATE=$OPTARG
            ;;
        s)
            TARGET_SIZE=$OPTARG
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." 1>&2
            usage
            ;;
    esac
done

# Check if all required parameters are provided
if [ -z "$PROJECT_ID" ] || [ -z "$ZONE" ] || [ -z "$INSTANCE_GROUP_NAME" ] || [ -z "$INSTANCE_TEMPLATE" ] || [ -z "$TARGET_SIZE" ]; then
    echo "All options are required."
    usage
fi

# Create instance group
gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
    --base-instance-name $INSTANCE_GROUP_NAME \
    --size $TARGET_SIZE \
    --template $INSTANCE_TEMPLATE \
    --zone $ZONE \
    --project $PROJECT_ID

# Check if instance group creation was successful
if [ $? -eq 0 ]; then
    echo "Instance group '$INSTANCE_GROUP_NAME' created successfully in zone '$ZONE'."
else
    echo "Failed to create instance group."
fi
