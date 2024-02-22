# Flask Application Deployed using Terraform on a cluster (minikube)

Flask application to deploy the zero downtime app on the cluster


## Prerequisites

Before getting started, ensure you have the following installed:

- Docker
- kubectl utility

## Getting Started

Follow these steps to run the Flask application locally using Docker:

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd <repository-folder>

2. **Build Docker for you application**:
  - Build a Dockerfile for you app
  - Build docker image
    
   ```bash
   docker build -t <image_name>:<tag_name> .
   ```

3. **Config changes**:
  - Replace the image name in the app deployment resource. (This should ideally be more modularised. You should be able to give all info to terraform in the config file.)
  - MySql Connections: 
    \# Replace these fields from  terrafor/db/main.tf config resource 
    This should ideally be more modularised. You should be able to give all info to terraform in the config file.
  - Push it to a repository like DockerHub (push it to minikube in case of local cluster)

4. **Run terraform code to deploy app, its corresponding db, prometheus and fluentd**:

   ```bash
    terraform plan
    terraform apply
   ```

    You can run kubectl commands to check that all service, deployment, pods, ingress are running as expected.

# Notes: 
1. I have also created terraform code to deploy Jenkins.
2. This is a basic module. A lot of necessary improvements on security practices and modularising can be done.
   - Storing the tfstate in S3.
   - Modularising tf code
   - Setting up non root for various application such as Docker, mysql etc.
   - Writing better and more test cases covering all tests.