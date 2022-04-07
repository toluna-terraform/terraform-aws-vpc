package test

import (
    "fmt"
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAwsVpcCreaton (t *testing.T) {
    t.Parallel()

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options {
        TerraformDir : "../examples/create-vpc-with-nat-ins",
 
    })

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    vpc_id := terraform.Output(t, terraformOptions, "vpc-id")
    fmt.Println("vpc_id = ", vpc_id)


}
