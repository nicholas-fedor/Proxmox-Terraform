#!/bin/bash
################################################################################
#   _______ _______  ______  ______ _______ _______  _____   ______ _______    #
#      |    |______ |_____/ |_____/ |_____| |______ |     | |_____/ |  |  |    #
#      |    |______ |    \_ |    \_ |     | |       |_____| |    \_ |  |  |    #
#                                                                              #
#   Official Documentation: https://developer.hashicorp.com/terraform/install  #
################################################################################

COMMAND="terraform"
HASHICORP_GPG_KEY_URL="https://apt.releases.hashicorp.com/gpg"
HASHICORP_GPG_KEY_FILEPATH="/usr/share/keyrings/hashicorp-archive-keyring.gpg"
HASHICORP_APT_URL="https://apt.releases.hashicorp.com"
HASHICORP_APT_SOURCE_FILEPATH="/etc/apt/sources.list.d/hashicorp.list"

install() {
    # Print the commands to screen
    set -x

    # Download Hashicorp's GPG key
    wget -O- $HASHICORP_GPG_KEY_URL | sudo gpg --dearmor -o $HASHICORP_GPG_KEY_FILEPATH

    # Add the GPG key to the apt sources keyring
    echo "deb [signed-by=$HASHICORP_GPG_KEY_FILEPATH] $HASHICORP_APT_URL $(lsb_release -cs) main" | sudo tee $HASHICORP_APT_SOURCE_FILEPATH

    # Update and install Terraform
    sudo apt update && sudo apt install $COMMAND

    # Stop printing commands to screen
    { set +x; } 2>/dev/null
}

verify() {
    if command -v $COMMAND >&2 > /dev/null; then
        echo "$COMMAND installed successfully!"
        exit 0
    else
        echo "Installation failed"
        exit 1
    fi
}


##################################### MAIN #####################################
# Check if program already installed
if command -v $COMMAND >&2 > /dev/null; then
    echo "$COMMAND already installed"
    exit 1
else
    echo "Installing $COMMAND"
    install
    verify
fi
###################################### END ######################################