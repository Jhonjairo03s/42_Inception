# User Documentation

Welcome to the Inception infrastructure. This guide explains how to interact with the provided web stack as an end-user or system administrator.

## Services Provided by the Stack
This infrastructure provides a fully functional, high-performance web environment consisting of:
1. **NGINX:** The secure gateway. It handles incoming web traffic, encrypts it using an SSL/TLS certificate, and routes it to the website.
2. **WordPress:** The Content Management System (CMS) where you can publish posts, manage themes, and build your site.
3. **MariaDB:** The database engine that securely stores all WordPress data (users, posts, settings).
4. **Redis (Bonus):** An in-memory cache system that significantly speeds up the website by remembering frequent database queries.

## How to Start and Stop the Project
The entire infrastructure is automated via a `Makefile` located at the root of the project. Open your terminal in the project directory and use the following commands:

- **To start the project:**
  ```bash
  make
  ```
  *This will create the necessary data folders, build the container images, and launch all services in the background.*

- **To stop the project:**
  ```bash
  make clean
  ```
  *This stops and removes the running containers, but safely preserves your website data and database on your hard drive.*

## Accessing the Website and Administration Panel
Once the project is running (after using `make`), open your preferred web browser:

- **Main Website:** Go to `https://jhvalenc.42.fr`
- **Administration Panel:** Go to `https://jhvalenc.42.fr/wp-admin`

*Note: Because the SSL certificate is self-signed locally, your browser will display a "Not Secure" or "Invalid Certificate" warning. You must click "Advanced" and then "Proceed/Accept Risk" to view the site.*

## Locating and Managing Credentials
All sensitive credentials (database passwords, WordPress admin accounts, etc.) are managed via a single configuration file named `.env` located inside the `srcs/` folder. 
If you need to view or change passwords, you must edit this `.env` file before starting the project. Do not share this file publicly.

## Checking if Services are Running Correctly
To verify the health of the infrastructure, open your terminal and run:
```bash
sudo docker ps
```
You should see four containers listed (`nginx`, `wordpress`, `mariadb`, `redis`). Check the "STATUS" column; they should all say **"Up"**. If any container says "Restarting" or is missing, there is an issue with the deployment.