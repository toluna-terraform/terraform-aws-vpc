package vpc_tests

import (
    "fmt"
    "log"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"

    tolunavpcaws "github.com/toluna-terraform/terraform-test-library/modules/aws/vpc"
    tolunacommons "github.com/toluna-terraform/terraform-test-library/modules/commons"
    tolunacoverage "github.com/toluna-terraform/terraform-test-library/modules/coverage"
)

var moduleName = tolunacommons.GetModName()
var region = "us-east-1"
var env_name = "terratest-create-vpc-with-tgw-att"
var env_type = "non-prod"
var number_of_azs = 2
var env_index = 8
var create_tgw_attachment = true

func configureTerraformOptions(t *testing.T) *terraform.Options {
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options {
        TerraformDir : "../examples/create-vpc",

        // Variables to pass to Terraform module using -var options
        Vars: map[string]interface{}{
                "env_name": env_name,
                "number_of_azs": 2,
                "env_type": "non-prod",
                "env_index": 8,
                "create_tgw_attachment": create_tgw_attachment,
        },
     })
     return terraformOptions
}

func TestSetup(t *testing.T) {
    terraform.InitAndApply(t, configureTerraformOptions(t))
    tolunacoverage.WriteCovergeFiles(t, configureTerraformOptions(t), moduleName)
}

// Tests if Vpc created exists
func TestIfVpcExists(t *testing.T) {
    tolunacoverage.MarkAsCovered("terraform-aws-vpc", moduleName)

    // check vpc
    vpcId := terraform.Output(t, configureTerraformOptions(t), "example_vpc_id")
    fmt.Println("vpcId =", vpcId)
    tolunavpcaws.TestIfVpcExists(t, vpcId, region)


}

// Test if the Vpc has public and private subnets
func TestPublicAndPrivateSubnets(t *testing.T) {
    tolunacoverage.MarkAsCovered("terraform-aws-vpc", moduleName)

    //check public subnet
    publicSubnetId := terraform.Output(t, configureTerraformOptions(t), "public_subnets")
    fmt.Println("publicSubnetId =", publicSubnetId)
    assert.NotEmpty(t, publicSubnetId)

    //check public subnet
    privateSubnetId := terraform.Output(t, configureTerraformOptions(t), "private_subnets")
    fmt.Println("privateSubnetId =", privateSubnetId)
    assert.NotEmpty(t, privateSubnetId)
}

// Test if TGW attachment created
func TestIfTgwVpcAttCreated (t *testing.T) {
    tolunacoverage.MarkAsCovered("terraform-aws-vpc", moduleName)

    //check if NAT instance created
    tgwVpcAttachmentId := terraform.Output(t, configureTerraformOptions(t), "tgw_vpc_attachment_id")
    fmt.Println("tgwVpcAttachmentId = ", tgwVpcAttachmentId)
    assert.NotEmpty(t, tgwVpcAttachmentId)
}


// Clean up the infra created as part of setup above
func TestCleanUp(t *testing.T) {
        log.Println("Running Terraform Destroy")
        terraform.Destroy(t, configureTerraformOptions(t))
}
