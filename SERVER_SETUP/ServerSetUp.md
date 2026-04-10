# Server Setup (Fresh Linux Machine)

This section explains how to deploy the project on a fresh Linux server.
The following tools will be installed:

- Docker
- Docker Compose
- Jenkins
- Git
- OpenSSH

These steps assume an Ubuntu/Debian-based system.

### 1. Update the System

Update package lists and upgrade installed packages.

` sudo apt update`
`sudo apt upgrade -y `

### 2. Install Base Tools

Install Git and required utilities.

`sudo apt install git curl apt-transport-https ca-certificates software-properties-common -y`

### 3. Install Docker

Install Docker engine.

`sudo apt install docker.io -y`

Start and enable Docker service.

`sudo systemctl enable docker`
`sudo systemctl start docker`

Verify installation.

`docker --version`

### 4. Allow User to Run Docker

Add the current user to the Docker group.

`sudo usermod -aG docker $USER`
`newgrp docker`

Test Docker.

`docker run hello-world`

### 5. Install Docker Compose

Install Docker Compose plugin.

`sudo apt install docker-compose-plugin -y`

Verify installation.

`docker compose version`

### 6. Install Jenkins

Jenkins requires Java.

Install Java.

`sudo apt install openjdk-17-jdk -y`

Verify Java installation.

```java -version
Add Jenkins Repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null```

Update packages.

`sudo apt update`

Install Jenkins.

`sudo apt install jenkins -y`

### 7. Start Jenkins

Enable and start Jenkins service.

`sudo systemctl enable jenkins`
`sudo systemctl start jenkins`

Check Jenkins status.

`sudo systemctl status jenkins`

### 8. Access Jenkins

Open Jenkins in a browser.

http://SERVER-IP:8080

Get the initial admin password.

`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

Paste this password in the Jenkins setup page and install Suggested Plugins.

### 9. Allow Jenkins to Use Docker

Add Jenkins user to the Docker group.

`sudo usermod -aG docker jenkins`

Restart Jenkins.

`sudo systemctl restart jenkins
`
### 10. Login to Docker Hub (One Time)

Login once on the server.

`docker login -u ybtamiru
`
After login, Jenkins will be able to push Docker images automatically.

### 11. Create Jenkins Freestyle Job

Inside Jenkins:

Click New Item
Select Freestyle Project
Enter a name (example: php-todo-cicd)

### 12. Configure Git Repository

In Jenkins:

Source Code Management → Git

Add your repository URL.

https://github.com/YOUR_USERNAME/devops-php-todo.git

### 13. Add Build Commands

Add a build step:

Execute Shell

Add the following commands.

`docker build -t ybtamiru/php-todo-app:latest -f Dockerfile .
`
`docker push ybtamiru/php-todo-app:latest
`
`docker compose pull
``docker compose up -d
`
These commands:

Build the Docker image
Push the image to Docker Hub
Deploy containers using Docker Compose

### 14. Run the Jenkins Pipeline

Click Build Now in Jenkins.

The pipeline will:

Pull code from GitHub
Build Docker image
Push image to Docker Hub
Deploy containers on the server

### 15. Access the Application

After deployment:

Application:

http://SERVER-IP

Jenkins:

http://SERVER-IP:8080
Deployment Architecture
Developer
   │
   ▼
GitHub
   │
   ▼
Jenkins CI/CD
   │
   ├ Build Docker Image
   ├ Push Image to Docker Hub
   │
   ▼
Docker Compose Deployment
   │
   ├ PHP Apache Container
   └ MySQL Database Container