
# Odoo Server Setup

This repository contains instructions and Bash scripts to automate the setup of an Odoo server. The scripts handle server updates, user creation, and the installation of necessary dependencies.

## Prerequisites

- A server running AlmaLinux or a compatible Linux distribution.
- Sudo privileges on the server.

## Installation

To set up the Odoo server, follow these steps:

**1. Clone this repository to your server:**
   ```bash 
   git clone git@github.com:Ehte9222/Oddo.git
   cd Odoo
   ```

**2. Run the setup_odoo_server.sh script:**
 
```bash
./setup_odoo_server.sh 
```

**3. Run the setup_postgresql.sh script:**
```bash
./setup_postgresql.sh
```

**4. Install and Setup Odoo:**

i. Install dependencies and packages using the following command from the project root:
```bash 
pip3 install --upgrade pip
pip3 install -r requirements.txt
```
 ii: Install the following library to print PDFs:
 ```bash 
  wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox-0.12.6.1-2.almalinux8.x86_64.rpm
  dnf install ./wkhtmltox-0.12.6.1-2.almalinux8.x86_64.rpm
  ```
**5. Setup Conf file**
Odoo requires certain information to function, such as the database user, password, locations of add-ons, etc. The configuration file will also have these available. Thus, the first thing we should do is create an Odoo configuration file. You can also find an example configuration file in the Odoo folder, which you can copy to the desired location. Configuration files are typically kept in `/etc`.
