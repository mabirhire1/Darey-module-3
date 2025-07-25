# Jenkins CI/CD Learning Path

## Introduction to CI/CD

**Continuous Integration and Continuous Delivery (CI/CD)** are best practices that automate the software development lifecycle. CI/CD enhances efficiency, stability, and deployment speed by enabling frequent code integration, automated testing, and reliable deployment pipelines [[1]][[5]].

---

## What is Jenkins?

**Jenkins** is an open-source automation server that automates building, testing, and deploying applications. It supports pipelines to define entire workflows, integrates with version control systems for automatic builds, and offers an extensive plugin ecosystem for customization.

---

## Installation Guide

### Prerequisites

- Completed foundational programs 1-3
- System with JDK installed

### Installation Steps

1. **Update package repositories:**
    ```bash
    sudo apt-get update
    ```

2. **Install JDK:**
    ```bash
    sudo apt-get install default-jdk
    ```

3. **Add Jenkins repository and install:**
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    ```

4. **Verify installation:**
    ```bash
    sudo systemctl status jenkins
    ```
![Jenkins status](img/image.png)

5. **Create Inbound rules for security group:**

![Inbound rules](img/image1.png)

6. **Access Jenkins web console:**
    ```
    http://<public-ip>:8080
    ```

7. **Retrieve initial admin password:**
    ```bash
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```
![Unlock jenkins](img/image2.png)

![Retrieve password](img/image3.png)
---

## Project Goals

By completing this learning path, you will:

- Understand CI/CD principles and their benefits
- Install and configure Jenkins
- Create and manage Jenkins jobs
- Automate software builds and tests
- Implement deployment pipelines
- Integrate with version control systems

---

## Getting Started with Jenkins

### Initial Setup

1. **Install required plugins:**
    - Navigate to **Manage Jenkins > Plugins**
    - Install suggested plugins or select specific ones

![Customize Jenkins](img/image4.png)

2. **Create admin user:**
    - Set up credentials after initial login

![Create User](img/image5.png)

3. **Configure security:**
    - Set up appropriate security groups
    - Ensure port 8080 is accessible

---
![Jenkins Dashboard](image6.png)

### Basic Operations

- **Create your first job:**
    - Go to **New Item > Enter name > Select "Freestyle project"**
    - Configure source code management (Git, SVN)
    - Set build triggers
    - Add build steps (shell commands, etc.)

- **Pipeline creation:**
    - Define a `Jenkinsfile` with stages
    - Configure build, test, and deploy steps

---

## Common Tasks Checklist

- [ ] Install Jenkins
- [ ] Configure security settings
- [ ] Install necessary plugins
- [ ] Create admin user account
- [ ] Connect to version control
- [ ] Create first build job
- [ ] Test pipeline execution
- [ ] Configure deployment steps

---

## Troubleshooting

- **Port conflicts:** Change Jenkins port in `/etc/default/jenkins`
- **Connection issues:** Verify security group rules
- **Plugin errors:** Check compatibility and versions
- **Build failures:** Review console output for errors

---