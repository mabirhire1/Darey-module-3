# Ansible Linux Server Backup and Restore

Data backup and restoration are essential practises for ensuringdata safety and continuity in Linux server management.This project demonstrates how to create scalable and repeatable backup solutions through Ansible playbooks.

## Project Structure

```
ansible-backup-restore/
├── README.md
├── inventory.ini
├── backup.yml
├── restore.yml
```

## Objectives

- Understand the basics of Ansible and its role in automation.
- Set up an Ansible environment for managing Linux servers.
- SSH key-based authentication setup
- Create a playbook to back up files to a remote or local directory.
- Develop a playbook to restore files from a backup.
- Test and verify backup and restore processes.

## Prerequisites

Before starting, ensure you have:

- **Linux Servers** At least one Linux server to act as the target machine and optional control machine for Ansible
- **Ansible Installed:** Ansible installed on the the control machine if not already installed. See [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for installation guide.
- **Network Access:** SSH connectivity between control machine and target servers
SSH Access: OpenSSH client and server
- **Sudo Privileges:** Administrative access on target servers
- **Text Editor:** For creating and editing Ansible playbooks

## Tasks Outline

- Install and configure Ansible on the control machine.

- Set up an inventory file for the target Linux server.

- Create an Ansible playbook to back up files.

- Create an Ansible playbook to restore files from a backup.

- Test the backup and restore functionality.


## Project Task

### Step 1: Install Ansible on Control Machine

For Ubuntu/Debian systems:
```bash
sudo apt update
sudo apt install ansible -y
```

For RHEL/CentOS systems:
```bash
sudo yum install epel-release -y
sudo yum install ansible -y
```

### Step 2: Verify Ansible Installation

```bash
ansible --version
```
**Output**
ansible [core 2.16.3]
 
### Step 3: Set Up SSH Key Authentication

Generate SSH key pair:
```bash
ssh-keygen -t rsa
```
**Output**
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):

Copy public key to target server:
```bash
ssh-copy-id user@target-server-ip
```

Test SSH connection:
```bash
ssh user@target-server-ip
```
**Output**
The authenticity of host '54.227.110.10 (54.227.110.10)' can't be established.
ED25519 key fingerprint is SHA*************************.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:87: [hashed name]
    ~/.ssh/known_hosts:88: [hashed name]
    
## Configuration

### Step 1: Create Ansible Inventory File

Create `inventory.ini`:
```bash
nano inventory.ini
```

Add target server details:
```ini
[linux_servers]
target ansible_host=<target-server-ip> ansible_user=<user>
```

Replace `<target-server-ip>` and `<user>` with actual values.

### Step 2: Test Inventory Connection

```bash
ansible -i inventory.ini linux_servers -m ping
```
**Output**
target | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

## Usage

### Creating Backup Playbook

Create `backup.yml`:
```bash
nano backup.yml
```

Add the following content:
```yaml
- name: Backup files on the server
  hosts: linux_servers
  tasks:
    - name: Create backup directory
      file:
        path: /backup
        state: directory
        mode: '0755'

    - name: Copy files to backup directory
      copy:
        src: /path/to/files
        dest: /backup/
        remote_src: yes
```

**Important:** Replace `/path/to/files` with the actual path of files you want to backup.

### Creating Restore Playbook

Create `restore.yml`:
```bash
nano restore.yml
```

Add the following content:
```yaml
- name: Restore files from backup
  hosts: linux_servers
  become: yes
  tasks:
    - name: Stop nginx service during restore
      systemd:
        name: nginx
        state: stopped

    - name: Restore website files from backup
      copy:
        src: /backup/
        dest: /path/to/files
        remote_src: yes
        backup: yes
        owner: www-data
        group: www-data
        mode: preserve
```

**Important:** Replace `/path/to/files` with the original file location.

### Running the Playbooks

Execute backup operation:
```bash
ansible-playbook -i inventory.ini backup.yml
```

Execute restore operation:
```bash
ansible-playbook -i inventory.ini restore.yml
```

## Testing

### Step 1: Run Backup Process

Execute the backup playbook:
```bash
ansible-playbook -i inventory.ini backup.yml
```

### Step 2: Verify Backup Creation

Check backup directory on target server:
```bash
ls /backup
```

Or remotely via Ansible:
```bash
ansible -i inventory.ini linux_servers -m shell -a "ls -la /backup"
```

### Step 3: Test Restore Process

Run the restore playbook:
```bash
ansible-playbook -i inventory.ini restore.yml
```

### Step 4: Verify Restore Success

Check restored files in original location:
```bash
ls /path/to/files
```

Or remotely via Ansible:
```bash
ansible -i inventory.ini linux_servers -m shell -a "ls -la /path/to/files"
```

### File Descriptions

- **inventory.ini**: Defines target servers and connection parameters
- **backup.yml**: Ansible playbook for backup operations
- **restore.yml**: Ansible playbook for restore operations
- **ansible.cfg**: Optional Ansible configuration file

## Troubleshooting

### Common Issues and Solutions

#### SSH Connection Failed
```bash
# Test SSH connectivity
ssh -v user@target-server-ip

# Regenerate and copy SSH keys
ssh-keygen -t rsa -f ~/.ssh/id_rsa
ssh-copy-id user@target-server-ip
```

#### Permission Denied Errors
```bash
# Add become: yes to playbook tasks
- name: Create backup directory
  file:
    path: /backup
    state: directory
    mode: '0755'
  become: yes
```

#### Inventory Not Found
```bash
# Use absolute path for inventory
ansible-playbook -i /full/path/to/inventory.ini backup.yml
```

#### File Path Does Not Exist
- Verify source paths exist on target servers
- Use `ansible -m shell -a "ls -la /path"` to check paths
- Ensure proper permissions on source directories

### Debug Mode

Run playbooks in verbose mode for detailed output:
```bash
ansible-playbook -i inventory.ini backup.yml -vvv
```

## Advanced Features

### Multiple Server Support

Add multiple servers to inventory:
```ini
[linux_servers]
server1 ansible_host=54.227.110.10 ansible_user=admin
server2 ansible_host=54.227.110.11 ansible_user=admin
```

### Scheduled Backups

Create cron job for automated backups:
```bash
# Add to crontab
0 2 * * * /usr/bin/ansible-playbook -i /path/to/inventory.ini /path/to/backup.yml
```

### Compression Support

Add compression to backup tasks:
```yaml
- name: Create compressed backup
  archive:
    path: /path/to/files
    dest: /backup/backup_{{ ansible_date_time.date }}.tar.gz
    format: gz
```

## Security Considerations

- Use dedicated backup user accounts with minimal privileges
- Implement proper file permissions (0755 for directories, 0644 for files)
- Consider encrypting sensitive backup data
- Regularly rotate SSH keys
- Monitor backup operations through logging
