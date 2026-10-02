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

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/dcb8eefe-be08-4453-ab67-7636342bfeea" />

**Region**: ap-southeast-1

**Availability Zones**: ap-southeast-1a, ap-southeast-1b

**VPC CIDR**: 10.0.0.0/16

**Public Subnet**
| Subnet | Availability Zone | CIDR |
|---|---|---|
| Public Subnet A | ap-southeast-1a | 10.0.1.0/24 |
| Public Subnet B | ap-southeast-1b | 10.0.2.0/24 |


**App Private Subnet**
| Subnet | Availability Zone | CIDR |
|---|---|---|
| App Private Subnet A | ap-southeast-1a | 10.0.11.0/24 |
| App Private Subnet B | ap-southeast-1b | 10.0.12.0/24 |


**DB Private Subnet**

| Subnet | Availability Zone | CIDR |
|---|---|---|
| DB Private Subnet A | ap-southeast-1a | 10.0.21.0/24 |
| DB Private Subnet B | ap-southeast-1b | 10.0.22.0/24 |


# Terraform 部署

```bash

# Initialize Terraform:
terraform init


# Format Terraform files:
terraform fmt

# Validate configuration:
terraform validate


# Review changes:
terraform plan

# Deploy infrastructure:
terraform apply

```


# 验证列表

- [x] VPC created successfully
- [x] Six subnets created
- [x] Subnets distributed across Availability Zones
- [x] Internet Gateway attached to VPC
- [x] Public route table configured
- [x] Private route tables created
- [x] Subnets associated with correct route tables



# 安全考虑

- 公网访问与内网访问分开
- 应用层不会暴露到互联网
- 数据库层与互联网隔离
- 网络分段遵循三层架构的最佳实践

# 成本考虑

以下为免费资源：
- VPC
- Subnets
- Internet Gateway
- Route Tables
- Route Table Associations

测试完成后，删除环境：
```bash
terraform destroy
```



# 经验总结

IGW
* Internet Gateway（IGW）的高可用由 AWS 负责，用户不需要也不能自己部署多个 IGW 来实现 HA。
* Internet Gateway（IGW）不是 AZ 级别的资源，而是 VPC 级别的资源。
* 一个 VPC 只需要一个 IGW，不需要每个 AZ 创建一个。

创建路由表
* 每一个 Route Table 创建后，都会自动有一条：10.0.0.0/16 -> local
* 所以如果只是AWS内部使用，可以不用单独设置路由
* 10.0.0.0/16 → local 是 VPC 内部通信的默认路由，它包含你的 10.0.1.0/24 subnet，是正常且必须存在的。






