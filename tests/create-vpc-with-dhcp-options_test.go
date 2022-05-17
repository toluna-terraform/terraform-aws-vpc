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
var env_name = "terratest-create-vpc-with-dhcp-options"
var env_type = "non-prod"
var number_of_azs = 2
var env_index = 8
var enable_dhcp_options = true
var dhcp_options_domain_name = "tests.devops-toluna.com"
var dhcp_options_domain_name_servers = [] string {"dummy1_DNS", }

func configureTerraformOptions(t *testing.T) *terraform.Options {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/create-vpc",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
                "env_name": env_name,
                "number_of_azs": number_of_azs,
                "env_type": env_type,
                "env_index": env_index,
                "enable_dhcp_options" : enable_dhcp_options,
                "dhcp_options_domain_name" : dhcp_options_domain_name,
                //"dhcp_options_domain_name_servers" :  dhcp_options_domain_name_servers,
		},
	})
	return terraformOptions

}

// Sets up the infra, and coverage
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

// Test if DHCP options set created
func TestIfDhcpOptionsSetCreated (t *testing.T) {
	tolunacoverage.MarkAsCovered("terraform-aws-vpc", moduleName)

        //check DHCP options set id
        dhcpOptionsSetId := terraform.Output(t, configureTerraformOptions(t), "dhcp_options_set_id")
        fmt.Println("dhcpOptionsSetId =", dhcpOptionsSetId )
        assert.NotEmpty(t, dhcpOptionsSetId)
}

// Clean up the infra created as part of setup above
func TestCleanUp(t *testing.T) {
	log.Println("Running Terraform Destroy")
	terraform.Destroy(t, configureTerraformOptions(t))
}
