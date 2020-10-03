## Implementation Notes
## Custom VPC created, with 2 public and 2 private subnets (this can be tested with using a bastion, as TCP ports are opens to the internal network (10.0.0.0/16))
## ECS Cluster with ngnix service, which runs 3 containers in 1 EC2 instance behind a private subnet for extra security on the instance
## ASG set-up for resillience, so if an instance goes down, it'll spin-up a new one (since persistent data isn't required in this task, I've excluded using ebs volume)

# Pre-requisites

1. In provider.tf, use your own ~/.aws/config profile, as I wanted to avoid using AWS tokens.

## Steps to run

1. terraform init
2. terraform apply

## Test

1. Once ECS task is healthy, access the webpage with the alb DNS
