Server Setup (Fresh Linux Machine)

This guide explains how to deploy the project on a fresh Linux server.

The following tools will be installed:

Docker
Docker Compose
Jenkins
Git
OpenSSH

These instructions assume an Ubuntu/Debian-based system.

1. Update the System

Update package lists and upgrade existing packages.

sudo apt update
sudo apt upgrade -y
2. Install Base Tools

Install Git and required utilities.

sudo apt install git curl apt-transport-https ca-certificates software-properties-common -y
3. Install Docker

Install Docker Engine.

sudo apt install docker.io -y

Enable and start Docker service.

sudo systemctl enable docker
sudo systemctl start docker

Verify Docker installation.

docker --version
4. Allow User to Run Docker

Add the current user to the Docker group so Docker commands can run without sudo.

sudo usermod -aG docker $USER
newgrp docker

Test Docker.

docker run hello-world
5. Install Docker Compose

Install Docker Compose plugin.

sudo apt install docker-compose-plugin -y

Verify installation.

docker compose version
6. Install Jenkins

Jenkins requires Java.

Install Java:

sudo apt install openjdk-17-jdk -y

Verify Java installation.

java -version
Add Jenkins Repository

Add the Jenkins repository key.

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null

Add Jenkins repository.

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

Update package list again.

sudo apt update

Install Jenkins.

sudo apt install jenkins -y
7. Start Jenkins

Enable and start Jenkins service.

sudo systemctl enable jenkins
sudo systemctl start jenkins

Check Jenkins status.

sudo systemctl status jenkins
8. Access Jenkins

Open Jenkins in your browser.

http://SERVER-IP:8080

Retrieve the initial admin password.

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Paste the password into the Jenkins setup page and install Suggested Plugins.

9. Allow Jenkins to Use Docker

Add the Jenkins user to the Docker group.

sudo usermod -aG docker jenkins

Restart Jenkins.

sudo systemctl restart jenkins
10. Login to Docker Hub (One Time)

Login once on the server.

docker login -u ybtamiru

After logging in, credentials are stored locally so Jenkins can push Docker images automatically.

11. Create Jenkins Freestyle Job

Inside Jenkins:

Click New Item
Select Freestyle Project
Enter a name

Example:

php-todo-cicd
12. Configure Git Repository

Inside Jenkins configuration:

Source Code Management → Git

Add your repository URL.

https://github.com/YOUR_USERNAME/devops-php-todo.git
13. Add Build Commands

Add a Build Step → Execute Shell.

Insert the following commands:

docker build -t ybtamiru/php-todo-app:latest -f Dockerfile .

docker push ybtamiru/php-todo-app:latest

docker compose pull
docker compose up -d

These commands will:

Build the Docker image
Push the image to Docker Hub
Deploy the containers using Docker Compose
14. Run the Jenkins Pipeline

Click Build Now in Jenkins.

The pipeline will:

Pull code from GitHub
Build Docker image
Push image to Docker Hub
Deploy containers on the server
15. Access the Application

After deployment:

Application:

http://SERVER-IP

Jenkins dashboard:

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
