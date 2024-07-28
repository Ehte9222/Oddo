# Odoo Project
This repository contains the community version of Odoo 17.
# Odoo Server Setup

This repository contains instructions and Bash scripts to automate the setup of an Odoo server. The scripts handle server updates, user creation, and the installation of necessary dependencies.

## Prerequisites

- A server running AlmaLinux or a compatible Linux distribution.
- Sudo privileges on the server.

## Installation

To set up the Odoo server, follow these steps:

1. **Clone this repository to your server:**

  ```bash
   git clone git@github.com:Ehte9222/Oddo.git
   cd Odoo ```


2. **Run the setup_odoo_server.sh script:**

 ```bash 
 ./setup_odoo_server.sh```

3. **Run the setup_postgresql.sh script:**
```bash
./setup_postgresql.sh```