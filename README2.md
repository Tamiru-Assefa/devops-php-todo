STEP 1 — Initialize Swarm (on Manager)

Run this on ETH-North-Manager:

docker swarm init

👉 Output will give you a join token

🚀 STEP 2 — Join Worker Nodes

On ETH-WEST-worker1 and ETH-Addis-worker2:

docker swarm join --token <TOKEN> <MANAGER-IP>:2377
✅ Verify cluster

On manager:

docker node ls

You should see 3 nodes:

1 manager
2 workers
🚀 STEP 3 — Rename Nodes (IMPORTANT 🔥)

By default names are ugly — fix them:

docker node update --hostname ETH-North-Manager <NODE-ID>
docker node update --hostname ETH-WEST-worker1 <NODE-ID>
docker node update --hostname ETH-Addis-worker2 <NODE-ID>

ATTACH LABLE
docker node update --label-add role=web ETH-WEST-worker1
docker node update --label-add role=web ETH-Addis-worker2
docker node update --label-add role=manager ETH-North-Manager

------------------------

version: "3.8"

services:

  web:
    image: yourdockerhubusername/php-todo:${IMAGE_TAG}
    ports:
      - "8080:80"
    networks:
      - app-network

    deploy:
      replicas: 2

      resources:
        limits:
          cpus: "0.50"
          memory: 512M

      restart_policy:
        condition: on-failure

      placement:
        constraints:
          - node.labels.role == web

      labels:
        - "app=todo"
        - "tier=frontend"

      update_config:
        parallelism: 1    # Update ONE container at a time then wait 10sec
        delay: 10s
        order: start-first          # Start NEW container first
        failure_action: rollback    # If New Container fail rollback

      rollback_config:
        parallelism: 1       # RollBack 1 container at a time
        delay: 5s

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"] #opening website from terminal
      interval: 30s
      timeout: 10s
      retries: 3


  db:
    image: mysql:5.7

    environment:
      MYSQL_DATABASE: todo
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql_root_password
      

    secrets:
    - mysql_root_password
    - mysql_user
    - mysql_password
       

    volumes:
      - db-data:/var/lib/mysql

    networks:
      - app-network

    deploy:
      replicas: 1

      resources:
        limits:
          cpus: "0.50"
          memory: 512M

      restart_policy:
        condition: on-failure

      placement:
        constraints:
          - node.labels.role == db

      labels:
        - "app=todo"
        - "tier=backend"

      update_config:
        parallelism: 1
        delay: 10s

    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"] #Ask MySQL server: are you alive?
      interval: 30s
      timeout: 10s
      retries: 5


networks:
  app-network:
    driver: overlay


volumes:
  db-data:

secrets:
  mysql_root_password:
    external: true
  mysql_user:
    external: true
  mysql_password:
    external: true


----------

🧾 Example Jenkinsfile
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'yourdockerhubusername/php-todo' 
        IMAGE_TAG = "${BUILD_NUMBER}" 
        SERVICE_NAME = "todo-app_web"
    }

    stages {

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Deploy to Swarm') {
            steps {
                sh '''
                export IMAGE_TAG=${BUILD_NUMBER}
                docker stack deploy -c docker-stack.yml todo-app
                '''
            }
        }
    }
}

--------------------
🚀 STEP 1 — Create secrets in Swarm

Run this on manager node:

echo "rootPassword123" | docker secret create mysql_root_password -


Verify
docker secret ls

-------------------------


Swarm-ready monitoring stack with:

✅ Prometheus (metrics collection)
✅ Grafana (visualization dashboard)
✅ cAdvisor (container metrics)

| Tool       | URL                       |
| ---------- | ------------------------- |
| Prometheus | http://<MANAGER-IP>:9090  |
| Grafana    | http://<MANAGER-IP>:3000  |
| cAdvisor   | http://<ANY-NODE-IP>:8082 |

docker stack deploy -c monitoring-stack.yml monitoring