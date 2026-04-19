# Server Setup (Docker Swarm + Jenkins Environment)

This guide explains how to set up a fresh Linux environment for Project 2, which includes:
- Docker Swarm Cluster (Manager + Workers)
- Jenkins CI/CD Pipeline
- Docker Registry access (Docker Hub)
- Monitoring Stack (Prometheus, Grafana, cAdvisor)
- Docker Secrets support

📌 OS: Ubuntu / Debian-based Linux

### 1. EC2 CREATION (VERY IMPORTANT ORDER)

You start by creating 3 EC2 instances:

ETH-North-Manager   → Swarm Manager
ETH-WEST-worker1    → Worker Node 1
ETH-Addis-worker2   → Worker Node 2

** ⚙️ EC2 Configuration (ALL 3 INSTANCES) **
When creating each EC2:

🧠 Basic Settings
- AMI: Ubuntu 22.04 LTS
- Instance type: t2.micro / t3.micro
- Key pair: PuTTY (.ppk)
- Network: Default VPC
- Subnet: Default subnet
- Auto-assign Public IP: YES
- 🔐 Security Group (IMPORTANT)

Create ONE security group and attach to all 3:

  SSH (22)        → Your IP
  HTTP (8080)     → Anywhere
  Grafana (3000)  → Your IP
  Prometheus (9090) → Your IP
  Visualizer (8081) → Your IP
  cAdvisor (8082)   → Your IP


Swarm:
2377, 7946, 4789 → All nodes (SG-to-SG allowed)

---
### Environment SetUp
ALL NODES (Manager + Workers)

We install:

✔ Docker Engine

✔ Docker Compose plugin

✔ Basic tools (git, curl)


 MANAGER NODE ONLY
✔ docker swarm init

✔ Jenkins

✔ Docker secrets creation

✔ Monitoring stack (Prometheus, Grafana, Visualizer)

✔ Stack deployment control

 Manager = brain of cluster

 WORKER NODES ONLY
 
✔ Docker Engine only

✔ Join Swarm cluster

✔ Run containers (PHP app replicas)

---
### (BOTH NODE)
#### 1. Update System 
`sudo apt update`

`sudo apt upgrade -y`

#### 🧰 2. Install Base Tools
`sudo apt install git curl apt-transport-https ca-certificates software-properties-common -y`

#### 🐳 3. Install Docker Engine
`sudo apt install docker.io -y`

Enable Docker:
```
sudo systemctl enable docker
sudo systemctl start docker
```

Verify:
`docker --version`

#### 🔐 4. Allow Docker Without Sudo
```
sudo usermod -aG docker $USER
newgrp docker
```

Test:
`docker run hello-world`

#### 🧩 5. Install Docker Compose Plugin
`sudo apt install docker-compose-plugin -y`

Verify:
`docker compose version`

### ON MANAGER NODE
#### ☕ 6. Install Java (Required for Jenkins)
`sudo apt install openjdk-17-jdk -y`

Verify:
`java -version`

#### 🤖 7. Install Jenkins
Add Jenkins repository key:
```
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
Add Jenkins repo:
```
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
```
Install Jenkins:
```
sudo apt update
sudo apt install jenkins -y
```

#### 🚀 8. Start Jenkins
```
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

Check status:
`sudo systemctl status jenkins`

#### 🌐 9. Access Jenkins

Open in browser:
*http://SERVER-IP:8080*

Get admin password:

`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

**Install Suggested Plugins.**

#### 🐳 10. Enable Jenkins Docker Access
```
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins`
```

#### 🧠 11. Initialize Docker Swarm (IMPORTANT)
On Manager Node only:

`docker swarm init`

Join Worker Nodes:

Copy token from manager:

`docker swarm join --token <TOKEN> <MANAGER-IP>:2377`

#### 🏷️ 12. Node Labeling (Swarm Structure Setup)
By default names are ugly — fix them:

`docker node update --hostname ETH-North-Manager <NODE-ID>`

`docker node update --hostname ETH-WEST-worker1 <NODE-ID>`

`docker node update --hostname ETH-Addis-worker2 <NODE-ID>`

UPDATE THE LABEL

`docker node update --label-add role=manager ETH-North-Manager`

`docker node update --label-add role=web ETH-WEST-worker1`

`docker node update --label-add role=web ETH-Addis-worker2`

#### 14. CREATE DOCKER SECRETS (SECURITY LAYER)

On Manager Node only:

`echo "rootpassword" | docker secret create mysql_root_password -`

`echo "tamea" | docker secret create mysql_user -`

`echo "password123" | docker secret create mysql_password -`

 *This replaces .env passwords in production*


 #### 15. DOCKER HUB LOGIN (ON MANAGER NODE)

Before CI/CD works, login once manually on the Manager Node:

`docker login -u yourdockerhubusername`

👉 This stores credentials so Jenkins can push images.

#### 🤖 16. SETUP JENKINS PIPELINE JOB

Now go to Jenkins:  
*http://SERVER-IP:8080*

🧩 Create Pipeline Job

Steps:

Click New Item

Name: *todo-swarm-pipeline*

Select: *Pipeline*

Click OK



⚙️ Pipeline Configuration

In Pipeline section:

Definition: *Pipeline script from SCM*

SCM: *Git*

Repo URL: ** your GitHub repo (https://github.com/Tamiru-Assefa/devops-php-todo.git) **

Script Path:

jenkins/Jenkinsfile

🧠 17. JENKINSFILE (WHAT IT DOES)

Your pipeline does:

1. Build Docker Image
2. Tag with BUILD_NUMBER
3. Push to Docker Hub
4. Deploy Stack to Swarm
🚀 18. RUN PIPELINE

Click:

Build Now
🔄 19. WHAT HAPPENS AFTER RUNNING JENKINS

Jenkins automatically executes:

✔ docker build
✔ docker push
✔ docker stack deploy
📊 20. VERIFY DEPLOYMENT (IMPORTANT STEP)

Run these on Manager Node:

🧩 Check Swarm Nodes
docker node ls
🧩 Check Services
docker service ls
🧩 Check Running Containers
docker service ps todo-app_web
docker service ps todo-app_db
🧩 Check Stack
docker stack services todo-app
🌐 21. APPLICATION ACCESS
http://<ANY-NODE-IP>:8080

### Some rivision on docker stack yml and jenkins pipeline file
explaining docker-stack.yml file.

📦 Image Versioning (CI/CD Integration)
image: yourdockerhubusername/php-todo:${IMAGE_TAG}
🧠 Explanation:
The IMAGE_TAG is passed from the Jenkins pipeline
It is dynamically set using the Jenkins build number
This allows every build to produce a unique versioned Docker image

👉 Example:

Build #15 → php-todo:15
Build #16 → php-todo:16

✔ This enables:

version tracking
rollback capability
CI/CD traceability
🔁 Replicas (Scalability)
replicas: 2
🧠 Explanation:
Runs 2 identical containers of the PHP web app
Containers are distributed across worker nodes
Provides:
load balancing
high availability
fault tolerance

👉 If one container fails, the other continues serving traffic.

⚙️ Resource Limits (Stability Control)
resources:
  limits:
    cpus: "0.50"
    memory: 512M
🧠 Explanation:
Restricts container resource usage
Prevents a single container from consuming all node resources

✔ Benefits:

avoids system overload
improves cluster stability
ensures fair resource sharing
🔄 Restart Policy (Self-Healing)
restart_policy:
  condition: on-failure
🧠 Explanation:
Automatically restarts container if it crashes
Helps maintain service uptime

✔ Example:

PHP crash → container automatically restarted by Swarm
📍 Placement Constraints (Node Targeting)
placement:
  constraints:
    - node.labels.role == web
🧠 Explanation:
Ensures the service runs ONLY on nodes labeled as web
Used to separate responsibilities across cluster nodes

👉 Example:

worker1 → web containers
worker2 → web containers
manager → not used for web service

✔ This gives:

better control
structured cluster design
workload separation
🏷️ Service Labels (Metadata)
labels:
  - "app=todo"
  - "tier=frontend"
🧠 Explanation:
Adds metadata to the service
Used for:
monitoring (Prometheus/Grafana)
service identification
observability tools

👉 Example:

app=todo → identifies application
tier=frontend → identifies layer
🚀 Rolling Updates (Zero Downtime Deployment)
update_config:
  parallelism: 1
  delay: 10s
  order: start-first
  failure_action: rollback
🧠 Explanation:
parallelism: 1
→ updates one container at a time
delay: 10s
→ waits between updates
order: start-first
→ starts new container before stopping old one
failure_action: rollback
→ automatically reverts if update fails

✔ This ensures:

zero downtime deployment
safe production updates
automatic recovery
🔁 Rollback Configuration
rollback_config:
  parallelism: 1
  delay: 5s
🧠 Explanation:
If deployment fails, Swarm restores previous version
Rollback happens gradually (one container at a time)

✔ This prevents:

full system failure
broken deployments going live
❤️ Health Check (Service Monitoring)
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
🧠 Explanation:
curl -f http://localhost
→ checks if the web app is responding
interval: 30s
→ runs check every 30 seconds
timeout: 10s
→ max time allowed for response
retries: 3
→ fails only after 3 unsuccessful attempts

✔ This enables:

automatic container health detection
restart of unhealthy services
improved reliability


----- 
explains how the Jenkins pipeline is configured to build, tag, and deploy the Docker Swarm application.

⚙️ Environment Variables
environment {
    IMAGE_NAME = 'yourdockerhubusername/php-todo'
    IMAGE_TAG = "${BUILD_NUMBER}"
    SERVICE_NAME = "todo-app_web"
}
🧠 Explanation:
IMAGE_NAME
→ Defines the Docker Hub repository name where the image will be stored

IMAGE_TAG
→ Uses Jenkins built-in variable ${BUILD_NUMBER} to version each image automatically
→ Every Jenkins build generates a unique tag

👉 Example:

Build #1 → php-todo:1
Build #2 → php-todo:2
SERVICE_NAME
→ Defines the Swarm service name (used for reference or future updates)

✔ This setup enables:

automatic versioning
traceable deployments
clean CI/CD pipeline structure
🏗️ Docker Build Stage
docker build -t $IMAGE_NAME:$IMAGE_TAG .
🧠 Explanation:
Builds Docker image from the project directory
Tags the image using:
repository name (IMAGE_NAME)
build number (IMAGE_TAG)

👉 Result:

yourdockerhubusername/php-todo:5

✔ This ensures:

every build creates a unique version
no overwriting of previous images
📤 Deployment Stage (Swarm Stack)
export IMAGE_TAG=${BUILD_NUMBER}
docker stack deploy -c docker-stack.yml todo-app
🧠 Explanation:
export IMAGE_TAG=${BUILD_NUMBER}
→ passes the Jenkins build number into the stack file dynamically
docker stack deploy
→ deploys the entire application as a Swarm stack
todo-app
→ name of the stack (group of services)
🧠 What happens during deployment:

When this command runs:

Jenkins → passes IMAGE_TAG
        → Swarm reads docker-stack.yml
        → pulls correct image version
        → updates services
        → restarts containers if needed
🔄 GitHub Integration (Trigger Flow)

When code is pushed to GitHub:

GitHub push → Jenkins webhook (or polling)
             → Jenkins pipeline starts
             → Docker image built
             → Image pushed to registry
             → Swarm stack deployed

✔ This ensures:

fully automated CI/CD
no manual deployment required
continuous delivery workflow

