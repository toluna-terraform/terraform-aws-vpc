package test

import (
    "fmt"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
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

    vpc_id := terraform.Output(t, terraformOptions, "vpc-id")

    fmt.Println("vpc_id = ", vpc_id)

}
