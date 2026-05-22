# Production-Ready AWS EKS Cluster Provisioning & App Deployment via Terraform & GitOps CI/CD

> **Tech Stack Overview:** 🛠️ `Terraform` | ☁️ `Amazon Web Services (AWS)` | ☸️ `Kubernetes (EKS)` | 🚀 `GitHub Actions` | 🐳 `Docker`


This repository implements a fully automated, production-grade Infrastructure as Code (IaC) and GitOps Continuous Integration/Continuous Deployment (CI/CD) framework. It leverages **Terraform** to provision a highly available network infrastructure and an **Amazon EKS (Elastic Kubernetes Service)** cluster, while **GitHub Actions** drives the automated build, test, and containerized deployment lifecycle.

---

## 🏗️ Architecture & Component Overview

```text
[ Developer Push ] ──> [ GitHub Actions Pipeline ]
                              │
               ┌──────────────┴──────────────┐
               ▼                             ▼
     [ Infrastructure Stage ]        [ Application Stage ]
       • Terraform Lint/Plan           • Dockerize App Code
       • Remote State Lock             • Push to Amazon ECR
       • Deploy VPC & EKS Nodes        • Rolling Update via Kubectl
               │                             │
               └──────────────┬──────────────┘
                              ▼
                        [ AWS Cloud ]
```

### Infrastructure Core Components
*   **Networking (VPC Modules):** Custom Virtual Private Cloud (VPC) spanned across 3 Availability Zones (AZs) featuring isolated Public, Private, and Intra subnets.
*   **NAT Gateways:** Publicly routed NAT instances managing highly secure, outbound-only internet traffic for backend worker nodes.
*   **EKS Cluster (Control Plane):** Managed Kubernetes API endpoint integrated with AWS IAM OpenID Connect (OIDC) provider for granular service account roles.
*   **EKS Managed Node Groups:** Auto-scaling EC2 instances running inside private subnets optimized for enterprise workloads.

---

## 📂 Repository File Structure

```text
├── .github/                # GitHub Actions automated workflow definitions
│   └── workflows/          # CI/CD YAML pipelines (Infrastructure & App deployment)
├── app/                    # Monorepo containing the application source code
│   └── Dockerfile          # Multi-stage Docker build recipe for code containerization
├── environments/           # Environment-specific declarations
│   └── dev/                # Development configuration backend, variables, and outputs
│       ├── main.tf         # Entry point for the environment deployment
│       ├── variables.tf    # Custom input definitions
│       └── terraform.tfvars# Concrete dev environment values
├── k8s/                    # Plain Kubernetes manifests or Helm charts templates
│   ├── deployment.yaml     # Desired application state and rolling update strategy
│   └── service.yaml        # Internal networking endpoint exposure
└── modules/                # Reusable, encapsulated infrastructure blocks
    ├── vpc/                # Networks, subnets, route tables, and NAT resources
    └── eks/                # Control plane, security groups, and IAM managed node pools
```

---

## 🛠️ Local Workspace Prerequisites

To manually audit, debug, or invoke the infrastructure configuration locally, install the following binaries:

1.  **AWS CLI v2** configured with necessary IAM administrative tokens (`aws configure`).
2.  **Terraform v1.5+** tracking system infrastructure state patterns.
3.  **kubectl** matching the specific Kubernetes minor version configured in your EKS cluster.

---

## 🚀 Step-by-Step Infrastructure Local Execution

Follow these precise execution patterns to stand up or review the development infrastructure locally:

### 1. Repository Setup & Context Initialization
```bash
# Clone the repository
git clone https://github.com

# Move into the working directory
cd aws-eks-terraform-cicd

# Switch context to the active development track
git checkout feature/development
```

### 2. Provisioning Infrastructure via Terraform
```bash
# Change to the targeted Dev environment configuration
cd environments/dev

# Fetch providers, register modules, and hook into S3/DynamoDB remote state backend
terraform init

# Perform a dry-run to preview API resources bound for creation
terraform plan

# Execute provisioning across cloud endpoints (takes approx. 10-15 minutes)
terraform apply --auto-approve
```

### 3. Binding Your Local Terminal to EKS Cluster
Once the infrastructure returns a successful deployment message, construct your secure Kubernetes configuration mapping context:
```bash
aws eks update-kubeconfig --region <YOUR_AWS_REGION> --name <YOUR_EKS_CLUSTER_NAME>

# Verify target cluster nodes are online and running healthy
kubectl get nodes -o wide
```

---

## 🔄 Automated GitOps Workflow Engine (GitHub Actions)

The included CI/CD pipeline triggers automatically on every code push or Pull Request against the `feature/development` branch. It executes in two logical isolated operational stages:

### Stage 1: Infrastructure Validation & Execution
*   **Static Code Analysis:** Evaluates syntax soundness via `terraform fmt -check` and `terraform validate`.
*   **Spec Preview:** Performs an automated `terraform plan` and attaches structural outputs to open Pull Requests for peer transparency.
*   **Automated Apply:** Updates cloud infrastructure directly when code conditions merge seamlessly.

### Stage 2: Application Lifecycle Management
*   **Dynamic Building:** Triggers a multi-stage `docker build` using the Dockerfile inside `/app`.
*   **Registry Distribution:** Tags and pushes the built container artifact safely into **Amazon ECR** or specified private registries.
*   **GitOps Orchestrated Rollout:** Issues zero-downtime updates onto the Kubernetes active cluster via automated `kubectl apply -f k8s/` execution loops.

---

## 🔐 GitHub Secrets & OIDC Trust Configuration

This repository utilizes **AWS OpenID Connect (OIDC)** to securely authenticate with your AWS account without storing permanent IAM credentials. 

To enable the GitHub Actions pipeline to assume the deployment role, add the following entry to **Settings > Secrets and variables > Actions > Repository secrets**:


| Secret Key Name | Intended Architectural Use Case |
| :--- | :--- |
| `AWS_ROLE_ARN` | The Amazon Resource Name (ARN) of the IAM Role that GitHub Actions will assume to provision resources. |

> [!NOTE]  
> Ensure that your AWS IAM Role has a trust relationship configured to allow your specific GitHub repository (`robpalacios1/aws-eks-terraform-cicd`) and the active environment branches to request temporary security tokens.

---

## 🛑 Infrastructure Lifecycle Termination (Teardown)

To avoid recurring billing items on your AWS subscription, clean up the resources with this single command sequence:

```bash
cd environments/dev
terraform destroy --auto-approve
```

---

## Author

Created by **Roberto Palacios**.  
[LinkedIn profile](https://www.linkedin.com/in/robpalacios1/)