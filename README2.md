# 📌 Project Overview

This project is a **PHP-based To-Do List Manager** that allows users to:

- Add new tasks  
- Update tasks  
- Mark tasks as completed  
- Track task status  
- Delete tasks  

---

# 🚀 Deployment Journey

The main goal of this project is to demonstrate **DevOps practices** by deploying the same application in two different ways:

---

## 🐳 Project 1 — Docker Compose + Jenkins (Freestyle)

In the first deployment, the application is containerized and deployed using:

- Dockerfile (build application image)  
- Docker Compose (multi-container setup: app + MySQL)  
- Jenkins Freestyle Job (basic CI/CD)  

### Key Features:
- Volumes (data persistence)  
- Networks (container communication)  
- `.env` (environment variables)  

📄 Setup & details:  
- `README1Jenkins-docker-compose.md`  
- `SERVERSETUP1.md`

---

## ☁️ Project 2 — Docker Swarm + Jenkins Pipeline

In the second deployment, the system is upgraded to a **distributed, production-style architecture** using:

- Docker Stack (`docker-stack.yml`)  
- Jenkins Pipeline (automated CI/CD)  
- Monitoring Stack (`monitoring-stack.yml`)  
- Prometheus configuration (`prometheus.yml`)  

### Key Features:
- Service scaling (replicas)  
- Overlay networks (multi-node communication)  
- Docker Secrets (secure credentials)  
- Resource limits (CPU/Memory control)  
- Health checks (service reliability)  
- Rolling updates & rollback (zero downtime deployment)  

📄 Setup & details:  
- `README1swarm-deployment.md`  
- `SERVERSETUP2.md`

---

# 🧱 Shared Components

Both projects include:

- Application source code (PHP + MySQL)  
- `.env` file for configuration  
- `.dockerignore` to optimize builds  
- Architecture diagrams for deployment design  

---

# 🎯 Objective

This project demonstrates how to evolve from:
Simple container deployment → Distributed system with CI/CD, scaling, and monitoring


---

# 🔥 Outcome

By completing both deployments, the project showcases:

- Containerization (Docker)  
- Multi-container orchestration  
- CI/CD automation (Jenkins)  
- Cluster management (Docker Swarm)  
- Monitoring & observability  
- Production-ready DevOps workflow  
