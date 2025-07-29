# Automate User Creation on Linux Server using Ansible

This project demonstrates how to automate user account creation on Linux servers using Ansible playbooks. The automation simplifies user management across multiple servers and eliminates the tedious manual process of creating user accounts.

### Key Features

- Batch user creation across multiple servers
- Automated SSH key deployment
- Group membership management
- Home directory configuration
- Shell assignment
- Verification and testing procedures

## Prerequisites

- **Linux Servers**: At least one Linux server to act as the target machine and optional control machine for Ansible. 
- **Network Access**: SSH connectivity between control and target machines public key authentication.
- **Ansible**: Latest version installed on control machine
- **SSH**: OpenSSH client and server
- **Text Editor**: For creating and editing playbooks

### Access Requirements
- **SSH Access**: Key-based authentication between machines
- **Sudo Privileges**: On target servers for user management
- **Public SSH Keys**: For users being created

## Project Structure

```
ansible-user-automation/
├── README.md
├── inventory.ini
├── create_users.yml
├── ssh_keys/
│   ├── user1.pub
│   └── user2.pub
└── group_vars/
    └── all.yml
```

## Installation & Setup

### Step 1: Install Ansible

#### On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install ansible -y
```

#### Verify Installation:
```bash
ansible --version
```

### Step 2: Configure SSH Key Authentication

#### Generate SSH Key Pair:
```bash
ssh-keygen -t rsa -b 4096 -C "ansible-automation"
```

#### Copy Public Key to Target Servers:
```bash
ssh-copy-id user@target-server-ip
```

#### Test SSH Connection:
```bash
ssh user@target-server-ip
```

## Implementation Steps

### Step 1: Create Inventory File

Create `inventory.ini` to define target servers:

```ini
[linux_servers]
target ansible_host=target-server-ip ansible_user=user

# Example with multiple servers
[linux_servers]
server1 ansible_host=192.168.1.10 ansible_user=admin
server2 ansible_host=192.168.1.11 ansible_user=admin
server3 ansible_host=192.168.1.12 ansible_user=admin
```

### Step 2: Basic User Creation Playbook

Create `create_users.yml` for basic user creation:

```yaml
---
- name: Automate user creation
  hosts: linux_servers
  become: yes
  tasks:
    - name: Create a new user
      user:
        name: "{{ item.username }}"
        state: present
        shell: /bin/bash
        create_home: yes
      with_items:
        - { username: "user1" }
        - { username: "user2" }
```

### Step 3: Advanced User Configuration

Update the playbook with additional settings:

```yaml
---
- name: Automate user creation
  hosts: linux_servers
  become: yes
  tasks:
    - name: Create a new user with additional settings
      user:
        name: "{{ item.username }}"
        state: present
        shell: /bin/bash
        create_home: yes
        groups: "{{ item.groups }}"
      with_items:
        - { username: "user1", groups: "sudo" }
        - { username: "user2", groups: "docker" }

    - name: Add SSH key for the users
      authorized_key:
        user: "{{ item.username }}"
        state: present
        key: "{{ lookup('file', item.ssh_key) }}"
      with_items:
        - { username: "user1", ssh_key: "/path/to/user1.pub" }
        - { username: "user2", ssh_key: "/path/to/user2.pub" }
```

### Step 4: Prepare SSH Keys

1. **Create SSH keys directory**:
   ```bash
   mkdir ssh_keys
   ```

2. **Generate or copy user SSH keys**:
   ```bash
   # Generate new keys for users
   ssh-keygen -t rsa -f ssh_keys/user1 -C "user1@company.com"
   ssh-keygen -t rsa -f ssh_keys/user2 -C "user2@company.com"
   ```

3. **Update playbook paths**:
   ```yaml
   with_items:
     - { username: "user1", ssh_key: "ssh_keys/user1.pub" }
     - { username: "user2", ssh_key: "ssh_keys/user2.pub" }
   ```

## Usage

### Execute the Playbook

#### Dry Run (Check Mode):
```bash
ansible-playbook -i inventory.ini create_users.yml --check
```

#### Execute Playbook:
```bash
ansible-playbook -i inventory.ini create_users.yml
```

#### Execute with Verbose Output:
```bash
ansible-playbook -i inventory.ini create_users.yml -v
```

#### Execute on Specific Hosts:
```bash
ansible-playbook -i inventory.ini create_users.yml --limit server1
```

### Sample Output

```
PLAY [Automate user creation] **************************************************

TASK [Gathering Facts] *********************************************************
ok: [target]

TASK [Create a new user with additional settings] *****************************
changed: [target] => (item={'username': 'user1', 'groups': 'sudo'})
changed: [target] => (item={'username': 'user2', 'groups': 'docker'})

TASK [Add SSH key for the users] ***********************************************
changed: [target] => (item={'username': 'user1', 'ssh_key': 'ssh_keys/user1.pub'})
changed: [target] => (item={'username': 'user2', 'ssh_key': 'ssh_keys/user2.pub'})

PLAY RECAP *********************************************************************
target                     : ok=3    changed=2    unreachable=0    failed=0
```

## Verification

### Step 1: Verify User Creation

Check if users were created on target servers:

```bash
# Check /etc/passwd for new users
cat /etc/passwd | grep -E "user1|user2"

# List home directories
ls -la /home/

# Check user details
id user1
id user2
```

### Step 2: Verify Group Membership

```bash
# Check group membership
groups user1
groups user2

# Verify sudo access (if applicable)
sudo -l -U user1
```

### Step 3: Test SSH Access

```bash
# Test SSH login with created users
ssh -i ssh_keys/user1 user1@target-server-ip
ssh -i ssh_keys/user2 user2@target-server-ip
```

### Step 4: Verify Home Directory

```bash
# Check home directory contents
ls -la /home/user1/
ls -la /home/user2/

# Verify SSH authorized_keys
cat /home/user1/.ssh/authorized_keys
cat /home/user2/.ssh/authorized_keys
```

## Troubleshooting

### Common Issues and Solutions

#### 1. SSH Connection Failed
```bash
# Error: Permission denied (publickey)
# Solution: Verify SSH key authentication
ssh-copy-id user@target-server-ip
```

#### 2. Ansible Host Unreachable
```bash
# Error: UNREACHABLE! => {"changed": false, "msg": "Failed to connect"}
# Solution: Check inventory file and network connectivity
ansible -i inventory.ini linux_servers -m ping
```

#### 3. Permission Denied for User Creation
```bash
# Error: Failed to create user
# Solution: Ensure 'become: yes' is set and user has sudo privileges
```

#### 4. SSH Key Not Found
```bash
# Error: Could not find or access 'ssh_keys/user1.pub'
# Solution: Verify file path and permissions
ls -la ssh_keys/
chmod 644 ssh_keys/*.pub
```

### Debug Commands

```bash
# Test inventory connectivity
ansible -i inventory.ini linux_servers -m ping

# Check facts gathering
ansible -i inventory.ini linux_servers -m setup

# Test with increased verbosity
ansible-playbook -i inventory.ini create_users.yml -vvv
```

view Ansible documentation at [docs.ansible.com](https://docs.ansible.com)
