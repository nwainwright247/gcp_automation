 #!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <command> [options]"
    echo "Commands:"
    echo "  grant     Grant a role to a user or service account"
    echo "  revoke    Revoke a role from a user or service account"
    echo "  list      List members with a specific role"
    exit 1
}

# Function to handle granting roles
grant_role() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: $0 grant <role> <member>"
        exit 1
    fi
    gcloud projects add-iam-policy-binding $PROJECT_ID --member="$3" --role="$2"
    if [ $? -eq 0 ]; then
        echo "Role '$2' granted to '$3' successfully."
    else
        echo "Failed to grant role."
    fi
}

# Function to handle revoking roles
revoke_role() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: $0 revoke <role> <member>"
        exit 1
    fi
    gcloud projects remove-iam-policy-binding $PROJECT_ID --member="$3" --role="$2"
    if [ $? -eq 0 ]; then
        echo "Role '$2' revoked from '$3' successfully."
    else
        echo "Failed to revoke role."
    fi
}

# Function to handle listing members with a specific role
list_members() {
    if [ -z "$1" ]; then
        echo "Usage: $0 list <role>"
        exit 1
    fi
    gcloud projects get-iam-policy $PROJECT_ID --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.role:$1"
}

# Parse command-line options
if [ "$#" -lt 1 ]; then
    usage
fi

PROJECT_ID="your-project-id"  # Set your project ID here

case $1 in
    grant)
        grant_role $2 $3 $4
        ;;
    revoke)
        revoke_role $2 $3 $4
        ;;
    list)
        list_members $2
        ;;
    *)
        echo "Invalid command."
        usage
        ;;
esac


## You can then run the script with different commands:
## Grant a role: ./manage_iam.sh grant roles/editor user@example.com
## Revoke a role: ./manage_iam.sh revoke roles/editor user@example.com
## List members with a specific role: ./manage_iam.sh list roles/editor1