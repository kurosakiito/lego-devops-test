module "network"{
  source = "./modules/network"
  
  name = "${var.name}" 
  az = "us-east-1a,us-east-1b"
  cidr_block = "10.0.0.0/16" 
}

module "ecs_cluster" {
  source = "./modules/cluster"
  
  cluster_name = "${var.name}-cluster"
  name = "${var.name}"
  security_group_id = ["${module.network.security_group_id}"]
  private_subnet_id = "${module.network.private_subnet_id}"
  region = "${var.region}"
 }

module "services" {
  source = "./modules/services"
  
  name = "${var.name}"
  cluster_id = "${module.ecs_cluster.cluster_id}"
  target_group_arn = "${module.network.target_group_arn}"
  hello_target_group_arn = "${module.network.hello_target_group_arn}"
  text_target_group_arn = "${module.network.text_target_group_arn}"
}