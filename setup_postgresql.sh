#!/bin/bash

# Function to install PostgreSQL and PostgreSQL client tools
install_postgresql() {
    echo "Installing PostgreSQL and PostgreSQL client tools..."
    sudo dnf install -y postgresql-server postgresql-contrib postgresql-client
    sudo postgresql-setup --initdb
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
}

# Function to create PostgreSQL user and database
setup_database() {
    local db_user="odoo17"
    local db_name="odoo17"

    echo "Creating PostgreSQL user '$db_user'..."
    sudo -u postgres psql -c "CREATE USER $db_user WITH PASSWORD 'S0larS0ng!';"

    echo "Creating PostgreSQL database '$db_name'..."
    sudo -u postgres psql -c "CREATE DATABASE $db_name OWNER $db_user;"

    echo "Granting all privileges on database '$db_name' to user '$db_user'..."
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $db_name TO $db_user;"

    echo "Database setup complete."
}

# Main function to run all tasks
main() {
    install_postgresql
    setup_database
}

main
