# Automated-Security-and-Compliance-Monitoring-for-Kubernetes-Microservices

## 📌 Project Overview

This project focuses on **automated security monitoring, compliance enforcement, and observability** for Kubernetes microservices using various open-source tools. It ensures **secure deployment, real-time monitoring, and vulnerability scanning** of applications within a Kubernetes cluster.

### **🔹 Key Features:**

- **Cluster Setup:** Kind (Kubernetes-in-Docker) used to create a local multi-node cluster.
- **GitOps Deployment:** ArgoCD automatically syncs applications from a Git repository.
- **Monitoring & Observability:** Prometheus collects metrics, and Grafana provides real-time visualization.
- **Security & Compliance:**
  - **Kyverno:** Enforces security policies and validates Kubernetes configurations.
  - **Kube-Bench:** Runs CIS security compliance checks to validate Kubernetes cluster security.
  - **Kubescape:** Scans for misconfigurations, vulnerabilities, and compliance issues.
- **Automation:** A cron job triggers regular security scans, generating compliance reports.
- **Debugging Tools:** Troubleshooting commands for debugging networking, Minikube, and kubeadm issues.

---

## 🚀 Architecture Diagram

*(Include a diagram here if you have one)*

---

## 📋 Prerequisites

Before deploying, ensure you have:

### **1️⃣ System Requirements**

- **OS:** Ubuntu 20.04 or later
- **CPU:** Minimum 4 cores
- **RAM:** At least 4GB (8GB recommended)
- **Storage:** At least 20GB of free disk space

### **2️⃣ Required Tools**

Install the following tools before setting up the Kubernetes cluster:

```bash
sudo apt update && sudo apt install -y docker.io curl wget git
```

- **Kind:** A lightweight Kubernetes cluster orchestrator that runs inside Docker, making it ideal for local testing.
- **Kubectl:** The official Kubernetes CLI tool used for interacting with the cluster, managing deployments, and inspecting resources.
- **Helm:** A package manager for Kubernetes that simplifies the deployment and management of applications using predefined charts.
- **ArgoCD:** A declarative GitOps tool that ensures applications deployed on Kubernetes always remain in sync with their source repositories.
- **Prometheus:** A powerful monitoring system designed to scrape, store, and analyze time-series data, primarily used for Kubernetes cluster monitoring.
- **Grafana:** A visualization platform that integrates with Prometheus to provide real-time dashboards and alerts for cluster health and application performance.
- **Kyverno:** A Kubernetes-native policy management tool that automates security enforcement by validating and mutating Kubernetes resource configurations.
- **Kube-Bench:** A security benchmarking tool that checks Kubernetes cluster configurations against the CIS (Center for Internet Security) Kubernetes Benchmark.
- **Kubescape:** A Kubernetes security scanner that detects misconfigurations, RBAC vulnerabilities, and compliance issues based on NSA and MITRE ATT&CK frameworks.

---

## ⚡ Installation Steps

### **1️⃣ Set Up Kubernetes Cluster (Kind)**

```bash
kind create cluster --config=config.yml
kubectl get nodes
```

**Debugging Issues:**
- If the cluster fails to start, check logs using:
  ```bash
  docker ps
  docker logs <kind_container_id>
  ```
- Ensure Docker is running:
  ```bash
  sudo systemctl start docker
  ```

### **2️⃣ Install ArgoCD for GitOps Deployment**

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
```

**Common Issues & Fixes:**
- If ArgoCD pods are stuck in `Pending`, check the node status:
  ```bash
  kubectl describe node
  kubectl get events -n argocd
  ```
- If port-forwarding fails, kill any existing process using the port:
  ```bash
  sudo lsof -i :8443
  sudo kill -9 <pid>
  ```

### **3️⃣ Deploy Prometheus & Grafana for Monitoring**

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

**Troubleshooting:**
- If the Prometheus UI is not accessible, use:
  ```bash
  kubectl get svc -n monitoring
  kubectl port-forward svc/prometheus-server -n monitoring 9090:9090
  ```

### **4️⃣ Install Security & Compliance Tools**

#### **Kyverno - Policy Enforcement**

```bash
helm install kyverno kyverno/kyverno -n kyverno --create-namespace
```

#### **Kube-Bench - CIS Benchmarking**

```bash
helm repo add aquasecurity https://aquasecurity.github.io/helm-charts
helm install kube-bench aquasecurity/kube-bench --namespace kube-bench --create-namespace
kubectl logs -l app=kube-bench
```

#### **Kubescape - Misconfiguration Scanner**

```bash
curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | /bin/bash
kubescape scan framework nsa --include-namespaces default --format pdf --output security-report.pdf
```

---

## 🛠️ Usage & Monitoring

### **1️⃣ Accessing ArgoCD Dashboard**

```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
kubectl port-forward -n argocd service/argocd-server 8443:443 --address=0.0.0.0 &
```

### **2️⃣ Viewing Prometheus & Grafana Dashboards**

```bash
kubectl port-forward svc/prometheus-server -n monitoring 9090:9090 --address=0.0.0.0 &
kubectl port-forward svc/grafana -n monitoring 3000:80 --address=0.0.0.0 &
```

---

## 🔐 Security & Compliance

### **1️⃣ Running Security Scans**

```bash
kubescape scan framework nsa --include-namespaces default
kubectl logs -l app=kube-bench
```

### **2️⃣ Automating Security Scans (Cron Job)**

```bash
crontab -e
0 */6 * * * kubescape scan framework nsa --include-namespaces default --format pdf --output /reports/security-report.pdf && mail -s "K8s Security Report" user@example.com < /reports/security-report.pdf
```

---

## 📌 Conclusion & Future Enhancements

- **Achievements:** Automated security monitoring, GitOps deployment, and real-time observability.
- **Future Enhancements:** Extend multi-cluster security enforcement and integrate AI-driven anomaly detection.

---

## 📜 References

- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Prometheus](https://prometheus.io/docs/introduction/overview/)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [Kubescape](https://hub.armosec.io/docs)



