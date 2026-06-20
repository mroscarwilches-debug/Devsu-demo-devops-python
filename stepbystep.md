# Step by Step

This file is about everything i did to build the DevOps infrastructure for this project.

---

## Step 1: Running the app locally

Before touching anything, i made sure the base application works. The unit tests were executed and each endpoint was tested manually.

The 3 unit tests passed without issues:

![Unit tests passing with manage.py test](evidence/py%20manage.py%20test.png)

The GET endpoint was tested to list all users from the local server:

![Listing all users from localhost](evidence/localgetUsers.png)

A new user was created with a POST request to make sure the API accepts data correctly:

![Creating a new user locally with POST](evidence/localcreateUser.png)

Fetching a single user by ID was also verified:

![Getting a specific user by ID from localhost](evidence/LocalgetUserId.png)

---

## Step 2: Dockerizing the app

The Dockerfile was created with a slim Python image, a non-root user for security, Gunicorn as the production server, and an entrypoint that runs migrations automatically.

After building the image, the same endpoints were tested inside the container to confirm everything works the same way:

![Creating a user inside the Docker container](evidence/DockercreateUser.png)

![Getting a user by ID inside the Docker container](evidence/DockergetUserId.png)

---

## Step 3: Deploying to Kubernetes locally

Seven Kubernetes manifests were written and deployed to a local cluster running on Docker Desktop.

First, the pods were checked to confirm they started correctly:

![Pods starting up in the local cluster](evidence/kubernetes%20running.png)

Then both pods reached Running status with no restarts:

![Both pods running and ready](evidence/kubernetes%20podsverify.png)

A user was created through the Kubernetes service:

![POST request to create a user through K8s](evidence/kubernetescreateUser.png)

All users were listed to confirm the data was saved:

![GET request listing users through K8s](evidence/KubernetesgetUsers.png)

The API was verified to respond correctly through the cluster:

![API responding with a OK through K8s](evidence/KubernetesapiTestOK.png)

The app was accessed through the service to make sure routing works:

![Accessing the app through the Kubernetes service](evidence/kubernetesaccessWork.png)

The pod logs were checked to confirm Gunicorn is running and processing requests:

![Pod logs showing Gunicorn started with 2 workers](evidence/Kuber%20logs%20pod.png)

---

## Step 4: Creating the AWS infrastructure with Terraform

`terraform apply` was executed and it created 16 resources in AWS: VPC, subnets, internet gateway, EKS cluster, EC2 worker nodes, ECR repository, and IAM roles.

The terraform output shows the cluster endpoint and connection command:

![Terraform apply output with cluster name and endpoint](evidence/outputTerraformDevsu.png)

Each resource was verified in the AWS console:

![VPC created with DNS support enabled](evidence/VPCdevsu.png)

![Two subnets in different availability zones for high availability](evidence/subnetDevsu.png)

![EKS cluster in Active status](evidence/EKSworks.png)

![Two EC2 t3.small instances running as worker nodes](evidence/EC2workDevsu.png)

![Docker image stored in ECR with vulnerability scanning enabled](evidence/ECRdevsu.png)

![IAM roles for EKS cluster and worker nodes](evidence/IAMDevsu.png)

After deploying the K8s manifests to EKS, the pods were confirmed running in the cloud:

![Two pods running in the EKS cluster](evidence/kubePodsDevsu.png)

The LoadBalancer created a public URL to access the app from anywhere:

![LoadBalancer service with the public AWS URL](evidence/loadBalancerDevsu.png)

---

## Step 5: Testing the API in AWS with Postman

With the app running in EKS and exposed through the LoadBalancer, all endpoints were tested using Postman.

The API was confirmed reachable from the public URL:

![API responding through the LoadBalancer URL in the browser](evidence/AWShttpWorks.png)

![GET request listing users from the AWS public URL](evidence/AWSgetUsersHttp.png)

The same tests were run in Postman to get clean evidence of each endpoint:

![GET /api/users/ in Postman showing the list of users](evidence/AWSgetUsersPostman.png)

![POST /api/users/ in Postman creating a new user with dni and name](evidence/AWScreateUserPostman.png)

![GET /api/users/1/ in Postman returning a specific user](evidence/AWSgetUserIdPostman.png)

---

## Step 6: CI/CD Pipeline with GitHub Actions

The pipeline was set up with 3 jobs. Here's what each step looks like when it runs:

The full pipeline passing with all 3 jobs in green:

![GitHub Actions showing all 3 jobs completed successfully](evidence/GitHubActionsOKDevsu.png)

Job 1 runs flake8 for code quality, then the tests, then the coverage report:

![Flake8 lint check with 0 warnings](evidence/1CICDLintTestCoverage.png)

![Django tests running and passing](evidence/2CICDLintTestCoverage.png)

![Coverage report showing 96% code coverage](evidence/3CICDLintTestCoverage.png)

Job 2 builds the Docker image, scans it with Trivy, and pushes it to Docker Hub:

![Docker image building in the pipeline](evidence/4CICDLintTestCoverage.png)

![Trivy scanning the image for vulnerabilities](evidence/5CICDLintTestCoverage.png)

![Image pushed to Docker Hub with latest and SHA tags](evidence/6CICDLintTestCoverage.png)

Job 3 connects to AWS and deploys the app to the EKS cluster:

![Pipeline deploying to EKS successfully](evidence/CICDworksDevsu.png)

The API was verified after the automated deployment:

![GET users after CI/CD deployment](evidence/getUsersCICD.png)

![POST create user after CI/CD deployment](evidence/CICDcreateUser.png)

![GET user by ID after CI/CD deployment](evidence/CICDgetUserId.png)

Pull requests were used to merge feature branches into main:

![Pull request merged to main branch](evidence/pullRequestAddtoMain.png)

---

## Step 7: Destroying the infrastructure

After taking all the evidence, the AWS infrastructure was destroyed to avoid costs. The Kubernetes namespace was deleted first and then `terraform destroy` was executed.

![Terraform destroy removing all 16 resources](evidence/terraformDestroyDevsu.png)


**Testing evidence.** For more detailes about the deployment, tests, and pipeline results are saved in the `evidence/` folder. 
See `evidence/evidence.md` for a description of each file.