### Terraform Practice

#### t001 Create EC2 instance

- Create vpc, subnet, security group (ingress & egress) & EC2 instance. Separete file for variables.

#### t002 Create EC2 instance using modules

- write provider and resource in ec2.tf file and give module reference in main.tf file for ec2.tf

#### t003 Create EC2 instance and install docker in it.

- main.tf
    - Variables
    - Resources block (aws_vpc,aws_subnet, aws_route_table, aws_internet_gateway, aws_route_table_association, aws_security_group, aws_instance)
    - Output block
- terraform.tfvars
    - contains variables and their values.

![img](t003_ec2_add_docker/img_t003.png)

#### t004 VPC using feature "EC2 and more"

- Create only the VPC resource or the VPC and other networking resources.

![img](t004_VPC_using_EC2andMore/img_t004.png)



