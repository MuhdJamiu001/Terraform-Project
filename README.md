# Terraform AWS VPC + EC2 Project (Hands-on Beginner-Friendly Setup)

This repo is a practical Terraform project that provisions a basic AWS environment — **a VPC, public networking, security group rules, an SSH key pair, and an EC2 instance**. It’s designed to help you understand the “real flow” of AWS infrastructure setup, not just copy snippets and hope it works.

If you’re learning Terraform, this is the kind of project that teaches you how the pieces connect:
- Networking (VPC/subnets/routes)
- Security (security groups + SSH)
- Compute (EC2)
- Repeatable infrastructure (Terraform state + variables)

## Table of Contents

- [What This Project Creates (High Level)](#what-this-project-creates-high-level)
- [Before You Run Anything (Requirements)](#before-you-run-anything-requirements)
- [Project Structure (What Each File Does)](#project-structure-what-each-file-does)
- [How To Run This Project (Step-by-Step)](#how-to-run-this-project-step-by-step)
- [How To SSH Into Your EC2 Instance](#how-to-ssh-into-your-ec2-instance)
- [How To Destroy Everything (Clean Up)](#how-to-destroy-everything-clean-up)
- [Notes / Tips](#notes--tips)
- [Author](#author)

## What This Project Creates (High Level)

When you run `terraform apply`, you should end up with something like:

- ✅ A custom **VPC**
- ✅ **Public subnet(s)** (so the instance can reach the internet)
- ✅ An **Internet Gateway** + route table route to the internet
- ✅ A **Security Group** that allows SSH + HTTP
- ✅ An **EC2 instance** launched inside the public subnet
- ✅ Outputs (like public IP / instance ID)

## Before You Run Anything (Requirements)

### 1. Install Terraform

Make sure Terraform is installed:

```bash
terraform -version
```

### 2. Configure AWS Credentials

Terraform needs access to your AWS account. The easiest way:

```bash
aws configure
```

Or export credentials via environment variables (optional):

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_REGION="us-east-1"
```

**Important:** Use an IAM user with enough permissions for EC2 + VPC + Security Group + KeyPair.

## Project Structure (What Each File Does)

Terraform loads all `.tf` files in this folder automatically, so splitting them like this is perfect.

1. **provider.tf** — AWS Provider Setup  
   This file tells Terraform:  
   - Which provider to use (AWS)  
   - What region to deploy into  
   - (Sometimes) provider version constraints  

   If your provider is set here, Terraform will deploy everything into that configured region.

2. **variables.tf** — Your Inputs (The Control Panel)  
   This file defines the values you can change without editing resources directly.  
   Common variables you likely have here:  
   - region  
   - vpc_cidr  
   - public_subnet_cidr  
   - availability_zone (like us-east-1a)  
   - instance_type  
   - key_name  
   - tags, etc.  

   If you want this project to be reusable, this file is your best friend.

3. **vpc.tf** — The Networking Foundation  
   This is where the real infrastructure starts.  
   Typically this file creates:  
   - aws_vpc (your private network)  
   - aws_subnet (public subnet)  
   - aws_internet_gateway (gives the VPC internet)  
   - aws_route_table + aws_route_table_association  

   **Why this matters:**  
   Without a properly configured subnet + route to an internet gateway, your EC2 might launch but won’t behave like a public server.

4. **SecGrp.tf** — Security Group Rules (Traffic Control)  
   This file defines what traffic is allowed into/out of your instance.  
   Typical inbound rules:  
   - SSH (port 22) → so you can connect  
   - HTTP (port 80) → so web traffic can reach it  

   Outbound usually allows all traffic.  

   ⚠️ **Security warning (real talk):**  
   If SSH is open to 0.0.0.0/0, that means “the whole internet can try logging in.”  
   It works for learning, but in real projects you want SSH restricted to your IP only.

5. **Keypair.tf** — SSH Key Pair (So You Can Log In)  
   This file is usually creating:  
   - aws_key_pair  

   It registers a public key in AWS so your EC2 instance can accept SSH connections securely.  

   ✅ **Best practice:**  
   - Generate your own SSH key locally  
   - Use the public key in Terraform  
   - NEVER commit private keys to GitHub (ever)  

   To generate a key on Mac:  
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   ```

6. **Instance.tf** — The EC2 Instance  
   This is where the server is created.  
   This file typically contains:  
   - aws_instance  

   And connects it to:  
   - your subnet (subnet_id)  
   - your security group (vpc_security_group_ids)  
   - your key pair (key_name)  
   - your AMI (ami)  
   - your AZ (if specified)  

   If you hard-code an availability zone, the instance will always launch there.  
   That’s not “wrong” — it’s normal for a single-instance project.

7. **InstanceID.tf** — AMI Lookup / AMI Output  
   Based on the name, this file likely does one of these:  
   - uses a data "aws_ami" ... block to dynamically fetch an AMI  
   - outputs the AMI ID for visibility  

   If you used an AMI data source, it automatically fetches the right image for your provider region.

8. **output.tf** — Outputs (So You Don’t Go Hunting in AWS Console)  
   This prints useful values after apply, like:  
   - EC2 public IP  
   - instance ID  
   - VPC ID  
   - subnet ID  

   So instead of opening AWS console and clicking around like it’s a treasure hunt, you’ll see what you need immediately.

## How To Run This Project (Step-by-Step)

1. **Initialize Terraform**  
   ```bash
   terraform init
   ```

2. **Check Your Code**  
   ```bash
   terraform fmt
   terraform validate
   ```

3. **Preview What Terraform Will Create**  
   ```bash
   terraform plan
   ```

4. **Apply (Create the Infrastructure)**  
   ```bash
   terraform apply
   ```  
   Type `yes` when prompted.

## How To SSH Into Your EC2 Instance

After `terraform apply`, look for the public IP in outputs.

For Ubuntu AMI:  
```bash
ssh -i /path/to/your/private_key ubuntu@PUBLIC_IP
```

For Amazon Linux AMI:  
```bash
ssh -i /path/to/your/private_key ec2-user@PUBLIC_IP
```

If SSH fails, the usual culprits are: wrong username, wrong key path, SG not allowing port 22, or your subnet/route table isn’t truly public.

## How To Destroy Everything (Clean Up)

When you’re done (and don’t want surprise AWS charges):  
```bash
terraform destroy
```

## Notes / Tips

From real-life Terraform pain 😅:

- Don’t commit `.tfstate` files or private keys to GitHub.
- If your security group allows SSH from everywhere, restrict it later.
- If you want real “high availability,” you’ll need:  
  - Multiple subnets across multiple AZs  
  - A load balancer  
  - An auto-scaling group (ASG)  
- This project is a great starting point for that next step.

## Author

Built by Muhd Jamiu — Terraform learner project for AWS VPC + EC2 provisioning.
