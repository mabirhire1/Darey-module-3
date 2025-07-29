# Deploy and Configure Nginx Web Server using Ansible

## Overview

Nginx is a powerful and widely used web server known for its performance abd flexibility. This project demonstrates how to automate the deployment and configuration of Nginx web server using Ansible, instead of manually configuring Nginx on multiple servers. 

## Prerequisites

Before starting this project, ensure you have:

- **Linux Servers:** At least one Linux server to act as the target machine and optional control machine for Ansible
- **SSH Access**: OpenSSH client and server
- **Network Access**: SSH connectivity between control and target machines public key authentication.
- **Sudo Privileges**: Administrative access on target servers
- **Text Editor**: For creating and editing Ansible playbooks

**Estimated Time**: 2-3 hours

## Project Structure

```
nginx-ansible-deployment/
├── README.md
├── inventory.ini
├── install_nginx.yml
├── configure_nginx.yml
└── files/
    └── index.html
```

## Step-by-Step Implementation

### Step 1: Install and Configure Ansible

#### 1.1 Install Ansible on Control Machine

```bash
# Update package repository
sudo apt update

# Install Ansible
sudo apt install ansible -y
```

#### 1.2 Verify Installation

```bash
# Check Ansible version
ansible --version
```

#### 1.3 Set Up SSH Key Authentication

```bash
# Generate SSH key pair (if not already exists)
ssh-keygen -t rsa -b 4096

# Copy public key to target server
ssh-copy-id user@<target-server-ip>

# Test SSH connection
ssh user@<target-server-ip>
```
[SSH](img/image.png)

### Step 2: Create Ansible Inventory File

#### 2.1 Create Inventory File

```bash
nano inventory.ini
```

#### 2.2 Define Target Servers

```ini
[web_servers]
target ansible_host=<target-server-ip> ansible_user=<username>

# Example:
# target ansible_host=192.168.1.100 ansible_user=ubuntu
```

#### 2.3 Test Connectivity

```bash
# Test connection to all hosts
ansible -i inventory.ini all -m ping
```

### Step 3: Create Nginx Installation Playbook

#### 3.1 Create Installation Playbook

```bash
nano install_nginx.yml
```

#### 3.2 Playbook Content

```yaml
---
- name: Install Nginx on the server
  hosts: web_servers
  become: yes
  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: yes
```

#### 3.3 Run Installation Playbook

```bash
ansible-playbook -i inventory.ini install_nginx.yml
```

### Step 4: Configure Custom Nginx Website

#### 4.1 Create Configuration Playbook

```bash
nano configure_nginx.yml
```

#### 4.2 Playbook Content

```yaml
---
- name: Configure Nginx website
  hosts: web_servers
  become: yes
  tasks:
    - name: Create website root directory
      file:
        path: /var/www/mywebsite
        state: directory
        mode: '0755'

    - name: Deploy HTML content
      copy:
        content: |
          <html>
          <head><title>Welcome to My Website</title></head>
          <body>
          <h1>Hello from Nginx!</h1>
          <p>This website was deployed using Ansible automation!</p>
          </body>
          </html>
        dest: /var/www/mywebsite/index.html

    - name: Configure Nginx server block
      copy:
        content: |
          server {
              listen 80;
              server_name _;
              root /var/www/mywebsite;
              index index.html;
              location / {
                  try_files $uri $uri/ =404;
              }
          }
        dest: /etc/nginx/sites-available/mywebsite

    - name: Enable the Nginx server block
      file:
        src: /etc/nginx/sites-available/mywebsite
        dest: /etc/nginx/sites-enabled/mywebsite
        state: link

    - name: Remove default Nginx server block
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent

    - name: Reload Nginx
      service:
        name: nginx
        state: reloaded
```

#### 4.3 Run Configuration Playbook

```bash
ansible-playbook -i inventory.ini configure_nginx.yml
```
![Playbook](img/image1.png)

### Step 5: Verify Deployment

#### 5.1 Test Nginx Service

```bash
# Check if Nginx is running on target server
ansible -i inventory.ini web_servers -m shell -a "systemctl status nginx"
```
![Nginx Service](img/image2.png)

#### 5.2 Test Website Access

```bash
curl http://23.22.199.187
```
![Web Access](img/image3.png)

#### 5.3 Browser Verification

Open your web browser and navigate to:
```
http://23.22.199.187
```
![Nginx Website](img/image4.png)


## Complete Deployment Commands

For a quick deployment, run these commands in sequence:

```bash
# 1. Test connectivity
ansible -i inventory.ini all -m ping

# 2. Install Nginx
ansible-playbook -i inventory.ini install_nginx.yml

# 3. Configure website
ansible-playbook -i inventory.ini configure_nginx.yml

# 4. Verify deployment
curl http://<target-server-ip>
```

## Key Features Implemented

- **Automated Nginx Installation**: Using Ansible apt module  
- **Service Management**: Ensuring Nginx starts and enables on boot  
- **Custom Website Deployment**: Creating and deploying HTML content  
- **Server Block Configuration**: Setting up custom Nginx server blocks  
- **Default Site Removal**: Cleaning up default Nginx configuration  
- **Service Reload**: Applying configuration changes without downtime  

## Troubleshooting

### Common Issues and Solutions

1. **SSH Connection Failed**
```bash
# Ensure SSH key is added to target server
ssh-copy-id user@target-server-ip
```

2. **Permission Denied**
```bash
# Ensure user has sudo privileges
sudo usermod -aG sudo username
```

3. **Nginx Directory does not exist**
```bash
# Create missing Directories
Creates /etc/nginx/sites-available directory if it doesn't exist
and
Creates /etc/nginx/sites-enabled directory if it doesn't exist
```   

4. **Nginx Failed to Start**
```bash
# Check Nginx configuration syntax
ansible -i inventory.ini web_servers -m shell -a "nginx -t"
```

5. **Website Not Accessible**
```bash
# Check if port 80 is open
ansible -i inventory.ini web_servers -m shell -a "ufw status"
```

## Benefits of This Approach

- **Consistency**: Same configuration across all servers
- **Scalability**: Easy to deploy to multiple servers simultaneously
- **Repeatability**: Playbooks can be run multiple times safely
- **Version Control**: Configuration stored as code
- **Documentation**: Self-documenting infrastructure

## Next Steps

After completing this basic setup, consider:

- Adding SSL/TLS certificates using Let's Encrypt
- Implementing load balancing across multiple servers
- Adding monitoring and logging configuration
- Creating roles for better playbook organization
- Implementing CI/CD pipelines for automated deployments

## Learning Outcomes

By completing this project, you have learned to:

1. Install and configure Ansible for infrastructure automation
2. Create and manage Ansible inventory files
3. Write Ansible playbooks for software installation
4. Configure web servers using Infrastructure as Code
5. Verify and troubleshoot automated deployments

## Contributing

Feel free to fork this project and submit pull requests for improvements or additional features.

## License

This project is open source and available under the [MIT License](LICENSE).