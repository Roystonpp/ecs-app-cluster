package test

import (
		"testing"
		"github.com/gruntwork-io/terratest/modules/terraform"
		"github.com/gruntwork-io/terratest/modules/aws"
		"github.com/stretchr/testify/assert"
)

func testTerraform(t *testing.T) {
	var terraformOptions = terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../",
		awsRegion := GeRegion(t, nil, nil)

		approvedRegions := []string{"eu-west-1"}

	})

	defer terraform.destroy(t, terraformOptions)
}