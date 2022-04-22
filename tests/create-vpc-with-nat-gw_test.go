package test

import (
    "fmt"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestAwsVpcCreaton (t *testing.T) {
    t.Parallel()

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options {
        TerraformDir : "../examples/create-vpc",

        // Variables to pass to Terraform module using -var options
        Vars: map[string]interface{}{
                "env_name": "terratest-create-vpc-with-nat-gw",
                "number_of_azs": 2,
                "env_type": "non-prod",
                "env_index": 8,
                "create_nat_gateway": "true",
        },
 
    })

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)


    vpc_id := terraform.Output(t, terraformOptions, "example_vpc_id")
    fmt.Println("vpc_id = ", vpc_id)
    assert.NotEmpty(t, vpc_id)

    igw_id := terraform.Output(t, terraformOptions, "igw_id")
    fmt.Println("igw_id = ", igw_id)
    assert.NotEmpty(t, igw_id)

    private_subnet_id := terraform.Output(t, terraformOptions, "private_subnets")
    fmt.Println("private_subnets = ", private_subnet_id )
    assert.NotEmpty(t, private_subnet_id )

    public_subnet_id := terraform.Output(t, terraformOptions, "public_subnets")
    fmt.Println("pubilc_subnets = ", public_subnet_id )
    assert.NotEmpty(t, public_subnet_id )

    natgw_id := terraform.Output(t, terraformOptions, "natgw_id")
    fmt.Println("natgw_id = ", natgw_id)
    assert.NotEmpty(t, natgw_id)
}
