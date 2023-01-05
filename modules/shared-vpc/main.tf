resource "aws_ram_resource_share" "shared_vpc" {
  name = "${var.env_name}-shared-vpc"
}

resource "aws_ram_principal_association" "sender_invite" {
  principal          = data.aws_organizations_organization.org_arn.arn
  resource_share_arn = aws_ram_resource_share.shared_vpc.arn
}

resource "aws_ram_resource_association" "shared_vpc" {
  count  = length(var.subnets)
  resource_arn       = var.subnets[count.index]
  resource_share_arn = aws_ram_resource_share.shared_vpc.arn
}