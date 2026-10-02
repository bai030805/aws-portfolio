# 项目介绍

1. 本项目演示三层高可用网站架构下的VPC架构
2. 本项目创建VPC及网络架构，包括Public Subnet、Private Subnet、Route Table、IGW等
3. 本项目用terraform进行资源创建

# 项目目标

1. 学习AWS三层架构设计
2. 学习Terraform基础设施即代码
3. 理解VPC、subnet、Route Table、IGW的关系
4. 为将来扩展到ALB/EC2/RDS打好网络基础
5. 作为AWS架构学习的作品集

# 架构说明



# Architecture Overview

## AWS Region

```
Region: ap-southeast-1
```

## Availability Zones

This design uses two Availability Zones:

```
ap-southeast-1a
ap-southeast-1b
```

The multi-AZ design provides the foundation for future high availability deployment.

---

# Network Architecture

## VPC Design

```
VPC CIDR:

10.0.0.0/16
```

The VPC is divided into three logical layers:

```
VPC 10.0.0.0/16

├── Public Layer
│
├── Application Layer
│
└── Database Layer
```

---

# Subnet Design

## Public Subnets

Used for Internet-facing resources.

Future resources:

- Application Load Balancer
- NAT Gateway


| Subnet | Availability Zone | CIDR |
|---|---|---|
| Public Subnet A | ap-southeast-1a | 10.0.1.0/24 |
| Public Subnet B | ap-southeast-1b | 10.0.2.0/24 |

---

## Private Application Subnets

Used for application workloads.

Future resources:

- ECS Tasks
- Application containers


| Subnet | Availability Zone | CIDR |
|---|---|---|
| App Private Subnet A | ap-southeast-1a | 10.0.11.0/24 |
| App Private Subnet B | ap-southeast-1b | 10.0.12.0/24 |

---

## Private Database Subnets

Used for database workloads.

Future resources:

- Amazon RDS


| Subnet | Availability Zone | CIDR |
|---|---|---|
| DB Private Subnet A | ap-southeast-1a | 10.0.21.0/24 |
| DB Private Subnet B | ap-southeast-1b | 10.0.22.0/24 |

---

# Network Diagram

```
                         Internet

                            |
                            |

                 Internet Gateway (IGW)

                            |

                    VPC 10.0.0.0/16


        +--------------------------------+
        |                                |
        |                                |
   ap-southeast-1a                 ap-southeast-1b


 Public Subnet A                 Public Subnet B
 10.0.1.0/24                     10.0.2.0/24


 App Private A                  App Private B
 10.0.11.0/24                   10.0.12.0/24


 DB Private A                   DB Private B
 10.0.21.0/24                   10.0.22.0/24


        +--------------------------------+
```

---

# Internet Gateway Design

## Internet Gateway Scope

An Internet Gateway is a VPC-level resource.

Design:

```
One VPC
 |
 +-- One Internet Gateway
 |
 +-- Multiple Availability Zones
```

The Internet Gateway is not created per Availability Zone.

AWS manages the high availability of the Internet Gateway.

---

# Route Table Design

## Public Route Table

Associated subnets:

- Public Subnet A
- Public Subnet B


Routing:

| Destination | Target |
|---|---|
| 10.0.0.0/16 | local |
| 0.0.0.0/0 | Internet Gateway |


Purpose:

Allow public subnet resources to communicate with the Internet.

---

## Private Application Route Table

Associated subnets:

- App Private Subnet A
- App Private Subnet B


Current routing:

| Destination | Target |
|---|---|
| 10.0.0.0/16 | local |


Future enhancement:

```
0.0.0.0/0 → NAT Gateway
```

This will allow ECS workloads to access the Internet without exposing them directly.

---

## Private Database Route Table

Associated subnets:

- DB Private Subnet A
- DB Private Subnet B


Routing:

| Destination | Target |
|---|---|
| 10.0.0.0/16 | local |


Purpose:

Keep database resources isolated from direct Internet access.

---

# Terraform Structure

Current Terraform files:

```
three-tier-web-app/

├── provider.tf
├── vpc.tf
├── subnet.tf
├── internet_gateway.tf
├── route_table.tf
├── route_table_association.tf
└── README.md
```

---

# Terraform Resources Created

Current implementation:

## VPC

- aws_vpc


## Subnets

- 6 AWS subnets

```
2 x Public Subnet
2 x Private Application Subnet
2 x Private Database Subnet
```


## Internet Connectivity

- 1 Internet Gateway


## Routing

- 3 Route Tables

```
Public Route Table
Private Application Route Table
Private Database Route Table
```


## Associations

- 6 Route Table Associations

```
Public Subnet → Public Route Table

App Private Subnet → App Private Route Table

DB Private Subnet → DB Private Route Table
```

---

# Deployment

Initialize Terraform:

```bash
terraform init
```

Format Terraform files:

```bash
terraform fmt
```

Validate configuration:

```bash
terraform validate
```

Review changes:

```bash
terraform plan
```

Deploy infrastructure:

```bash
terraform apply
```

---

# Validation

Validation checklist:

- [x] VPC created successfully
- [x] Six subnets created
- [x] Subnets distributed across Availability Zones
- [x] Internet Gateway attached to VPC
- [x] Public route table configured
- [x] Private route tables created
- [x] Subnets associated with correct route tables

---

# Security Considerations

Current design principles:

- Public resources are separated from private workloads
- Application layer does not receive direct Internet exposure
- Database layer is isolated from the Internet
- Network segmentation follows three-tier architecture principles

Future improvements:

- Security Groups
- IAM roles
- Secrets Manager
- Network ACL review

---

# Cost Considerations

## Free Resources

The following resources do not incur hourly charges:

- VPC
- Subnets
- Internet Gateway
- Route Tables
- Route Table Associations


## Resources That May Incur Charges Later

Future phases will introduce:

- NAT Gateway
- Application Load Balancer
- ECS Fargate
- Amazon RDS
- CloudFront


After testing, destroy the environment:

```bash
terraform destroy
```

---

# Next Steps

Future implementation phases:

## Phase 2: NAT Gateway

Add outbound Internet access for private application subnets.

Architecture:

```
Private App Subnet
        |
        |
   NAT Gateway
        |
        |
 Internet Gateway
```

---

## Phase 3: Application Layer

Add:

- ECR
- ECS Fargate
- ALB


Architecture:

```
Internet

   |

 ALB

   |

 ECS Tasks

   |

 RDS
```

---

## Phase 4: Database Layer

Add:

- Amazon RDS
- Multi-AZ deployment
- Database security controls

---

## Phase 5: Edge Layer

Add:

- CloudFront
- HTTPS
- CDN caching

---

# Lessons Learned

## 1. Subnets are not inherently public or private

A subnet becomes public or private based on its route table configuration.

Example:

```
Public Subnet:

0.0.0.0/0 → Internet Gateway
```

Private Application Subnet:

```
0.0.0.0/0 → NAT Gateway
```

---

## 2. Internet Gateway is a VPC-level resource

An Internet Gateway:

- belongs to a VPC
- is not associated with a specific Availability Zone
- does not require multiple deployments for HA

---

## 3. Route Tables define network behavior

The same subnet type can behave differently depending on route configuration.

Route tables are the key component controlling traffic flow inside and outside the VPC.

---

# Author Notes

This project is part of my AWS Cloud Architecture Portfolio.

The purpose is to demonstrate practical understanding of:

- AWS networking
- Infrastructure as Code
- Cloud architecture principles
- High availability design
- Security-oriented architecture thinking
