#!/bin/bash

# This script installs a specific version of Terraform as specified by the user.
# Usage
# ./install_tf.sh 1.8.1


# Check if a version was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# Set the appropriate download URL and binary path
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip"
TERRAFORM_ZIP="terraform_${VERSION}_linux_amd64.zip"
INSTALL_DIR="/usr/local/bin"

# Ensure wget and unzip are installed
sudo apt-get update && sudo apt-get install -y wget unzip

# Download Terraform
echo "Downloading Terraform v${VERSION}..."
wget ${TERRAFORM_URL} -O ${TERRAFORM_ZIP}

# Verify the download
echo "Verifying download..."
unzip -t ${TERRAFORM_ZIP}
if [ $? -ne 0 ]; then
    echo "Failed to verify the Terraform archive."
    exit 1
fi

# Unzip Terraform
echo "Installing Terraform..."
unzip ${TERRAFORM_ZIP}
sudo mv terraform ${INSTALL_DIR}

# Clean up
rm ${TERRAFORM_ZIP}

# Verify installation
installed_version=$(terraform --version)
echo "Installed ${installed_version}"

echo "Terraform installation is complete."
