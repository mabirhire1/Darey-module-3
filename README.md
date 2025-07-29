# Ansible Linux Server Setup

Ansible is a powerful automation tool that simplifies the management of IT infastructure. This project is a  guide to setting up and configuring Ansible on a Linux server for IT infrastructure automation.

### Objectives
By completing this setup, you will:
- Understand what Ansible is and how it works
- Install and configure Ansible on a Linux control node
- Set up SSH key-based authentication for target nodes
- Create an Ansible inventory file
- Verify Ansible setup by running basic commands

## Prerequisites

Before starting, ensure you have:

- **Linux Machine:** A Linux server or virtual machine to act as the control node.
- **Target Machines:** At least one additional Linux server for Ansible to manage
- SSH access to all target machines
- Sudo privileges on the control node
- Basic knowledge of Linux command line
- A text editor (nano, vim, or similar)

### Network Requirements
- Network connectivity between control node and target machines
- Open SSH port (22) on target machines

## Installation Steps

### Step 1: Update Package Repository

First, update your system's package repository to ensure you have the latest package information:

```bash
sudo apt update
```

### Step 2: Install Ansible

Install Ansible using your distribution's package manager:

```bash
sudo apt install ansible -y
```

### Step 3: Verify Installation

Confirm that Ansible was installed successfully:

```bash
ansible --version
```
![Version](img/image.png)

## Configuration

### Step 4: Configure SSH Key-Based Authentication

#### Generate SSH Key Pair

Create an SSH key pair on the control node for passwordless authentication:

```bash
ssh-keygen -t rsa
```

When prompted:
- Press **Enter** to accept the default file location (`~/.ssh/id_rsa`)
- Press **Enter** to use an empty passphrase (or set one if preferred)

![SSH keygen](img/image1.png)

#### Copy Public Key to Target Machines

Distribute your public key to each target machine:

```bash
ssh-copy-id user@<target-server-ip>
```

Replace `user` with the actual username and `<target-server-ip>` with the target machine's IP address.

#### Test SSH Connection

Verify passwordless SSH access:

```bash
ssh user@<target-server-ip>
```
**Expected Output**
[ec2-user@172.31.10.100's password: ]
Last login: Tue Jul 29 15:47:00 2025 from 172.31.195.205
[ec2-user@linux_server1 ~]$

You should be able to connect without entering a password.

### Step 5: Create Ansible Inventory

#### Set Up Ansible Directory

Create a dedicated directory for Ansible configuration:

```bash
mkdir ~/ansible
cd ~/ansible
```

#### Create Inventory File

Create an inventory file to define your target machines:

```bash
nano inventory.ini
```

Add your target machines to the inventory:

```ini
[linux_servers]
target1 ansible_host=<target1-ip> ansible_user=<username>
target2 ansible_host=<target2-ip> ansible_user=<username>
```

**Configuration parameters:**
- `target1`, `target2`: Friendly names for your servers
- `ansible_host`: IP address or hostname of the target machine
- `ansible_user`: Username for SSH connection

Save and close the file (`Ctrl+X`, then `Y`, then `Enter` in nano).

## Testing and Verification

### Step 6: Test Ansible Connectivity

Verify that Ansible can communicate with your target machines:

```bash
ansible -i inventory.ini linux_servers -m ping
```

**Expected output:**
```
target1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
target2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

A "pong" response indicates successful connectivity to each target machine.

## Usage Examples

### Step 7: Run Ad-Hoc Commands

Now you can execute commands across your infrastructure:

#### Check System Uptime

```bash
ansible -i inventory.ini linux_servers -m command -a "uptime"
```
**Expected Output**
linux_server1 | SUCCESS | rc=0 >>
 16:16:32 up 10 min,  1 user,  load average: 0.05, 0.10, 0.15
linux_server2 | SUCCESS | rc=0 >>
 16:18:32 up 10 min,  1 user,  load average: 0.03, 0.08, 0.12

#### Check Disk Usage

```bash
ansible -i inventory.ini linux_servers -m shell -a "df -h"
```
**Expected Output**
linux_server1 | SUCCESS | rc=0 >>
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G  1.2G   18G   6% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
/dev/xvdb       100G   60M   95G   1% /data

linux_server2 | SUCCESS | rc=0 >>
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G  1.0G   19G   5% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
/dev/xvdb       100G   50M   95G   1% /data

#### Get System Information

```bash
ansible -i inventory.ini linux_servers -m setup
```
**Expected Output**
linux_server1 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": ["172.31.10.100"],
        "ansible_architecture": "x86_64",
        "ansible_distribution": "Ubuntu",
        "ansible_distribution_version": "20.04",
        "ansible_hostname": "linux_server1",
        "ansible_memfree_mb": 1900,
        "ansible_memory_mb": {
            "real": {"total": 2000, "used": 100, "free": 1900}
        },
        "ansible_processor_cores": 2,
        "ansible_processor_vcpus": 2,
        "ansible_system": "Linux",
        "ansible_uptime_seconds": 600
    },
    "changed": false
}

linux_server2 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": ["172.31.10.101"],
        "ansible_architecture": "x86_64",
        "ansible_distribution": "Ubuntu",
        "ansible_distribution_version": "20.04",
        "ansible_hostname": "linux_server2",
        "ansible_memfree_mb": 1950,
        "ansible_memory_mb": {
            "real": {"total": 2000, "used": 50, "free": 1950}
        },
        "ansible_processor_cores": 2,
        "ansible_processor_vcpus": 2,
        "ansible_system": "Linux",
        "ansible_uptime_seconds": 780
    },
    "changed": false
}

## Troubleshooting

### Common Issues

**SSH Connection Refused**
```bash
# Check if SSH service is running on target
ssh user@target-ip
# If connection fails, ensure SSH is installed and running on target machine
```

**Permission Denied**
```bash
# Ensure SSH key was copied correctly
ssh-copy-id user@target-ip
# Verify SSH key exists
ls -la ~/.ssh/
```

**Ansible Command Not Found**
```bash
# Reinstall Ansible
sudo apt update
sudo apt install ansible -y
```

**Host Key Verification Failed**
```bash
# Add host to known_hosts
ssh-keyscan -H target-ip >> ~/.ssh/known_hosts
```

### Verification Commands

```bash
# Check Ansible version
ansible --version

# List all hosts in inventory
ansible -i inventory.ini --list-hosts all

# Test connection to specific group
ansible -i inventory.ini linux_servers -m ping

# Check Ansible configuration
ansible-config dump
```

## Next Steps

With Ansible successfully set up, you can now explore advanced features:

### Recommended Learning Path
1. **Ansible Playbooks** - Create YAML files for complex automation tasks
2. **Ansible Roles** - Organize your automation code into reusable components
3. **Ansible Vault** - Secure sensitive data like passwords and keys
4. **Ansible Galaxy** - Use community-contributed roles and collections
5. **Ansible AWX/Tower** - Web-based interface for Ansible automation

### Sample Playbook Creation

Create your first playbook:

```bash
nano first-playbook.yml
```

```yaml
---
- name: My First Playbook
  hosts: linux_servers
  tasks:
    - name: Ensure a package is installed
      apt:
        name: htop
        state: present
      become: yes
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini first-playbook.yml
```

## Conclusion

You have successfully:
- Installed Ansible on a Linux control node
- Configured SSH key-based authentication
- Created an inventory file for target machines
- Verified connectivity using ping module
- Executed ad-hoc commands across your infrastructure
