# AWS Nat instance.

Terraform VPC sub module which creates a nat instance for private networks.<br>

*A NAT (Network Address Translation) instance is, like a bastion host, an EC2 instance that lives in your public subnet.<br>
A NAT instance, however, allows your private instances outgoing connectivity to the internet<br><u>while at the same time blocking inbound traffic from the internet</u>.*

## <ins>Usage</ins>
```hcl
module "aws_vpc" {
  source                = "toluna-terraform/vpc/aws"
  version               = "~>1.0.4"

  env_name              = "<string>"
  env_type              = "<string>"
  env_index             = "<int>"

  number_of_azs         = "<int>"
  create_nat_instance   = "<bool>"
}
```

## <ins>What module does?<ins>
By default this module will provision:
1. EC2 linux instance which will perform as nat instance.
2. Routes for private networks which will forward the traffic to nat instance's ENI.
3. SSM param with ssh key of nat instance.

## <ins>Nat Instance type<ins>.
The type of nat instance.<br>
By default `nat_instance_type` is `"t3.micro"`.<br>
in order to change the default add an attribute `nat_instance_type` with desired value.<br>
<u>In case of debugging you need to open an SSH port because inbound traffic from the internet is blocked by default</u>.
```hcl
module "aws_vpc" {
  source                = "toluna-terraform/vpc/aws"
  version               = "<version>"

  env_name              = "<string>"
  env_type              = "<string>"
  env_index             = "<int>"

  create_nat_instance   = "<bool>"
  nat_instance_type     = "<string>"
}
```
You can find a list of all instances types [here](https://aws.amazon.com/ec2/instance-types/)<br>
Or use the following command to determine which instance type is best for your needs:
```
aws ec2 describe-instance-types --filters "Name=instance-type,Values=t3.*" --query "sort_by(InstanceTypes,&MemoryInfo.SizeInMiB)[*].{InstanceType:InstanceType,Network:NetworkInfo.NetworkPerformance,CPU:VCpuInfo.DefaultVCpus,Memory:MemoryInfo.SizeInMiB}" --output table
```
## <ins>Output</ins>
```yaml
------------------------------------------------------
|                DescribeInstanceTypes               |
+-----+----------------+---------+-------------------+
| CPU | InstanceType   | Memory  |      Network      |
+-----+----------------+---------+-------------------+
|  2  |  t3.nano       |  512    |  Up to 5 Gigabit  |
|  2  |  t3.micro      |  1024   |  Up to 5 Gigabit  |
|  2  |  t3.small      |  2048   |  Up to 5 Gigabit  |
|  2  |  t3.medium     |  4096   |  Up to 5 Gigabit  |
|  2  |  t3.large      |  8192   |  Up to 5 Gigabit  |
|  4  |  t3.xlarge     |  16384  |  Up to 5 Gigabit  |
|  8  |  t3.2xlarge    |  32768  |  Up to 5 Gigabit  |
+-----+----------------+---------+-------------------+
```
- Don't forget that it affects cost significantly.

## <ins>Compare NAT gateways and NAT instances.</ins><br>
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.nat_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ssm_agent_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.nat_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.nat_instance_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_network_interface.network_interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.route_to_nat_instace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.nat_instance_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ssm_parameter.nat_instance_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tls_private_key.nat_instance_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_instance.nat_instance_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_route_tables.route_tables_of_private_networks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_vpc.current_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.nat_instance_setup_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_ec2_instance_virtualization_type"></a> [amazon\_ec2\_instance\_virtualization\_type](#input\_amazon\_ec2\_instance\_virtualization\_type) | Amazon linux image for NAT instance. | `string` | `"hvm"` | no |
| <a name="input_amazon_ec2_linux_image"></a> [amazon\_ec2\_linux\_image](#input\_amazon\_ec2\_linux\_image) | Amazon linux image for NAT instance. | `string` | `"amzn2-ami-kernel-5.10-hvm-*"` | no |
| <a name="input_amazon_owner_id"></a> [amazon\_owner\_id](#input\_amazon\_owner\_id) | Amazong owner id. | `string` | `"137112412989"` | no |
| <a name="input_aws_vpc_id"></a> [aws\_vpc\_id](#input\_aws\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | n/a | `string` | n/a | yes |
| <a name="input_nat_instance_type"></a> [nat\_instance\_type](#input\_nat\_instance\_type) | n/a | `string` | n/a | yes |
| <a name="input_number_of_azs"></a> [number\_of\_azs](#input\_number\_of\_azs) | n/a | `number` | n/a | yes |
| <a name="input_private_subnets_ids"></a> [private\_subnets\_ids](#input\_private\_subnets\_ids) | n/a | `any` | n/a | yes |
| <a name="input_public_subnets_ids"></a> [public\_subnets\_ids](#input\_public\_subnets\_ids) | n/a | `any` | n/a | yes |
| <a name="input_ssm_agent_policy"></a> [ssm\_agent\_policy](#input\_ssm\_agent\_policy) | Policy of SSM agent. | `string` | `"arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_instance"></a> [nat\_instance](#output\_nat\_instance) | n/a |
| <a name="output_nat_instance_id"></a> [nat\_instance\_id](#output\_nat\_instance\_id) | n/a |

## Authors

Module is maintained by [Evgeny Gigi](https://github.com/evgenygigi).