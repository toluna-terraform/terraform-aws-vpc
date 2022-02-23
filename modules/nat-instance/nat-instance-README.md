# Nat instance module.
Official Amazon documentation was used for nat instance module creation:<br>
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html

## <ins>What module does?</ins>
```yaml
1. Set up an EC2 instance that is capable of performing NAT operations.
2. Disable the “Source/Destination check” on instance in AWS.
3. Add a rule to the routing table(s) to route internet-directed traffic through nat instance.
4. Make sure the security group and Network ACLs of the NAT instance accepts connections from the hosts it needs to route traffic for.
```
## <ins>Usage</ins>
#### in vpc.tf file set the following :
```yaml
  create_nat_instance = true
  nat_instance_type = "<instance type>"
```
- If nat_instance_type is not provided type "t3.nano" will be used.

# Table of ec2 instances types
#### You can use the following command to determine which instance type is best for your needs:
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