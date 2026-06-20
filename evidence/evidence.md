# Evidence

Screenshots taken during development, deployment and testing of the project.

## Public Endpoint

The app was deployed to AWS EKS and exposed at:

http://ab0ac32e9b0f44e659fe6482e2526f75-136789272.us-east-1.elb.amazonaws.com/api/users/

**NOTE: Infrastructure was destroyed after testing to evit costs**

## Local: running the app and tests on the local machine

`py manage.py test.png`: unit tests passing
`localgetUsers.png`: listing all users
`localcreateUser.png`: creating a user
`LocalgetUserId.png`: getting a user by ID

## Docker: app running inside a container

`DockercreateUser.png`: creating a user in the container
`DockergetUserId.png`: getting a user by ID in the container

## Kubernetes: app running in local cluster - Docker Desktop

`kubernetes running.png`: pods starting up
`kubernetes podsverify.png`: both pods in Running status
`kubernetescreateUser.png`: creating a user through K8s
`KubernetesgetUsers.png`: listing users through K8s
`KubernetesapiTestOK.png`: API responding correctly
`kubernetesaccessWork.png`: accessing the app through the service
`Kuber logs pod.png`: pod logs showing gunicorn running

## AWS: infrastructure created with Terraform

`outputTerraformDevsu.png`: terraform apply output with cluster info
`terraformDestroyDevsu.png`: terraform destroy confirmation
`VPCdevsu.png`: VPC in AWS console
`subnetDevsu.png`: subnets in different availability zones
`EKSworks.png`: EKS cluster running
`EC2workDevsu.png`: worker nodes active
`ECRdevsu.png`: Docker image stored in ECR
`IAMDevsu.png`: IAM roles created
`loadBalancerDevsu.png`: LoadBalancer with public URL
`kubePodsDevsu.png`: pods running in EKS

## Postman: API tests against the AWS LoadBalancer URL

`AWShttpWorks.png`: API responding from AWS
`AWSgetUsersHttp.png`: listing users from the public URL
`AWSgetUsersPostman.png`: GET request in Postman
`AWScreateUserPostman.png`: POST creating a user in Postman
`AWSgetUserIdPostman.png`: GET by ID in Postman

## CI/CD: GitHub Actions pipeline results

`GitHubActionsOKDevsu.png`: all pipeline jobs passing
`1CICDLintTestCoverage.png` to `6CICDLintTestCoverage.png`: step by step pipeline execution (lint, tests, coverage, build, scan, push)
`CICDcreateUser.png`: POST test in the pipeline
`CICDgetUserId.png`: GET by ID test in the pipeline
`CICDworksDevsu.png`: pipeline running successfully
`getUsersCICD.png`: GET users in the pipeline
`pullRequestAddtoMain.png`: pull request merged to main
