
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

**The configuration file should be copied to /etc:**


```bash 
sudo cp /home/odoo17/debian/odoo.conf /etc/odoo17.conf
sudo vi /etc/odoo17.conf
```
**:fa-arrow-right: Update the conf file as shown in the code below:**

```ini
[options]
   ; This is the password that allows database operations:
   admin_passwd = admin
   db_host = False
   db_port = False
   db_user = odoo17
   db_password = False
   addons_path = /home/odoo17/Odoo/addons
   logfile = /var/log/odoo/odoo17.log
```
Next, you need to grant system user Odoo access to the conf file.
 ```bash 
 sudo chown $USER: /etc/odoo17.conf
sudo chmod 640  /etc/odoo17.conf
```

Additionally, create an Odoo log directory and set permissions for it to assist you in identifying Odoo-related problems.

```bash 
sudo mkdir /var/log/odoo
sudo chown $USER:  /var/log/odoo
```

**6. Odoo service file**


We have to create a service to run Odoo. Let’s create a service file ‘`odoo17.service`’ in `/etc/systemd/system`.

```bash
sudo vi /etc/systemd/system/odoo17.service
```
Add the following aspects to the newly created service file.
 ```ini
 [Unit]
   Description=Odoo17
   Documentation=http://www.odoo.com
   [Service]
   # Ubuntu/Debian convention:
   Type=simple
   User=odoo17
   ExecStart=/opt/odoo17/odoo-bin -c /etc/odoo17.conf
   [Install]
   WantedBy=default.target
```
Finally, set the root user's permissions for this service file.
```bash 
sudo chmod 755 /etc/systemd/system/odoo17.service
sudo chown root: /etc/systemd/system/odoo17.service
```
**7. Run Odoo**


```bash
sudo systemctl start odoo17.service
```
Use the above command to launch the Odoo instance. Then, use the following command to see the service's current status. Furthermore, the installation of Odoo was successful if it is shown as active.
```bash 
sudo systemctl status odoo17.service
```
*Now, you can access Odoo by entering the following URL. It will reroute to the database creation page.*

[http://<your_domain_or_IP_address>:8069](http://<your_domain_or_IP_address>:8069)

**Check Odoo logs**


Suppose you are experiencing problems with the installation or for any other reason. In that case, you can use the following command to examine the logs of the Odoo platform you have configured. You can view the real-time logs in the terminal by using this command.
```bash 
sudo tail -f /var/log/odoo/odoo17.log
```
Finally, use the following command to start the Odoo service automatically after restarting the server:
```bash 
sudo systemctl enable odoo17.service
```
Use the following command to restart the Odoo service if you have made any modifications to the add-ons so that your instance will reflect the updates
```bash 
sudo systemctl restart odoo17.service
```


**8. Setting up the Nginx Reverse Proxy**

Currently, Odoo setup will be accessible at the following URL:

[http://<your_domain_or_IP_address>:8069](http://<your_domain_or_IP_address>:8069)

But we have to make it available at the following URL 

[https://odoosite.perceptiond.click](https://odoosite.perceptiond.click)

For this, you are required to set up Nginx reverse proxy.
Create a configuration file name: odoosite-perceptiond.conf in `/etc/nginx/conf.d/` and set all the related configurations in this file. 
```bash 
sudo vi odoosite-perceptiond.conf
```
Then Paste the Following: 
```nginx
server {
    listen 80;
    server_name odoosite.perceptiond.click;

    location / {
        proxy_pass http://127.0.0.1:8069;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
And `:wq`to save the file.


**Setup SSL certificates**
```bash 
dnf install certbot python3-certbot-nginx
certbot --nginx -d odoosite.perceptiond.click
```

*We need to update Odoo's configuration as well so Odoo knows that a reverse proxy server is being used. This can be achieved by*

```bash 
sudo vi /etc/odoo17.conf
```
Add the following: 
```ìni
proxy_mode = True
```
After adding the proxy_mode parameter, restart the Odoo server and nginx.

```bash
systemctl restart odoo17.service
systemctl restart nginx
```

Now Odoo application should be accessible at the following domain name: 

:fa-hand-o-right: [https://odoosite.perceptiond.click](https://odoosite.perceptiond.click)
 
 > [!TIP]
> The Nginx configuration file also exists in the directory. Please run the following command to move odoosite-perceptiond.conf to /etc/nginx/conf.d/:
```bash
sudo mv /path/to/odoosite-perceptiond.conf /etc/nginx/conf.d/
```
>If you encounter any issues with the configuration file I provided earlier, this file is an updated version and should resolve those problems. such as `SSL_do_handshake() failed`

> [!NOTE]
> If you encounter any internet server errors or find that the server is overloaded, please delete the `odoo17` database from PostgreSQL. Afterwards, manually create a new database from your Odoo site.

*Congrats you have completed the setup!!*
[![Ducky](https://cdn.discordapp.com/attachments/747037852520546334/1267134927082885140/1144402890966974476.gif?ex=66a7aedc&is=66a65d5c&hm=5aaa1ead84c4ec606afa7f47e766a6e865347220a7de0a5788c7fe845ced18c2& "Ducky")](https://cdn.discordapp.com/attachments/747037852520546334/1267134927082885140/1144402890966974476.gif?ex=66a7aedc&is=66a65d5c&hm=5aaa1ead84c4ec606afa7f47e766a6e865347220a7de0a5788c7fe845ced18c2& "Ducky")
# :wink: 

> [!TIP]
> Helpful advice for doing things better or more easily.


#### Acknowledgments

    •	Odoo for their amazing software.
	•	AlmaLinux for their stable and reliable distribution.
