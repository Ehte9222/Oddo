#!/bin/bash

# Function to update the server
update_server() {
    echo "Updating server..."
    sudo dnf update -y
}

# Function to create a new system user
create_user() {
    echo "Creating a new system user 'odoo17'..."
    sudo adduser odoo17
    sudo passwd odoo17
}

# Function to install Python 3.10.12 and necessary packages
install_python_packages() {
    echo "Checking for Python 3 installation..."
    if ! command -v python3 &> /dev/null
    then
        echo "Python 3 not found. Installing Python 3.10.12..."
        sudo dnf install -y python3
        sudo dnf install -y python3-pip
    else
        echo "Python 3 is already installed."
    fi

    echo "Installing necessary Python packages..."
    sudo dnf install -y python3-devel libxml2-devel libxslt-devel zlib-devel cyrus-sasl-devel openldap-devel gcc gcc-c++ openssl-devel libffi-devel mariadb-devel libjpeg-turbo-devel postgresql-devel libjpeg-devel lcms2-devel blas-devel atlas-devel
}

# Function to install web dependencies
install_web_dependencies() {
    echo "Installing npm..."
    sudo dnf install -y npm
    echo "Creating symlink for nodejs..."
    sudo ln -s /usr/bin/nodejs /usr/bin/node
    echo "Installing less and less-plugin-clean-css..."
    sudo npm install -g less less-plugin-clean-css
    echo "Installing node-less..."
    sudo dnf install -y nodejs-less
}

# Main function to run all tasks
main() {
    update_server
    create_user
    install_python_packages
    install_web_dependencies
    echo "Server setup complete."
}

main
