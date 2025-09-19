# 🐮 Wisecow Application  

Wisecow is a demo application that prints **wise quotes** and **cowsay art**.  
This project demonstrates a full **DevSecOps pipeline** with:  

- **Containerization** (Docker)  
- **Container Registry** (GHCR)  
- **Kubernetes Deployment** (Kind cluster)  
- **Ingress + TLS** with cert-manager and nip.io  
- **GitHub Actions CI/CD** for automation  
- **Zero Trust Runtime Security** with KubeArmor  

---

## 📂 Project Structure  

```
.
├── Dockerfile
├── k8s/
│   ├── deploy.yaml
│   ├── ingress.yaml
│   └── service.yaml
├── .github/workflows/
│   └── ci-cd.yaml
└── README.md
```

---

## 🚀 Getting Started  

### 1️⃣ Prerequisites  

- Docker  
- [Kind](https://kind.sigs.k8s.io/) (Kubernetes-in-Docker)  
- kubectl  
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)  
- [cert-manager](https://cert-manager.io/)  
- [KubeArmor](https://kubearmor.dev/) (for runtime security)  

---

### 2️⃣ Setup Kind Cluster with Ingress Ports  

```bash
cat <<EOF | kind create cluster --name wisecow --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

---

### 3️⃣ Deploy Wisecow App  

```bash
kubectl apply -f k8s/deploy.yaml -n wisecow
```

Check rollout:  

```bash
kubectl rollout status deployment/wisecow -n wisecow
```

---

### 4️⃣ Access via Ingress  

```bash
curl -k https://wisecow.127.0.0.1.nip.io
```

---

## 🔐 Zero Trust with KubeArmor  

**Install KubeArmor on Kind Cluster** 

```bash
helm repo add kubearmor https://kubearmor.github.io/charts
helm repo update
helm install kubearmor kubearmor/kubearmor -n kubearmor --create-namespace
```

Verify it’s running:

```bash
kubectl get pods -n kubearmor

```

Apply it:  

```bash
kubectl apply -f wisecow-zero-trust.yaml -n wisecow
```

---

## ⚙️ CI/CD with GitHub Actions  

The pipeline does the following:  

1. **Build & Push Docker image** → GitHub Container Registry (GHCR)  
2. **Deploy to Kind cluster** → Apply Kubernetes manifests  
3. **Verify Rollout** → Ensure successful deployment  

Workflow file: `.github/workflows/ci-cd.yaml`  

---

## 📸 Demo  

Access your app:  

```
https://wisecow.127.0.0.1.nip.io
```

You should see a **cowsay output with a wise quote** 🐮💡.  

---

## 🛡️ Security  

- Enforced **TLS communication** via Ingress + cert-manager  
- Applied **KubeArmor zero trust policies** for runtime security  

---
