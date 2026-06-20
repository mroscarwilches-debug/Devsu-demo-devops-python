## DevOps Implementation

This section documents all the DevOps work done on top of the base application.

### Architecture

The following diagram shows how all the pieces connect — from a developer pushing code to the app running in AWS:

![Architecture Diagram](evidence/architecture.png)

**Important**: For a detailed step-by-step walkthrough of everything i did, see [stepbystep.md](stepbystep.md).

### Docker

The app is being Dockerized to make it portable and production-ready:

- **Base image:** `python:3.11-slim` — small and secure
- **Server:** Gunicorn with 2 workers instead of Django's built-in `runserver`
- **Security:** Runs as a non-root user (`appuser`)
- **Healthcheck:** Pings `/api/users/` every 30s to verify the app is alive
- **Startup:** Migrations run automatically before the server starts

**Build and run:**

```bash
docker build -t demo-devops-python .
docker run -p 8000:8000 -e DJANGO_SECRET_KEY="your-secret-key" -e DATABASE_NAME="db.sqlite3" demo-devops-python
```

### Kubernetes

The app runs in a dedicated namespace (`demo-devops`). 
We created a Deployment with 2 replicas, the app is always available, a LoadBalancer Service to expose it on port 80, and an HPA that scales up to 5 pods when CPU goes above 70%.

Configuration is separated from the code: non-sensitive values live in a ConfigMap and sensitive values in a Secret.

Each pod uses minimal resources — 50m to 200m CPU and 128Mi to 256Mi memory — since this is a lightweight API with SQLite.

**Deploy locally (minikube/Docker-Desktop):**

```bash
kubectl apply -f k8s/
kubectl get pods -n demo-devops
kubectl port-forward -n demo-devops service/demo-devops-service 8080:80
```

Then open http://localhost:8080/api/users/


### Infrastructure with Terraform (AWS)

I prefer Terraform to create the infrastructure in AWS. It provisions a VPC with 2 public subnets, EKS cluster with 2 worker nodes and an ECR repository to store the Docker image.

**Deploy the infrastructure:**

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After the apply, connect kubectl to the cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name demo-devops-cluster
```

**Destroy (important — do this when done to avoid costs):**

```bash
kubectl delete namespace demo-devops
# wait 60 seconds for the LoadBalancer to be removed
terraform destroy
```

### CI/CD Pipeline

Every time we push to `main` or open a pull request to `main`, GitHub Actions runs the pipeline automatically.

Stage 1: checks code quality with `flake8` and runs the tests with `coverage` (96% covered). Stage 2: builds the Docker image, scans it for vulnerabilities with Trivy, and pushes it to Docker Hub. 
Stage 3: connects to AWS and deploys the app to the EKS cluster.

On pull requests to the main **only Stage 1** runs, we don't deploy code that hasn't been reviewed. 
Stages 2 and 3 only run when code is **merged to main**.

The pipeline needs 4 secrets configured in GitHub (Settings → Secrets → Actions): `DOCKER_USERNAME` and `DOCKER_PASSWORD` for Docker Hub, and `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` for AWS.

Pipeline execution results: https://github.com/mroscarwilches-debug/Devsu-demo-devops-python/actions/runs/27857802125


### Technical Decisions

**Dedicated namespace for the app.** All Kubernetes resources live inside a `demo-devops` namespace. This keeps all organized, avoids conflicts with other apps in the cluster.

**LoadBalancer to expose the app.** A LoadBalancer give us a public URL that works from anywhere. This is what let us share the endpoint and test with Postman from the browser. Port-forward would work too but only locally.
This URL was delete when applied terraform destroy.

**Development in stages.** We built the project step by step: first Docker, then Kubernetes, then Terraform, then CI/CD, however every step was follow with a previously test before to push. 
Each stage was committed separately so the git history shows a clear progression of the work.
Each stage had its own branch (feature/dockerization, feature/kubernetization, feature/terraforming, feature/pipelining), merged to main through pull requests. 
After merging, branches were deleted to keep the repo clean. We kept the last branch as evidence of the branching workflow and good practices.

**Postman for API testing.** Postman shows the request, response, status code, and headers in a single view. 
We used it to verify the API works both locally with Docker and in AWS through the LoadBalancer URL. 
**The screenshots serve as evidence that everything runs correctly.**

### Environment Variables

The app reads its configuration from environment variables. Locally they come from the `.env` file, in Docker they're passed with `-e`, and in Kubernetes they come from the ConfigMap and Secret.

`DJANGO_SECRET_KEY`: Key Django uses to sign sessions and tokens
`DATABASE_NAME`: Name of the SQLite database file
`DEBUG`: Turns debug mode on or off
`ALLOWED_HOSTS`: Which domains can access the app

A `.env.example` file is included as a reference. Copy it to `.env` and fill in your values.


### Project Structure

```
demo-devops-python/
├── .github/workflows/
│   └── ci-cd.yml              # CI/CD pipeline
├── api/                        # Django app (models, views, tests)
├── demo/                       # Django settings
├── evidence/                   # Screenshots and deployment evidence
│   └── evidence.md
├── k8s/                        # Kubernetes manifests
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── hpa.yaml
├── terraform/                  # AWS infrastructure
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
├── Dockerfile
├── entrypoint.sh
├── .dockerignore
├── .env.example
├── requirements.txt
└── manage.py
```
