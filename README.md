# terraform-aws-vpc
Toluna terraform module for AWS VPC

## Requirements
The module imports some configurations from SSM Parameters Store:
#### Minimum requirements:
- /infra/network_address_range
#### Transit Gateway integration:
- /infra/tgw/tgw_id
- /infra/tgw/tgw_role
- /infra/tgw/tgw_region
- /infra/tgw/route_cidr
- /infra/tgw/is_shared
- /infra/tgw/resource_share_name

## Parameters
```yaml
env_name
env_type
number_of_azs
env_index
```

## Toggles
#### Creating ECS VPE Endpoint
```yaml
create_ecs_vpce = true
```
- creates VPC Endpoints for ECS, ECS Agent, Telementry

#### Transit gateway attachment:
```yaml
create_tgw_attachment = true
```
- make sure the above required SSM parameters exist and refers to real and available values.
- TG can also be shared from another account with RAM (Resource Access Manager).
#### Private API - SAM integration:
```yaml
enable_private_api = true
```
The following resources will be created:
 - private VPC endpoint for execute-api service
 - Target group of the endpoint ENIs IP addresses
 - Security group for allowing access to the VPC endpoint from the entire VPC CIDR.
 - exported ids of the above resources as SSM params to be resolved from SAM templates.
 