# terraform-aws-vpc
Toluna terraform module for AWS VPC

## First setup
The VPC must be created before Transit Gateway can be attached. Therefor we need to initialize a new environment in two stages:
```bash
terraform apply -target=module.aws_vpc -var create_tgw_attachment=false
```
```bash
terraform apply
```