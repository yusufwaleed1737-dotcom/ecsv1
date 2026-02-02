# AWS ECS Fargate Deployment - Threat Modelling Application

## Live Demo:

https://github.com/user-attachments/assets/646370b5-fe71-4c32-8b36-a3108b49458a

## Project Structure:

```text
ECS-Threat-Composer-App/
│
├── app/                         
│   └── Dockerfile
│
│
├── infrastructure/              
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   ├── terraform.tfvars
│   │
│   ├── modules/                 
│   │   ├── network/
│   │   ├── security/
│   │   ├── alb/
│   │   ├── ecs/
│   │   ├── acm/
│   │   └── s3/
│   │
│   └── iam/                     
│       ├── github-least-privilege.json
│       └── github-oidc-trust.json
│
├── .github/
│   └── workflows/
│       ├── build.yaml           
│       └── deploy.yaml          
|
├── .gitignore
└── README.md
```

## Project Overview:

This project deploys AWS' Threat Modelling web application onto AWS infrastructure (production style) using **Terraform and GitHub Actions CI/CD**.

The system is designed with:

- High Availability (Multi AZ)
- Private networking for workloads
- Infrastructure as Code (IaC)
- Automated container builds and deployments
- Secure OIDC authentication from GitHub to AWS

## Architecture Diagram:

![Threat Model - Architecture Diagram](https://github.com/user-attachments/assets/4f2338cb-c52e-4666-9b03-c4e43fefbf86)

## Architecture Summary:

The application runs as a **containerised workload on ECS Fargate**, behind an **Application Load Balancer** inside a custom VPC spanning two **Availability Zones** for fault tolerance.

Traffic flow:
```
User → Route53 → ALB (HTTPS) → ECS Fargate Tasks → App
```
*Infrastructure provisioning and application deployment are fully automated through GitHub Actions CI/CD workflows.*

## Infrastructure Components:

| Layer                | Services Used                           |
| ---------------------|-----------------------------------------|
| Compute              | ECS Fargate, Task Definitions, Services |
| Networking           | VPC, Public and Private Subnets (2 AZs), IGW, NAT Gateways |
| Load Balancing       | Application Load Balancer, Target Groups| 
| Security             |  Security Groups, IAM Roles, OIDC Authentication      |
| Certificates         | AWS Certificate Manager (ACM)           |
| DNS                  | Route 53                                |
| Storage              | S3 (ALB Access Logs)                    |
| Logging              | CloudWatch Log Groups                   |
| Container Registry   | Amazon ECR                              |
| State Management     | S3 backend + DynamoDB locking           |

## Network Design:

| Subnet Type       | Purpose           |
| ------------------|-------------------|
| Public Subnets    | ALB + NAT Gateways|
| Private Subnets   | ECS Fargate Tasks |

- IGW provides public access
- NAT Gateways allow private tasks to pull images 
- Tasks have no public IPs

## Load Balancing & TLS:

- HTTP (80) → Redirected to HTTPS
- HTTPS terminated at the ALB using ACM certificate
- ALB forwards traffic to ECS tasks on port 80

## CI/CD Pipeline:

### Build Pipeline:
Triggered on *push* to `main`:
- Docker image built from Node + Nginx multi-stage Dockerfile
- Image pushed to Amazon ECR using GitHub OIDC

### Deployment Pipeline:
- Terraform provisions infrastructure
- Latest ECR image URI is injected into a new ECS task definition
- ECS service is updated with a new task definition revision (triggers redeployment)
- Health checks verify rollout success

## Security Model:

| Area                | Implementation                |
| --------------------|-------------------------------|
| CI/CD Auth          | GitHub OIDC → IAM Role        |
| Network Isolation   | Private subnets for ECS tasks |
| TLS                 | ACM certificate               |
| Ingress rules       | Only ALB → ECS on port 80     |
| Egress rules        | Outbound traffic on HTTP/S    |
| State Security      | Encrypted S3 backend          |

## High Availability & Resilience:

- Multi AZ deployment
- ALB health checks
- ECS service auto-replaces unhealthy tasks
- Terraform state locking via DynamoDB

## Observability:

- ALB access logs → S3
- ECS logs → CloudWatch
- Deployment Pipeline performs automated post-deployment health validation

## Local App Setup:
```bash
yarn install
yarn build
yarn global add serve
serve -s build
```
Then visit `http://localhost:3000`

## Domain Dashboard:

![Domain Dashboard](https://github.com/user-attachments/assets/a5ea64e9-f45b-40c3-b271-00ce49985d12)

## Security Certificate:

![Security certificate](https://github.com/user-attachments/assets/4cbdaebf-870c-432d-9dc7-8bbb2aea1060)

## Build Pipeline:

![Push pipeline complete](https://github.com/user-attachments/assets/45b89ac2-c3c1-4beb-8082-9a5415668827)

## Deploy Pipeline:

![Complete build pipeline](https://github.com/user-attachments/assets/892d54e2-bb0d-4963-838b-f04b161b6f51)






