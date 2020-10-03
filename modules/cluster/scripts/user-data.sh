#!/bin/bash
echo "Setting up ECS cluster"
echo ${cluster_name}
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo