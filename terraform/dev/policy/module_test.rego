# Unit tests using the Open Policy Agent and Conftest

package main

has_field(obj, field) {
	obj[field]
}

# Testing for the right aws region
deny[msg] {
    regio := input.provider[name].region
    regio == "eu-west-2"
    msg = sprintf("aws region must be eu-west-1:", [regio])
}

deny[msg] {
    regio := input.provider[name].region
    regio == "eu-central-1"
    msg = sprintf("aws region must be eu-west-1:", [regio])
}

deny[msg] {
    regio := input.provider[name].region
    regio == "eu-west-3"
    msg = sprintf("aws region must be eu-west-1:", [regio])
}

deny[msg] {
    regio := input.provider[name].region
    regio == "eu-south-1"
    msg = sprintf("aws region must be eu-west-1:", [regio])
}

deny[msg] {
    type := input.module[name].launch_type
    type == "EC2"
    msg = sprintf("ECS launch_type is not valid.", [type])
}

deny[msg] {
    network := input.module[name].network_mode
    network == "bridge"
    msg = sprintf("The network_mode chosen is not valid for this module", [network]) 
}

deny[msg] {
    network := input.module[name].network_mode
    network == "host"
    msg = sprintf("The network_mode chosen is not valid for this module", [network]) 
}
# test_fails_with_non_euwest1_region {
#     deny["aws region must be equal to the following:"] with input as {"provider": {"aws": {"region": "eu-west-1"}}}
# }

# Test to ensure a public ip is used for AWS ECS
# deny[msg] {
#     assign_public_ip := input.resource.aws_ecs_service[name]
#     assign_public_ip == false
#     msg = sprintf("Current ECS config does not have a public IP", [name])
# }