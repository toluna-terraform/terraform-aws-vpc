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
                "env_name": "terratest-create-vpc",
                "number_of_azs": 2,
                "env_type": "non-prod",
                "env_index": 8,
        },
 
    })

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    vpc_id := terraform.Output(t, terraformOptions, "exampleVpcId")
    fmt.Println("vpc_id = ", vpc_id)
    assert.NotEmpty(t, vpc_id)

    igw_id := terraform.Output(t, terraformOptions, "igwId")
    fmt.Println("igw_id = ", igw_id)
    assert.NotEmpty(t, igw_id)
}
